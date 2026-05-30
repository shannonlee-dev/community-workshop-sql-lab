## 1. 로컬 DB 생성과 데이터 입력

1. 스키마와 샘플 데이터를 새 SQLite 파일에 실행한다.

복붙 명령어:
~~~sh
cd ~/sql-mission
python3 - <<'PY'
import sqlite3
from pathlib import Path

db = Path("mission.db")
if db.exists():
    db.unlink()
conn = sqlite3.connect(db)
conn.execute("PRAGMA foreign_keys = ON")
conn.executescript(Path("schema.sql").read_text())
conn.executescript(Path("seed.sql").read_text())
conn.commit()
conn.close()
print("created mission.db")
PY
~~~

예상 화면/출력:
~~~text
created mission.db
~~~

## 2. 결과 텍스트 남기기

1. 테이블별 행 수를 결과 파일로 저장한다.

복붙 명령어:
~~~sh
cd ~/sql-mission
python3 - <<'PY'
import sqlite3
from pathlib import Path

conn = sqlite3.connect("mission.db")
tables = ["instructors", "students", "courses", "enrollments", "payments", "attendance"]
lines = ["table_name,row_count"]
for table in tables:
    count = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
    lines.append(f"{table},{count}")
Path("results/table_counts.txt").write_text("\n".join(lines) + "\n")
conn.close()
print("wrote results/table_counts.txt")
PY
~~~

예상 화면/출력:
~~~text
wrote results/table_counts.txt
~~~

2. 쿼리별 결과는 `queries.sql`의 각 쿼리를 실행해 저장한다.

복붙 명령어:
~~~sh
cd ~/sql-mission
python3 - <<'PY'
import re
import sqlite3
from pathlib import Path

conn = sqlite3.connect("mission.db")
conn.execute("PRAGMA foreign_keys = ON")
results_dir = Path("results")
results_dir.mkdir(exist_ok=True)

sql_text = Path("queries.sql").read_text()
blocks = re.findall(r"-- Q(\d+): ([^\n]+)\n(.*?)(?=\n-- Q\d+:|\Z)", sql_text, re.S)

for number, title, body in blocks:
    output = [f"Q{number}: {title}", ""]
    statements = [stmt.strip() for stmt in body.split(";") if stmt.strip()]
    wrote_result = False

    for statement in statements:
        if statement.startswith("--"):
            comment_lines = []
            sql_lines = []
            for line in statement.splitlines():
                if line.strip().startswith("--"):
                    comment_lines.append(line.strip()[3:])
                else:
                    sql_lines.append(line)
            if comment_lines:
                output.extend(comment_lines)
            statement = "\n".join(sql_lines).strip()
            if not statement:
                continue

        cursor = conn.execute(statement)
        if cursor.description:
            headers = [col[0] for col in cursor.description]
            rows = cursor.fetchall()
            output.append("\t".join(headers))
            output.extend("\t".join("" if value is None else str(value) for value in row) for row in rows)
            if not rows:
                output.append("(no rows)")
            wrote_result = True

    if not wrote_result:
        output.append("statement executed")

    Path(f"results/query_{int(number):02d}.txt").write_text("\n".join(output).rstrip() + "\n")

conn.close()
print(f"wrote {len(blocks)} query result files")
PY
~~~

예상 화면/출력:
~~~text
wrote 17 query result files
~~~

## 3. FK 오류 시도 기록하기

1. 없는 부모 키를 참조하는 INSERT가 막히는지 확인한다.

복붙 명령어:
~~~sh
cd ~/sql-mission
python3 - <<'PY'
import sqlite3
from pathlib import Path

conn = sqlite3.connect("mission.db")
conn.execute("PRAGMA foreign_keys = ON")
try:
    conn.execute(
        "INSERT INTO enrollments (enrollment_id, student_id, course_id, enrolled_on, status, discount_percent) "
        "VALUES (?, ?, ?, ?, ?, ?)",
        (999, 999, 1, "2024-05-30", "active", 0),
    )
    conn.commit()
    text = "Unexpected success: FK was not enforced\n"
except sqlite3.IntegrityError as exc:
    conn.rollback()
    text = f"Expected FK failure\nerror: {exc}\n"
Path("results/fk_error_attempt.txt").write_text(text)
conn.close()
print("wrote results/fk_error_attempt.txt")
PY
~~~

예상 화면/출력:
~~~text
wrote results/fk_error_attempt.txt
~~~
