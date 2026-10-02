"""SQLite 재현 결과와 데이터 무결성을 pytest로 검증한다."""

import csv
import sqlite3
import subprocess
import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
pytestmark = pytest.mark.smoke


@pytest.fixture
def reproduced(tmp_path):
    db, results = tmp_path / "workshop.db", tmp_path / "results"
    command = [
        sys.executable,
        str(ROOT / "scripts/reproduce.py"),
        "--output",
        str(db),
        "--results",
        str(results),
    ]
    result = subprocess.run(
        command, cwd=ROOT, capture_output=True, text=True, timeout=30
    )
    assert result.returncode == 0, result.stdout + result.stderr
    return db, results, command


@pytest.fixture
def connection(reproduced):
    with sqlite3.connect(reproduced[0]) as conn:
        conn.execute("PRAGMA foreign_keys = ON")
        yield conn


def test_all_query_results_are_written(reproduced):
    assert len(list(reproduced[1].glob("query_*.txt"))) == 17


def test_sample_row_counts_and_foreign_keys(connection):
    with (ROOT / "tests/fixtures/sqlite-table-counts.csv").open() as source:
        for row in csv.DictReader(source):
            table = row["table_name"]
            assert table in {
                "instructors",
                "students",
                "courses",
                "enrollments",
                "payments",
                "attendance",
            }
            count = connection.execute(f'SELECT COUNT(*) FROM "{table}"').fetchone()[0]
            assert count == int(row["row_count"]), (table, count)
    assert connection.execute("PRAGMA foreign_key_check").fetchall() == []


def test_modification_examples_are_rolled_back(connection):
    with sqlite3.connect(":memory:") as original:
        original.executescript((ROOT / "sql/sqlite/schema.sql").read_text())
        original.executescript((ROOT / "sql/sqlite/seed.sql").read_text())
        query = "SELECT * FROM enrollments ORDER BY enrollment_id"
        assert (
            connection.execute(query).fetchall() == original.execute(query).fetchall()
        )


def test_invalid_foreign_key_is_rejected(connection):
    with pytest.raises(sqlite3.IntegrityError):
        connection.execute(
            "INSERT INTO enrollments VALUES (999, 999, 1, '2024-05-30', 'active', 0)"
        )
    connection.rollback()


def test_existing_database_is_preserved(reproduced):
    db, _, command = reproduced
    before = db.read_bytes()
    retry = subprocess.run(
        command, cwd=ROOT, capture_output=True, text=True, timeout=30
    )
    assert retry.returncode != 0
    assert db.read_bytes() == before


def query_result(results, number):
    lines = (results / f"query_{number:02d}.txt").read_text().splitlines()[2:]
    return list(csv.DictReader(lines, delimiter="\t"))


def test_course_aggregates_preserve_empty_courses_and_payment_totals(reproduced):
    with (ROOT / "tests/fixtures/sqlite-course-metrics.csv").open() as source:
        expected = {row["title"]: row for row in csv.DictReader(source)}
    enrollment_counts = {
        row["title"]: row["enrollment_count"] for row in query_result(reproduced[1], 8)
    }
    totals = {
        row["title"]: (row["paid_count"], row["total_paid"])
        for row in query_result(reproduced[1], 10)
    }
    assert enrollment_counts == {
        title: row["enrollment_count"] for title, row in expected.items()
    }
    assert totals == {
        title: (row["paid_count"], row["total_paid"]) for title, row in expected.items()
    }


def test_join_and_subquery_match_expected_paid_active_enrollments(reproduced):
    with (ROOT / "tests/fixtures/sqlite-paid-enrollments.csv").open() as source:
        expected = {tuple(row.values()) for row in csv.DictReader(source)}
    joined = {tuple(row.values()) for row in query_result(reproduced[1], 13)}
    subqueried = {tuple(row.values()) for row in query_result(reproduced[1], 14)}
    assert joined == expected
    assert subqueried == expected


def test_title_search_index_is_created(connection):
    indices = connection.execute("PRAGMA index_list(courses)").fetchall()
    assert "idx_courses_title" in {row[1] for row in indices}
    columns = connection.execute("PRAGMA index_info(idx_courses_title)").fetchall()
    assert [row[2] for row in columns] == ["title"]
