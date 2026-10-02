"""기존 SQL을 새 SQLite DB에서 실행하고 결과를 별도 경로에 기록한다."""

import argparse
import re
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SQL = ROOT / "sql/sqlite"


def statements(text):
    buffer = ""
    for char in text:
        buffer += char
        if char == ";" and sqlite3.complete_statement(buffer):
            yield buffer
            buffer = ""
    # 쿼리 끝에는 설명 주석만 남을 수 있다.
    remainder = re.sub(r"--[^\n]*", "", buffer).strip()
    if remainder:
        raise ValueError("세미콜론으로 끝나지 않은 SQL이 있습니다.")


def reproduce(output, results):
    if output.exists() or results.exists():
        raise FileExistsError(
            "기존 DB나 결과 디렉토리를 덮어쓸 수 없습니다. 새 경로를 지정하세요."
        )
    with sqlite3.connect(":memory:") as conn:
        conn.execute("PRAGMA foreign_keys = ON")
        conn.executescript((SQL / "schema.sql").read_text(encoding="utf-8"))
        conn.executescript((SQL / "seed.sql").read_text(encoding="utf-8"))
        text = (SQL / "queries.sql").read_text(encoding="utf-8")
        blocks = re.findall(r"-- Q(\d+): ([^\n]+)\n(.*?)(?=\n-- Q\d+:|\Z)", text, re.S)
        if len(blocks) != 17:
            raise ValueError("기존 SQLite 쿼리 17개를 찾을 수 없습니다.")
        captured = {}
        for number, title, body in blocks:
            lines = [f"Q{number}: {title}", ""]
            for statement in statements(body):
                cursor = conn.execute(statement)
                if cursor.description:
                    lines.append("\t".join(column[0] for column in cursor.description))
                    rows = cursor.fetchall()
                    lines.extend(
                        "\t".join("" if value is None else str(value) for value in row)
                        for row in rows
                    )
                    if not rows:
                        lines.append("(결과 없음)")
            captured[f"query_{int(number):02d}.txt"] = "\n".join(lines).rstrip() + "\n"
        if conn.execute("PRAGMA foreign_key_check").fetchall():
            raise ValueError("외래키 무결성 검사에 실패했습니다.")
        conn.commit()
        output.parent.mkdir(parents=True, exist_ok=True)
        # 배타적 생성으로 기존 파일을 보호한다.
        with output.open("xb"):
            pass
        with sqlite3.connect(output) as destination:
            conn.backup(destination)
        results.mkdir(parents=True)
        for name, contents in captured.items():
            (results / name).write_text(contents, encoding="utf-8")
    print(f"SQLite DB 생성: {output}")
    print(f"쿼리 결과: {results} ({len(captured)}개)")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / ".runtime/workshop.db")
    parser.add_argument("--results", type=Path, default=ROOT / ".runtime/results")
    args = parser.parse_args()
    try:
        reproduce(args.output, args.results)
    except (OSError, ValueError, sqlite3.Error) as exc:
        parser.exit(1, f"재현 실패: {exc}\n")


if __name__ == "__main__":
    main()
