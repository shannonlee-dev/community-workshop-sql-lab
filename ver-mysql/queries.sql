-- Cafe order management core queries

-- Q01 [basic] Seoul active customers, newest members first.
-- MySQL-specific syntax: LIMIT is used to cap the result set.
SELECT customer_id, full_name, email, joined_on
FROM customers
WHERE city = 'Seoul' AND status = 'active'
ORDER BY joined_on DESC
LIMIT 5;

-- Q02 [basic] Available coffee menu items sorted by price.
-- MySQL-specific syntax: LIMIT is used to cap the result set.
SELECT item_id, item_name, unit_price
FROM menu_items
WHERE category = 'coffee' AND is_available = TRUE
ORDER BY unit_price ASC
LIMIT 10;

-- Q03 [basic] Recent completed orders after a specific time.
-- MySQL-specific syntax: LIMIT is used to cap the result set.
SELECT order_id, customer_id, ordered_at, payment_method
FROM orders
WHERE order_status = 'completed' AND ordered_at >= '2025-03-03 00:00:00'
ORDER BY ordered_at DESC
LIMIT 5;

-- Q04 [basic] Dessert items above 3000 won.
-- MySQL-specific syntax: LIMIT is used to cap the result set.
SELECT item_id, item_name, category, unit_price
FROM menu_items
WHERE category = 'dessert' AND unit_price > 3000
ORDER BY unit_price DESC
LIMIT 5;

-- Q05 [join] INNER JOIN orders with customer names.
SELECT o.order_id, c.full_name, o.ordered_at, o.order_status
FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
ORDER BY o.ordered_at;

-- Q06 [join] INNER JOIN order lines with menu item names.
SELECT oi.order_item_id, o.order_id, mi.item_name, oi.quantity, oi.unit_price_snapshot
FROM order_items AS oi
INNER JOIN orders AS o ON o.order_id = oi.order_id
INNER JOIN menu_items AS mi ON mi.item_id = oi.item_id
ORDER BY oi.order_item_id;

-- Q07 [join] LEFT JOIN customers to reveal customers without orders.
SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS order_count
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY c.customer_id;

-- Q08 [join] Order total amounts by joining three tables.
SELECT o.order_id, c.full_name,
       SUM(oi.quantity * oi.unit_price_snapshot) AS order_total
FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi ON oi.order_id = o.order_id
GROUP BY o.order_id, c.full_name
ORDER BY order_total DESC;

-- Q09 [aggregate] Count orders by payment method.
SELECT payment_method, COUNT(*) AS order_count
FROM orders
GROUP BY payment_method
ORDER BY order_count DESC;

-- Q10 [aggregate] Total sales amount by menu category.
SELECT mi.category, SUM(oi.quantity * oi.unit_price_snapshot) AS category_sales
FROM order_items AS oi
INNER JOIN menu_items AS mi ON mi.item_id = oi.item_id
GROUP BY mi.category
ORDER BY category_sales DESC;

-- Q11 [aggregate] Average order line quantity by menu category.
SELECT mi.category, AVG(oi.quantity) AS average_quantity
FROM order_items AS oi
INNER JOIN menu_items AS mi ON mi.item_id = oi.item_id
GROUP BY mi.category
ORDER BY average_quantity DESC;

-- Q12 [subquery] Customers with an order total above the average order total.
SELECT t.order_id, t.full_name, t.order_total
FROM (
  SELECT o.order_id, c.full_name,
         SUM(oi.quantity * oi.unit_price_snapshot) AS order_total
  FROM orders AS o
  INNER JOIN customers AS c ON c.customer_id = o.customer_id
  INNER JOIN order_items AS oi ON oi.order_id = o.order_id
  GROUP BY o.order_id, c.full_name
) AS t
WHERE t.order_total > (
  SELECT AVG(order_total)
  FROM (
    SELECT SUM(quantity * unit_price_snapshot) AS order_total
    FROM order_items
    GROUP BY order_id
  ) AS order_totals
)
ORDER BY t.order_total DESC;

-- Q13 [index] Confirm the order-time index exists.
SHOW INDEX FROM orders WHERE Key_name = 'idx_orders_ordered_at';

-- Q14 [update] Temporarily mark one pending order as completed and inspect it.
START TRANSACTION;
UPDATE orders
SET order_status = 'completed'
WHERE order_id = 10;
SELECT order_id, order_status
FROM orders
WHERE order_id = 10;
ROLLBACK;

-- Q15 [delete] Temporarily delete one order line and inspect remaining lines.
START TRANSACTION;
DELETE FROM order_items
WHERE order_item_id = 12;
SELECT order_id, COUNT(*) AS remaining_lines
FROM order_items
WHERE order_id = 10
GROUP BY order_id;
ROLLBACK;

-- Q16 [bonus join] Customers who ordered Americano using JOIN.
SELECT DISTINCT c.customer_id, c.full_name
FROM customers AS c
INNER JOIN orders AS o ON o.customer_id = c.customer_id
INNER JOIN order_items AS oi ON oi.order_id = o.order_id
INNER JOIN menu_items AS mi ON mi.item_id = oi.item_id
WHERE mi.item_name = 'Americano'
ORDER BY c.customer_id;

-- Q17 [bonus subquery] Customers who ordered Americano using a subquery.
SELECT c.customer_id, c.full_name
FROM customers AS c
WHERE c.customer_id IN (
  SELECT o.customer_id
  FROM orders AS o
  INNER JOIN order_items AS oi ON oi.order_id = o.order_id
  INNER JOIN menu_items AS mi ON mi.item_id = oi.item_id
  WHERE mi.item_name = 'Americano'
)
ORDER BY c.customer_id;

-- Q18 [metric] Daily order count trend.
-- MySQL-specific syntax: DATE() extracts the date from DATETIME.
SELECT DATE(ordered_at) AS order_date, COUNT(*) AS order_count
FROM orders
GROUP BY DATE(ordered_at)
ORDER BY order_date;

-- Q19 [metric] Top menu items by sold quantity.
SELECT mi.item_name, SUM(oi.quantity) AS sold_quantity
FROM order_items AS oi
INNER JOIN menu_items AS mi ON mi.item_id = oi.item_id
GROUP BY mi.item_name
ORDER BY sold_quantity DESC, mi.item_name
LIMIT 5;

-- Q20 [metric] Customer purchase totals.
SELECT c.full_name, SUM(oi.quantity * oi.unit_price_snapshot) AS total_spent
FROM customers AS c
INNER JOIN orders AS o ON o.customer_id = c.customer_id
INNER JOIN order_items AS oi ON oi.order_id = o.order_id
GROUP BY c.full_name
ORDER BY total_spent DESC;
