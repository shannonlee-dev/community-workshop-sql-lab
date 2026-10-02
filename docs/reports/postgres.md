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

[전체 쿼리 결과](../../evidence/postgres/all_query_results.txt)는 과거 실행 기록입니다. 새 결과는 실제 PostgreSQL 환경에서 재현해야 합니다.
