-- Cafe order management sample data

INSERT INTO customers (customer_id, full_name, email, phone, joined_on, city, status) VALUES
  (1, 'Kim Hana', 'hana.kim@example.com', '010-1000-0001', '2025-01-05', 'Seoul', 'active'),
  (2, 'Lee Minjun', 'minjun.lee@example.com', '010-1000-0002', '2025-01-08', 'Busan', 'active'),
  (3, 'Park Soyeon', 'soyeon.park@example.com', '010-1000-0003', '2025-01-12', 'Incheon', 'active'),
  (4, 'Choi Jisoo', 'jisoo.choi@example.com', '010-1000-0004', '2025-01-18', 'Daegu', 'active'),
  (5, 'Jung Doyun', 'doyun.jung@example.com', '010-1000-0005', '2025-01-22', 'Daejeon', 'active'),
  (6, 'Kang Yuna', 'yuna.kang@example.com', '010-1000-0006', '2025-02-01', 'Seoul', 'active'),
  (7, 'Yoon Seoha', 'seoha.yoon@example.com', '010-1000-0007', '2025-02-04', 'Gwangju', 'active'),
  (8, 'Han Jiho', 'jiho.han@example.com', '010-1000-0008', '2025-02-10', 'Suwon', 'active'),
  (9, 'Oh Nari', 'nari.oh@example.com', '010-1000-0009', '2025-02-14', 'Seoul', 'active'),
  (10, 'Shin Taewon', 'taewon.shin@example.com', '010-1000-0010', '2025-02-20', 'Busan', 'active');

INSERT INTO menu_items (item_id, item_name, category, unit_price, is_available, created_on) VALUES
  (1, 'Americano', 'coffee', 4500.00, TRUE, '2024-12-01'),
  (2, 'Cafe Latte', 'coffee', 5200.00, TRUE, '2024-12-01'),
  (3, 'Vanilla Latte', 'coffee', 5800.00, TRUE, '2024-12-03'),
  (4, 'Cold Brew', 'coffee', 5500.00, TRUE, '2024-12-04'),
  (5, 'Green Tea Latte', 'tea', 5600.00, TRUE, '2024-12-05'),
  (6, 'Lemon Ade', 'ade', 6000.00, TRUE, '2024-12-06'),
  (7, 'Strawberry Smoothie', 'smoothie', 6800.00, TRUE, '2024-12-07'),
  (8, 'Plain Bagel', 'bakery', 3900.00, TRUE, '2024-12-08'),
  (9, 'Cheese Cake', 'dessert', 7200.00, TRUE, '2024-12-09'),
  (10, 'Chocolate Cookie', 'dessert', 2800.00, TRUE, '2024-12-10');

INSERT INTO orders (order_id, customer_id, ordered_at, order_status, payment_method, pickup_name) VALUES
  (1, 1, '2025-03-01 09:12:00', 'completed', 'card', 'Hana'),
  (2, 2, '2025-03-01 10:35:00', 'completed', 'cash', 'Minjun'),
  (3, 3, '2025-03-02 08:50:00', 'completed', 'card', 'Soyeon'),
  (4, 4, '2025-03-02 13:05:00', 'completed', 'card', 'Jisoo'),
  (5, 5, '2025-03-03 11:20:00', 'completed', 'mobile', 'Doyun'),
  (6, 6, '2025-03-03 17:40:00', 'completed', 'card', 'Yuna'),
  (7, 7, '2025-03-04 09:45:00', 'completed', 'cash', 'Seoha'),
  (8, 8, '2025-03-04 15:10:00', 'completed', 'mobile', 'Jiho'),
  (9, 9, '2025-03-05 12:25:00', 'completed', 'card', 'Nari'),
  (10, 10, '2025-03-05 18:15:00', 'pending', 'card', 'Taewon');

INSERT INTO order_items (order_item_id, order_id, item_id, quantity, unit_price_snapshot, line_note) VALUES
  (1, 1, 1, 2, 4500.00, 'extra hot'),
  (2, 1, 8, 1, 3900.00, NULL),
  (3, 2, 2, 1, 5200.00, NULL),
  (4, 3, 3, 1, 5800.00, 'less sweet'),
  (5, 4, 9, 2, 7200.00, NULL),
  (6, 5, 4, 2, 5500.00, NULL),
  (7, 6, 5, 1, 5600.00, 'soy milk'),
  (8, 7, 6, 1, 6000.00, 'no ice'),
  (9, 8, 7, 1, 6800.00, NULL),
  (10, 9, 10, 3, 2800.00, NULL),
  (11, 10, 1, 1, 4500.00, NULL),
  (12, 10, 2, 1, 5200.00, NULL);
