# 98_PROCEDURE_MANUAL

## 1. 작업 폴더 만들기

1. 홈 폴더에 SQL 미션 작업 폴더를 만든다.

복붙 명령어:
~~~sh
mkdir -p ~/sql-mission/results
cd ~/sql-mission
~~~

예상 화면/출력:
~~~text
명령이 끝나고 ~/sql-mission 폴더로 이동한다.
~~~

## 2. 실행 환경 확인하기

1. Python 3와 내장 SQLite 버전을 확인한다.

복붙 명령어:
~~~sh
python3 - <<'PY'
import sqlite3
import sys
print("python", sys.version.split()[0])
print("sqlite", sqlite3.sqlite_version)
PY
~~~

예상 화면/출력:
~~~text
python과 sqlite 버전 번호가 표시된다.
~~~

2. Python 3가 없다면 설치한다.

복붙 명령어:
~~~sh
sudo apt update
sudo apt install -y python3
~~~

예상 화면/출력:
~~~text
설치 진행 메시지가 표시되고 마지막에 프롬프트가 돌아온다.
~~~

## 3. 제출 파일 준비하기

1. 아래 파일과 폴더를 준비한다.

복붙 명령어:
~~~sh
cd ~/sql-mission
touch schema.sql seed.sql queries.sql README.md bonus_report.md
mkdir -p results
~~~

예상 화면/출력:
~~~text
명령이 끝나고 SQL 파일과 results 폴더가 만들어진다.
~~~

2. `schema.sql`에는 테이블 생성, 기본키, 외래키, NOT NULL, UNIQUE를 작성한다.

복붙 명령어:
~~~sh
nano ~/sql-mission/schema.sql
~~~

예상 화면/출력:
~~~text
nano 편집기에서 schema.sql을 편집할 수 있다.
~~~

3. `seed.sql`에는 부모 테이블 데이터를 먼저 넣고 각 테이블 10행 이상 INSERT를 작성한다.

복붙 명령어:
~~~sh
nano ~/sql-mission/seed.sql
~~~

예상 화면/출력:
~~~text
nano 편집기에서 seed.sql을 편집할 수 있다.
~~~

4. `queries.sql`에는 설명 주석이 붙은 핵심 쿼리 15개 이상을 작성한다.

복붙 명령어:
~~~sh
nano ~/sql-mission/queries.sql
~~~

예상 화면/출력:
~~~text
nano 편집기에서 queries.sql을 편집할 수 있다.
~~~

## 4. 로컬 DB 생성과 데이터 입력

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

## 5. 결과 텍스트 남기기

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

2. 쿼리별 결과는 `queries.sql`의 각 쿼리를 실행해 `results/query_01.txt`처럼 하나씩 저장한다.

복붙 명령어:
~~~sh
cd ~/sql-mission
printf '%s\n' 'queries.sql의 Q01부터 Q15 이상까지 실행 결과를 results/ 폴더에 텍스트로 저장한다.'
~~~

예상 화면/출력:
~~~text
안내 문장이 표시된다.
~~~

## 6. FK 오류 시도 기록하기

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

## 7. 최종 산출물 확인하기

1. 제출 파일과 결과 폴더를 확인한다.

복붙 명령어:
~~~sh
cd ~/sql-mission
ls -la
ls -la results
~~~

예상 화면/출력:
~~~text
schema.sql, seed.sql, queries.sql, README.md, bonus_report.md, results 폴더가 보인다.
results 폴더 안에 결과 텍스트 파일이 보인다.
~~~

2. 핵심 SQL 키워드를 빠르게 확인한다.

복붙 명령어:
~~~sh
cd ~/sql-mission
grep -Ei 'CREATE TABLE|PRIMARY KEY|FOREIGN KEY|NOT NULL|UNIQUE' schema.sql
grep -Ei 'WHERE|ORDER BY|LIMIT|JOIN|GROUP BY|UPDATE|DELETE|CREATE INDEX' queries.sql
~~~

예상 화면/출력:
~~~text
스키마와 쿼리 파일에서 주요 SQL 키워드가 표시된다.
~~~
