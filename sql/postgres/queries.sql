-- Core SQL queries for the actuarial insurance portfolio database.
-- PostgreSQL-specific syntax is noted where used.

-- Q01 [basic] Find active policies with high annual premiums.
SELECT policy_number, annual_premium, status
FROM policies
WHERE status = 'active' AND annual_premium >= 600000
ORDER BY annual_premium DESC
LIMIT 5;

-- Q02 [basic] List high-risk customers by score.
SELECT customer_code, full_name, region, occupation, risk_score
FROM customers
WHERE risk_score >= 50
ORDER BY risk_score DESC, full_name
LIMIT 10;

-- Q03 [basic] Find claims paid after June 2024.
SELECT claim_number, claim_date, claim_type, paid_amount, claim_status
FROM claims
WHERE claim_date >= DATE '2024-06-01' AND paid_amount > 0
ORDER BY claim_date, paid_amount DESC
LIMIT 10;

-- Q04 [basic] Review products with base annual premium below 400,000 KRW.
SELECT product_code, product_name, line_of_business, base_annual_premium
FROM insurance_products
WHERE base_annual_premium < 400000
ORDER BY base_annual_premium ASC
LIMIT 10;

-- Q05 [join: inner] Join policies to customers and products for underwriting review.
SELECT p.policy_number, c.full_name, pr.product_name, p.insured_amount, p.annual_premium
FROM policies p
INNER JOIN customers c ON c.customer_id = p.customer_id
INNER JOIN insurance_products pr ON pr.product_id = p.product_id
ORDER BY p.policy_number;

-- Q06 [join: inner] Show paid claims with customer and product context.
SELECT cl.claim_number, c.full_name, pr.line_of_business, cl.claim_type, cl.paid_amount
FROM claims cl
INNER JOIN policies p ON p.policy_id = cl.policy_id
INNER JOIN customers c ON c.customer_id = p.customer_id
INNER JOIN insurance_products pr ON pr.product_id = p.product_id
WHERE cl.claim_status = 'paid'
ORDER BY cl.paid_amount DESC;

-- Q07 [join: left] Show every customer and any policy they hold.
SELECT c.customer_code, c.full_name, p.policy_number, p.status
FROM customers c
LEFT JOIN policies p ON p.customer_id = c.customer_id
ORDER BY c.customer_code, p.policy_number;

-- Q08 [join: inner] Connect premium payment status to policy and customer.
SELECT p.policy_number, c.full_name, pp.payment_date, pp.paid_amount, pp.payment_status
FROM premium_payments pp
INNER JOIN policies p ON p.policy_id = pp.policy_id
INNER JOIN customers c ON c.customer_id = p.customer_id
ORDER BY pp.payment_date;

-- Q09 [join: inner] Rank claim amounts by insurance line.
SELECT pr.line_of_business, cl.claim_number, cl.claim_amount, cl.paid_amount
FROM claims cl
INNER JOIN policies p ON p.policy_id = cl.policy_id
INNER JOIN insurance_products pr ON pr.product_id = p.product_id
ORDER BY pr.line_of_business, cl.claim_amount DESC;

-- Q10 [aggregate] Count policies and sum annual premium by line of business.
SELECT pr.line_of_business,
       COUNT(*) AS policy_count,
       SUM(p.annual_premium) AS total_annual_premium
FROM policies p
INNER JOIN insurance_products pr ON pr.product_id = p.product_id
GROUP BY pr.line_of_business
ORDER BY total_annual_premium DESC;

-- Q11 [aggregate] Calculate average customer risk score by region.
SELECT region,
       COUNT(*) AS customer_count,
       AVG(risk_score) AS average_risk_score
FROM customers
GROUP BY region
ORDER BY average_risk_score DESC;

-- Q12 [aggregate] Calculate loss ratio by insurance line.
SELECT pr.line_of_business,
       SUM(cl.paid_amount) AS total_paid_claims,
       SUM(p.annual_premium) AS total_annual_premium,
       ROUND(SUM(cl.paid_amount) / NULLIF(SUM(p.annual_premium), 0), 4) AS loss_ratio
