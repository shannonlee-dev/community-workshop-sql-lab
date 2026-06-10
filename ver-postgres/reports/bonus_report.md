# Bonus Report

Traceability: BONUS-001, BONUS-002, BONUS-003. Validation evidence is linked from runtime/done_logs/BONUS-001.log, runtime/done_logs/BONUS-002.log, and runtime/done_logs/BONUS-003.log.

## JOIN vs Subquery

Requirement: find customers with paid claim amounts above 3,000,000 KRW.

- JOIN version: `Q15` joins `customers`, `policies`, and `claims`, then filters directly on `claims.paid_amount`.
- Subquery version: `Q16` starts from `customers` and checks whether the customer owns a policy whose claim is above the threshold.
- Comparison: the JOIN version is usually easier to read when the output needs columns from several related tables. The subquery version is useful when the question is phrased as membership, such as "customers who have at least one matching policy or claim."

## FK Error Trial

Intentional failing input:

```sql
INSERT INTO policies (
    policy_number,
    customer_id,
    product_id,
    policy_start_date,
    policy_end_date,
    insured_amount,
    annual_premium,
    status
) VALUES (
    'POL-BAD-FK',
    9999,
    1,
    '2024-09-01',
    '2025-09-01',
    10000000.00,
    250000.00,
    'active'
);
```

Why it is blocked: `customer_id = 9999` does not exist in the parent `customers` table, so the `policies_customer_id_fkey` foreign key prevents orphan policy data.

How to fix it: insert the parent customer first, or use an existing `customer_id`.

## Three Core Metrics

1. Monthly paid claim trend: `Q20`
2. Top products by annual premium: `Q21`
3. Highest paid-claim-to-premium customer ratios: `Q22`
