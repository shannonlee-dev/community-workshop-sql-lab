# SQL 실습 재현 안내

## SQLite

Python 3.10 이상의 표준 라이브러리로 실행합니다. 모든 명령은 저장소 루트에서 실행합니다.

```bash
uv run --frozen python scripts/reproduce.py --output .runtime/workshop.db --results .runtime/results
make smoke
```

재현기는 새 DB와 새 결과 디렉토리만 허용합니다. 스키마·샘플·17개 쿼리를 실행하며 변경 예제의 롤백을 확인합니다. 테이블 수·행 수·외래키 위반은 실행 검증에서 확인합니다. 테이블별 기준 행 수는 `tests/fixtures/sqlite-table-counts.csv`에 있으며 쿼리 출력은 새 결과 디렉토리에 생성합니다.

## MySQL

서버와 `mysql` CLI, 전용 실습 DB를 준비합니다. 다음 예시의 `workshop_mysql`은 자신의 비어 있는 실습 DB 이름으로 지정합니다. 인증은 자신의 클라이언트 설정 또는 프롬프트를 사용합니다.

```bash
mysql -u lab_user -p workshop_mysql < sql/mysql/schema.sql
mysql -u lab_user -p workshop_mysql < sql/mysql/seed.sql
mysql -u lab_user -p workshop_mysql < sql/mysql/queries.sql
```

카페 주문 도메인이며 SQLite 도메인과 다릅니다. 스키마 파일의 DROP 문은 같은 이름의 기존 테이블을 삭제합니다. 운영 DB에 적용하지 않습니다.

## PostgreSQL

서버와 `psql` CLI, 전용 실습 DB를 준비합니다. `workshop_postgres`를 자신의 실습 DB 이름으로 지정합니다.

```bash
psql -X -v ON_ERROR_STOP=1 -U lab_user -d workshop_postgres -f sql/postgres/schema.sql
psql -X -v ON_ERROR_STOP=1 -U lab_user -d workshop_postgres -f sql/postgres/seed.sql
psql -X -v ON_ERROR_STOP=1 -U lab_user -d workshop_postgres -f sql/postgres/queries.sql
```

보험 포트폴리오 도메인입니다. 스키마 파일에는 기존 테이블 삭제문이 있습니다. 인증·서버 버전·실행 일시를 결과와 함께 기록합니다.

## 증빙 관리

`evidence/`의 결과는 과거 기록입니다. 현재 자동 검증은 SQLite 재현과 메모리 SQLite에서 실행 가능한 PostgreSQL Q12·Q22 공통 집계 부분에 한정하며 MySQL·PostgreSQL 서버 실행을 포함하지 않습니다. 새 결과는 `.runtime/`에 수집합니다. SQLite의 기준 행 수·집계·결제 신청 결과는 `tests/fixtures/`와 비교하고, 다른 엔진의 통합 결과는 `evidence/`를 참고합니다. 엔진별 해석은 `docs/reports/`에 있습니다.
