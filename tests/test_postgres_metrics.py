"""PostgreSQL 지표의 SQL-92 집계를 일대다 메모리 fixture로 검증한다."""

import re
import sqlite3
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]


@pytest.fixture
def portfolio():
    with sqlite3.connect(":memory:") as connection:
        connection.executescript(
            (ROOT / "tests/fixtures/portfolio-multiple-claims.sql").read_text()
        )
        yield connection


def metric_query(number):
    text = (ROOT / "sql/postgres/queries.sql").read_text()
    return re.search(rf"-- Q{number}\b[^\n]*\n(.*?)(?=\n-- Q\d+|\Z)", text, re.S).group(
        1
    )


def test_line_loss_ratio_counts_each_policy_premium_once(portfolio):
    rows = portfolio.execute(metric_query(12)).fetchall()
    assert rows == [("health", 150.0, 400.0, 0.375)]


def test_customer_ratio_includes_policies_without_claims(portfolio):
    rows = portfolio.execute(metric_query(22)).fetchall()
    assert rows == [
        ("CUS-B", "Lee", 50.0, 100.0, 0.5),
        ("CUS-A", "Kim", 100.0, 300.0, 0.3333),
    ]
