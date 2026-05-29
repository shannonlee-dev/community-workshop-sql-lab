# Community Workshop Classes DB

## 선택한 DB와 실행 도구

- DB: SQLite, 로컬 파일 기반 관계형 DB
- 실행 도구: Python 3 표준 라이브러리 `sqlite3` 모듈을 사용하는 CLI 명령
- 이유: 별도 서버 없이 로컬 파일 `database.db`를 만들 수 있고, 과제의 PK/FK/JOIN/GROUP BY 실습을 충분히 검증할 수 있다.

SQLite는 연결마다 FK 검사를 켜야 하므로 `schema.sql`, `seed.sql`, `queries.sql`에 `PRAGMA foreign_keys = ON;`을 명시했다. 이 줄은 SQLite 전용 문법이다.

## 도메인

주제는 커뮤니티 센터의 원데이 클래스 운영이다. 강사, 수강생, 강의, 수강 신청, 결제, 출석을 분리해 저장한다.

주요 1:N 관계는 다음과 같다.

- 한 강사는 여러 강의를 맡는다: `courses.instructor_id -> instructors.instructor_id`
- 한 수강생은 여러 수강 신청을 할 수 있다: `enrollments.student_id -> students.student_id`
- 한 강의는 여러 수강 신청을 가진다: `enrollments.course_id -> courses.course_id`
- 한 수강 신청은 결제와 출석 기록으로 이어진다: `payments.enrollment_id`, `attendance.enrollment_id`

## 파일 구성

- `schema.sql`: 테이블 생성, PK/FK/NOT NULL/UNIQUE 제약조건
- `seed.sql`: 테이블별 최소 10행 이상 샘플 데이터
- `queries.sql`: 핵심 쿼리 17개와 각 쿼리 설명
- `results/`: 쿼리별 결과 텍스트와 FK 오류 시도 결과
- `bonus_report.md`: 보너스 3개 항목 정리

## 실행 순서

아래 명령은 현재 폴더에서 로컬 SQLite DB 파일을 재생성한다.

```sh
python3 - <<'PY'
import sqlite3
from pathlib import Path

db = Path("database.db")
if db.exists():
    db.unlink()
conn = sqlite3.connect(db)
conn.execute("PRAGMA foreign_keys = ON")
conn.executescript(Path("schema.sql").read_text())
conn.executescript(Path("seed.sql").read_text())
conn.commit()
conn.close()
print("created database.db")
PY
```

쿼리 결과는 `results/query_XX.txt` 파일로 확인한다. 수정/삭제 예시는 트랜잭션 안에서 실행한 뒤 롤백하므로 반복 실행해도 원본 데이터가 유지된다.

## 제약사항 준수

- Spring, Django, Express 같은 백엔드 프레임워크를 사용하지 않았다.
- 로컬 SQLite DB만 사용했다.
- 뷰, 프로시저, 트리거를 사용하지 않았다.
- SQLite 전용 문법은 `PRAGMA foreign_keys = ON`, `changes()`, `CREATE INDEX IF NOT EXISTS`이며 SQL 주석으로 표시했다.
