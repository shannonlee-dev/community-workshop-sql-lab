# Community Workshop SQL Lab

A SQLite relational data-modeling project for a community workshop program. The schema separates instructors, students, courses, enrollments, payments, and attendance so constraints and joins can be tested against realistic relationships.

The focus is on data integrity and explainable queries: primary keys, foreign keys, `LEFT JOIN` behavior, grouped metrics, transaction rollback examples, and reproducible query outputs are all kept in the repository.

## Stack

- SQLite
- Python standard-library `sqlite3`
- SQL schema, seed, and query files

## Domain Model

- One instructor can teach many courses.
- One student can have many enrollments.
- One course can have many enrollments.
- Each enrollment can connect to payment and attendance records.

Key relationships:

```text
courses.instructor_id -> instructors.instructor_id
enrollments.student_id -> students.student_id
enrollments.course_id -> courses.course_id
payments.enrollment_id -> enrollments.enrollment_id
attendance.enrollment_id -> enrollments.enrollment_id
```

## Files

| File | Purpose |
| --- | --- |
| `schema.sql` | Table definitions and constraints |
| `seed.sql` | Sample data |
| `queries.sql` | 17 documented queries |
| `results/` | Captured query outputs |
| `bonus_report.md` | JOIN/subquery comparison, FK failure case, metrics |
| `database.db` | Local SQLite database file |

## Rebuild Database

```bash
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

## Query Outputs

Query results are stored in `results/query_XX.txt`. Update/delete examples are executed inside transactions and rolled back, so the sample data can be reused safely.

## Design Notes

- Foreign-key checks are explicitly enabled with `PRAGMA foreign_keys = ON`.
- Sample data includes courses with zero enrollments to verify `LEFT JOIN` behavior.
- Metrics cover total payment by course, average fee by category, and student counts by city.
- The FK failure example is preserved to show how invalid references are rejected.
