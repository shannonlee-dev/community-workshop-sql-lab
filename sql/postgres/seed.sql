-- Sample data for actuarial insurance portfolio analysis.
-- Parent tables are inserted before child tables so FK relationships are valid.

INSERT INTO insurance_products (product_code, product_name, line_of_business, base_annual_premium, launch_date) VALUES
('TERM-LIFE-01', 'Term Life Secure 10', 'life', 420000.00, '2019-01-01'),
('TERM-LIFE-02', 'Term Life Secure 20', 'life', 610000.00, '2020-03-15'),
('HEALTH-STD-01', 'Health Standard Care', 'health', 530000.00, '2018-06-01'),
('HEALTH-PREM-01', 'Health Premium Care', 'health', 820000.00, '2021-02-01'),
('AUTO-BASIC-01', 'Auto Basic Cover', 'auto', 390000.00, '2017-09-01'),
('AUTO-PLUS-01', 'Auto Plus Cover', 'auto', 590000.00, '2020-11-20'),
('TRAVEL-ANNUAL', 'Annual Travel Protect', 'travel', 180000.00, '2022-01-10'),
('HOME-FIRE-01', 'Home Fire Guard', 'property', 250000.00, '2019-08-12'),
('PENSION-RET-01', 'Retirement Pension Builder', 'pension', 1200000.00, '2016-04-01'),
('CANCER-CARE-01', 'Cancer Care Rider', 'health', 310000.00, '2023-05-01');

INSERT INTO customers (customer_code, full_name, birth_date, region, occupation, risk_score) VALUES
('CUS-0001', 'Kim Minjun', '1984-02-18', 'Seoul', 'software engineer', 34),
('CUS-0002', 'Lee Seoyeon', '1979-11-03', 'Busan', 'teacher', 28),
('CUS-0003', 'Park Jiho', '1992-07-21', 'Daegu', 'designer', 47),
('CUS-0004', 'Choi Hana', '1988-05-14', 'Incheon', 'nurse', 39),
('CUS-0005', 'Jung Hyunwoo', '1972-12-30', 'Gwangju', 'self-employed', 63),
('CUS-0006', 'Kang Yuna', '1995-09-09', 'Daejeon', 'research analyst', 25),
('CUS-0007', 'Yoon Jisoo', '1968-01-17', 'Ulsan', 'factory manager', 71),
('CUS-0008', 'Han Doyun', '1981-04-25', 'Jeju', 'pilot', 58),
('CUS-0009', 'Seo Ara', '1990-10-11', 'Seoul', 'actuarial student', 22),
('CUS-0010', 'Oh Taemin', '1976-06-06', 'Suwon', 'sales manager', 52);

INSERT INTO policies (policy_number, customer_id, product_id, policy_start_date, policy_end_date, insured_amount, annual_premium, status) VALUES
('POL-2024-0001', 1, 1, '2024-01-01', '2034-01-01', 100000000.00, 438000.00, 'active'),
('POL-2024-0002', 2, 3, '2024-01-15', '2025-01-15', 30000000.00, 545000.00, 'active'),
('POL-2024-0003', 3, 5, '2024-02-01', '2025-02-01', 20000000.00, 412000.00, 'active'),
('POL-2024-0004', 4, 4, '2024-02-10', '2025-02-10', 50000000.00, 845000.00, 'active'),
('POL-2024-0005', 5, 9, '2024-03-01', '2044-03-01', 150000000.00, 1260000.00, 'active'),
('POL-2024-0006', 6, 7, '2024-03-15', '2025-03-15', 10000000.00, 185000.00, 'active'),
('POL-2024-0007', 7, 6, '2024-04-01', '2025-04-01', 30000000.00, 655000.00, 'lapsed'),
('POL-2024-0008', 8, 8, '2024-04-20', '2025-04-20', 80000000.00, 275000.00, 'active'),
('POL-2024-0009', 9, 10, '2024-05-01', '2025-05-01', 40000000.00, 320000.00, 'active'),
('POL-2024-0010', 10, 2, '2024-05-15', '2044-05-15', 120000000.00, 640000.00, 'active');

INSERT INTO premium_payments (policy_id, payment_date, paid_amount, payment_method, payment_status) VALUES
(1, '2024-01-01', 438000.00, 'card', 'paid'),
(2, '2024-01-15', 545000.00, 'bank_transfer', 'paid'),
(3, '2024-02-01', 412000.00, 'card', 'paid'),
(4, '2024-02-10', 845000.00, 'bank_transfer', 'paid'),
(5, '2024-03-01', 1260000.00, 'card', 'paid'),
(6, '2024-03-15', 185000.00, 'card', 'paid'),
(7, '2024-04-01', 327500.00, 'bank_transfer', 'late'),
(8, '2024-04-20', 275000.00, 'card', 'paid'),
(9, '2024-05-01', 320000.00, 'card', 'paid'),
(10, '2024-05-15', 640000.00, 'bank_transfer', 'paid');

INSERT INTO claims (policy_id, claim_number, claim_date, claim_type, claim_amount, paid_amount, claim_status) VALUES
(1, 'CLM-2024-0001', '2024-03-01', 'death benefit inquiry', 5000000.00, 0.00, 'open'),
(2, 'CLM-2024-0002', '2024-04-12', 'outpatient treatment', 450000.00, 360000.00, 'paid'),
(3, 'CLM-2024-0003', '2024-05-03', 'vehicle collision', 2100000.00, 1800000.00, 'paid'),
(4, 'CLM-2024-0004', '2024-05-20', 'surgery benefit', 3500000.00, 3000000.00, 'approved'),
(5, 'CLM-2024-0005', '2024-06-08', 'retirement withdrawal review', 1200000.00, 0.00, 'rejected'),
(6, 'CLM-2024-0006', '2024-06-15', 'lost baggage', 700000.00, 650000.00, 'paid'),
(7, 'CLM-2024-0007', '2024-07-01', 'vehicle theft', 4800000.00, 0.00, 'open'),
(8, 'CLM-2024-0008', '2024-07-19', 'fire damage', 9500000.00, 7800000.00, 'paid'),
(9, 'CLM-2024-0009', '2024-08-02', 'cancer diagnosis', 6000000.00, 6000000.00, 'paid'),
(10, 'CLM-2024-0010', '2024-08-20', 'life benefit review', 2300000.00, 0.00, 'approved');
