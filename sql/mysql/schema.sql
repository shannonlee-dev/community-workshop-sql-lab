-- Cafe order management database schema
-- MySQL-specific syntax: AUTO_INCREMENT is used for surrogate primary keys.

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS customers;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(80) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  phone VARCHAR(30),
  joined_on DATE NOT NULL,
  city VARCHAR(60) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'active'
);

CREATE TABLE menu_items (
  item_id INT AUTO_INCREMENT PRIMARY KEY,
  item_name VARCHAR(100) NOT NULL UNIQUE,
  category VARCHAR(40) NOT NULL,
  unit_price DECIMAL(8,2) NOT NULL,
  is_available BOOLEAN NOT NULL DEFAULT TRUE,
  created_on DATE NOT NULL
);

CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  ordered_at DATETIME NOT NULL,
  order_status VARCHAR(20) NOT NULL,
  payment_method VARCHAR(30) NOT NULL,
  pickup_name VARCHAR(80) NOT NULL,
  CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  item_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_price_snapshot DECIMAL(8,2) NOT NULL,
  line_note VARCHAR(120),
  CONSTRAINT fk_order_items_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_order_items_menu_item
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);

-- Index reason: daily sales and recent-order queries filter and sort by order time.
CREATE INDEX idx_orders_ordered_at ON orders(ordered_at);