FROM claims cl
INNER JOIN policies p ON p.policy_id = cl.policy_id
INNER JOIN insurance_products pr ON pr.product_id = p.product_id
GROUP BY pr.line_of_business
ORDER BY loss_ratio DESC;

-- Q13 [aggregate] Count payment statuses and total paid premium.
SELECT payment_status,
       COUNT(*) AS payment_count,
       SUM(paid_amount) AS total_paid_amount
FROM premium_payments
GROUP BY payment_status
ORDER BY payment_count DESC, total_paid_amount DESC;

-- Q14 [subquery] Find policies whose annual premium is above the portfolio average.
SELECT policy_number, annual_premium
FROM policies
WHERE annual_premium > (SELECT AVG(annual_premium) FROM policies)
ORDER BY annual_premium DESC;

-- Q15 [bonus: join-vs-subquery, join version] Find customers with paid claim amounts above 3,000,000 KRW.
SELECT DISTINCT c.customer_code, c.full_name, cl.paid_amount
FROM customers c
INNER JOIN policies p ON p.customer_id = c.customer_id
INNER JOIN claims cl ON cl.policy_id = p.policy_id
WHERE cl.paid_amount > 3000000
ORDER BY cl.paid_amount DESC;

-- Q16 [bonus: join-vs-subquery, subquery version] Same requirement as Q15 using a subquery.
SELECT c.customer_code, c.full_name
FROM customers c
WHERE c.customer_id IN (
    SELECT p.customer_id
    FROM policies p
    WHERE p.policy_id IN (
        SELECT cl.policy_id
        FROM claims cl
        WHERE cl.paid_amount > 3000000
    )
)
ORDER BY c.customer_code;

-- Q17 [update] Test a status update without permanently changing sample data.
BEGIN;
UPDATE policies
SET status = 'lapsed'
WHERE policy_number = 'POL-2024-0003'
RETURNING policy_number, status;
ROLLBACK;

-- Q18 [delete] Test claim deletion without permanently changing sample data.
BEGIN;
DELETE FROM claims
WHERE claim_number = 'CLM-2024-0001'
RETURNING claim_number, claim_status;
ROLLBACK;

-- Q19 [index] PostgreSQL B-tree index for frequent actuarial loss-ratio grouping by claim date.
-- PostgreSQL-specific syntax: CREATE INDEX IF NOT EXISTS avoids an error when rerunning the script.
CREATE INDEX IF NOT EXISTS idx_claims_claim_date ON claims (claim_date);

-- Q20 [metric] Monthly paid claim trend for actuarial monitoring.
-- PostgreSQL-specific syntax: DATE_TRUNC groups dates by month.
SELECT DATE_TRUNC('month', claim_date)::date AS claim_month,
       SUM(paid_amount) AS total_paid_claims
FROM claims
GROUP BY DATE_TRUNC('month', claim_date)::date
ORDER BY claim_month;

-- Q21 [metric] Top products by earned premium proxy.
SELECT pr.product_code, pr.product_name, SUM(p.annual_premium) AS total_annual_premium
FROM policies p
INNER JOIN insurance_products pr ON pr.product_id = p.product_id
GROUP BY pr.product_code, pr.product_name
ORDER BY total_annual_premium DESC
LIMIT 5;

-- Q22 [metric] Customers with the highest paid-claim-to-premium ratio.
SELECT c.customer_code,
       c.full_name,
       SUM(cl.paid_amount) AS total_paid_claims,
       SUM(p.annual_premium) AS total_annual_premium,
       ROUND(SUM(cl.paid_amount) / NULLIF(SUM(p.annual_premium), 0), 4) AS paid_claim_to_premium_ratio
FROM customers c
INNER JOIN policies p ON p.customer_id = c.customer_id
INNER JOIN claims cl ON cl.policy_id = p.policy_id
GROUP BY c.customer_code, c.full_name
ORDER BY paid_claim_to_premium_ratio DESC
LIMIT 5;
