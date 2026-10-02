# PostgreSQL 보험 포트폴리오 분석

## JOIN과 서브쿼리 비교

보험금 지급액이 300만원을 초과한 고객을 찾습니다. Q15는 `customers`, `policies`, `claims`를 JOIN하고 `paid_amount`를 필터링합니다. Q16은 조건에 맞는 계약·보험금이 있는 고객을 서브쿼리로 확인합니다. 여러 관계의 열을 표시할 때 JOIN이 명확하고, 해당 관계의 존재를 묻는 경우 서브쿼리가 요구사항을 직접 표현합니다.

## 외래키 실패

```sql
INSERT INTO policies (
    policy_number, customer_id, product_id, policy_start_date,
    policy_end_date, insured_amount, annual_premium, status
) VALUES ('POL-BAD-FK', 9999, 1, '2024-09-01', '2025-09-01',
          10000000.00, 250000.00, 'active');
```

부모 `customers`에 `customer_id = 9999`가 없으면 `policies_customer_id_fkey`가 고아 계약을 차단합니다. 고객을 먼저 등록하거나 존재하는 고객 ID를 사용합니다. 기존 [외래키 실패 증빙](../../evidence/postgres/fk_violation_demo.txt)을 참고합니다.

## 핵심 지표

1. Q20: 월별 지급 보험금 추이
2. Q21: 연간 보험료가 높은 상품
3. Q22: 보험료 대비 지급 보험금 비율이 높은 고객

Q12와 Q22는 보험금을 계약별로 먼저 합산한 뒤 계약에 LEFT JOIN한다. 따라서 한 계약에 청구가 여러 개여도 연간 보험료를 한 번만 더하고, 청구가 없는 계약의 보험료도 분모에 포함한다. 이 지표의 보험료는 실제 수입·경과 보험료가 아닌 `annual_premium` 합계이므로 회계적 손해율과 구분한다.

일대다 청구와 무청구 계약 fixture로 해당 SQL-92 집계를 메모리 SQLite에서 검증한다. PostgreSQL 전용 문법·서버 실행·전체 22개 쿼리 결과는 이 자동 검증에 포함하지 않는다.

[전체 쿼리 결과](../../evidence/postgres/all_query_results.txt)는 과거 실행 기록입니다. 새 결과는 실제 PostgreSQL 환경에서 재현해야 합니다.
