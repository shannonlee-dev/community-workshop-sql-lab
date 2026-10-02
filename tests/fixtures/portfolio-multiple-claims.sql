-- One policy has two claims; another has none. Premiums must not be duplicated
-- or dropped when computing line/customer paid-claim-to-premium ratios.
CREATE TABLE insurance_products (product_id INTEGER PRIMARY KEY, line_of_business TEXT);
CREATE TABLE customers (customer_id INTEGER PRIMARY KEY, customer_code TEXT, full_name TEXT);
CREATE TABLE policies (policy_id INTEGER PRIMARY KEY, customer_id INTEGER, product_id INTEGER, annual_premium REAL);
CREATE TABLE claims (claim_id INTEGER PRIMARY KEY, policy_id INTEGER, paid_amount REAL);
INSERT INTO insurance_products VALUES (1, 'health');
INSERT INTO customers VALUES (1, 'CUS-A', 'Kim'), (2, 'CUS-B', 'Lee');
INSERT INTO policies VALUES (1, 1, 1, 100), (2, 1, 1, 200), (3, 2, 1, 100);
INSERT INTO claims VALUES (1, 1, 60), (2, 1, 40), (3, 3, 50);
