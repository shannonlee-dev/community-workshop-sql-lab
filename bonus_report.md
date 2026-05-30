# Bonus Report

## 1. JOIN과 서브쿼리 비교

같은 요구: 결제 완료된 active 신청 목록을 수강생 이름, 강의명, 결제 금액으로 확인한다.

- JOIN 방식: `queries.sql`의 Q13은 `enrollments`, `students`, `courses`, `payments`를 직접 조인한다. 연결 관계가 명확하고 여러 테이블 컬럼을 한 번에 가져오기 쉽다.
- 서브쿼리 방식: Q14는 강의명과 결제 금액을 서브쿼리로 가져온다. 작은 데이터에서는 읽을 수 있지만, 같은 행마다 하위 조회가 반복되어 JOIN보다 확장성이 낮을 수 있다.

이 과제의 최종 추천은 JOIN 방식이다. 요구가 여러 테이블의 컬럼을 함께 보여주는 목록 조회이기 때문이다.

## 2. FK 에러 시도와 수정 방법

의도적으로 존재하지 않는 `student_id = 999`를 참조하는 수강 신청을 넣으면 FK 제약조건 때문에 실패해야 한다.

실패 SQL:

```sql
PRAGMA foreign_keys = ON;
INSERT INTO enrollments (enrollment_id, student_id, course_id, enrolled_on, status, discount_percent)
VALUES (999, 999, 1, '2024-05-30', 'active', 0);
```

왜 막히는가: `enrollments.student_id`는 `students.student_id`를 참조하므로 부모 수강생이 먼저 존재해야 한다.

수정 방법: 먼저 `students`에 `student_id = 999`인 수강생을 추가하거나, 이미 존재하는 `student_id`를 사용한다.

관련 결과 텍스트는 `results/fk_error_attempt.txt`에 남겼다.

## 3. 핵심 지표 3개

### 지표 1: 강의별 결제 총액

```sql
SELECT c.title, COALESCE(SUM(p.amount), 0) AS total_paid
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
LEFT JOIN payments p ON p.enrollment_id = e.enrollment_id
GROUP BY c.course_id, c.title
ORDER BY total_paid DESC;
```

### 지표 2: 카테고리별 평균 수강료

```sql
SELECT category, AVG(fee) AS avg_fee
FROM courses
GROUP BY category
ORDER BY avg_fee DESC;
```

### 지표 3: 도시별 수강생 수

```sql
SELECT city, COUNT(*) AS student_count
FROM students
GROUP BY city
ORDER BY student_count DESC, city;
```
