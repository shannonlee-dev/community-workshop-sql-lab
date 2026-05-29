-- Community Workshop Classes core queries.
-- Target DB: SQLite. The UPDATE/DELETE examples run inside transactions and roll back
-- so the demo database remains reusable after the file is executed.
PRAGMA foreign_keys = ON;

-- Q01: 서울에 사는 수강생을 가입일 최신순으로 5명까지 확인한다.
SELECT student_id, full_name, city, joined_on
FROM students
WHERE city = 'Seoul'
ORDER BY joined_on DESC
LIMIT 5;

-- Q02: 100000원 이상인 강의를 수강료 높은 순으로 확인한다.
SELECT course_id, title, category, fee
FROM courses
WHERE fee >= 100000
ORDER BY fee DESC
LIMIT 6;

-- Q03: active 상태의 수강 신청을 최근 신청순으로 확인한다.
SELECT enrollment_id, student_id, course_id, enrolled_on, status
FROM enrollments
WHERE status = 'active'
ORDER BY enrolled_on DESC
LIMIT 8;

-- Q04: 카드 결제 내역을 금액 높은 순으로 확인한다.
SELECT payment_id, enrollment_id, amount, method
FROM payments
WHERE method = 'card'
ORDER BY amount DESC
LIMIT 5;

-- Q05: 수강생과 강의명을 INNER JOIN으로 연결해 신청 목록을 확인한다.
SELECT e.enrollment_id, s.full_name AS student_name, c.title AS course_title, e.status
FROM enrollments e
INNER JOIN students s ON s.student_id = e.student_id
INNER JOIN courses c ON c.course_id = e.course_id
ORDER BY e.enrollment_id;

-- Q06: 강사와 강의를 INNER JOIN으로 연결해 담당 강의를 확인한다.
SELECT i.full_name AS instructor_name, c.title, c.category, c.starts_on
FROM courses c
INNER JOIN instructors i ON i.instructor_id = c.instructor_id
ORDER BY c.starts_on;

-- Q07: 신청과 결제를 INNER JOIN으로 연결해 실제 납부 금액을 확인한다.
SELECT e.enrollment_id, s.full_name, c.title, p.amount, p.method
FROM payments p
INNER JOIN enrollments e ON e.enrollment_id = p.enrollment_id
INNER JOIN students s ON s.student_id = e.student_id
INNER JOIN courses c ON c.course_id = e.course_id
ORDER BY p.amount DESC;

-- Q08: 모든 강의와 신청 수를 LEFT JOIN으로 확인해 신청이 없는 강의도 찾는다.
SELECT c.course_id, c.title, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_id, c.title
ORDER BY enrollment_count ASC, c.course_id;

-- Q09: 카테고리별 강의 수와 평균 수강료를 집계한다.
SELECT category, COUNT(*) AS course_count, AVG(fee) AS avg_fee
FROM courses
GROUP BY category
ORDER BY avg_fee DESC;

-- Q10: 강의별 결제 총액과 결제 건수를 집계한다.
SELECT c.title, COUNT(p.payment_id) AS paid_count, SUM(p.amount) AS total_paid
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
LEFT JOIN payments p ON p.enrollment_id = e.enrollment_id
GROUP BY c.course_id, c.title
ORDER BY total_paid DESC;

-- Q11: 도시별 수강생 수를 집계한다.
SELECT city, COUNT(*) AS student_count
FROM students
GROUP BY city
ORDER BY student_count DESC, city;

-- Q12: 평균 강의 수강료보다 비싼 강의를 서브쿼리로 확인한다.
SELECT title, category, fee
FROM courses
WHERE fee > (SELECT AVG(fee) FROM courses)
ORDER BY fee DESC;

-- Q13: 같은 요구를 JOIN으로 풀어 결제 완료된 active 신청 목록을 확인한다.
SELECT s.full_name, c.title, p.amount
FROM enrollments e
INNER JOIN students s ON s.student_id = e.student_id
INNER JOIN courses c ON c.course_id = e.course_id
INNER JOIN payments p ON p.enrollment_id = e.enrollment_id
WHERE e.status = 'active'
ORDER BY p.amount DESC;

-- Q14: Q13과 같은 요구를 서브쿼리 방식으로 풀어 결제 완료된 active 신청 목록을 확인한다.
SELECT s.full_name,
       (SELECT c.title FROM courses c WHERE c.course_id = e.course_id) AS course_title,
       (SELECT p.amount FROM payments p WHERE p.enrollment_id = e.enrollment_id) AS paid_amount
FROM enrollments e
INNER JOIN students s ON s.student_id = e.student_id
WHERE e.status = 'active'
  AND e.enrollment_id IN (SELECT p.enrollment_id FROM payments p)
ORDER BY paid_amount DESC;

-- Q15: UPDATE로 waitlisted 신청을 active로 바꿀 때의 영향을 확인하고 롤백한다.
BEGIN TRANSACTION;
UPDATE enrollments
SET status = 'active'
WHERE status = 'waitlisted';
SELECT changes() AS updated_rows_after_waitlist_update;
ROLLBACK;

-- Q16: DELETE로 결제 없는 취소 신청을 삭제할 때의 영향을 확인하고 롤백한다.
BEGIN TRANSACTION;
DELETE FROM enrollments
WHERE status = 'cancelled'
  AND enrollment_id NOT IN (SELECT enrollment_id FROM payments);
SELECT changes() AS deleted_rows_after_cancel_cleanup;
ROLLBACK;

-- Q17: 강의명 검색을 빠르게 하기 위해 title 컬럼에 인덱스를 만든다.
-- 적용 이유: 사용자가 강의명을 검색하거나 정렬할 때 courses.title 조건 조회가 자주 발생한다.
CREATE INDEX IF NOT EXISTS idx_courses_title ON courses(title);
