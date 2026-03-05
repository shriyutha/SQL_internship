/*DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS payments; */

TRUNCATE TABLE
payments,
order_items,
orders,
addresses,
customers,
products,
categories
RESTART IDENTITY CASCADE;

 -- ENUM TYPES
CREATE TYPE order_status_enum AS ENUM ('Pending', 'Shipped', 'Delivered', 'Cancelled');
CREATE TYPE payment_status_enum AS ENUM ('Pending', 'Completed', 'Failed');


CREATE TABLE categories (
   category_id SERIAL PRIMARY KEY,
   category_name VARCHAR(100) UNIQUE NOT NULL,
   parent_category_id INT REFERENCES categories(category_id)
);

CREATE TABLE customers (
   customer_id SERIAL PRIMARY KEY,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   email VARCHAR(100) UNIQUE NOT NULL,
   phone VARCHAR(20),
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
   address_id SERIAL PRIMARY KEY,
   customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
   street VARCHAR(150) NOT NULL,
   city VARCHAR(50) NOT NULL,
   state VARCHAR(50),
   postal_code VARCHAR(20),
   country VARCHAR(50) NOT NULL
);

CREATE TABLE products (
   product_id SERIAL PRIMARY KEY,
   category_id INT NOT NULL REFERENCES categories(category_id) ON DELETE RESTRICT,
   product_name VARCHAR(100) NOT NULL,
   description TEXT,
   price NUMERIC(10,2) NOT NULL CHECK (price > 0),
   stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
   order_id SERIAL PRIMARY KEY,
   customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
   shipping_address_id INT NOT NULL REFERENCES addresses(address_id),
   order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   status order_status_enum DEFAULT 'Pending'
);

CREATE TABLE order_items (
   order_item_id SERIAL PRIMARY KEY,
   order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
   product_id INT NOT NULL REFERENCES products(product_id),
   quantity INT NOT NULL CHECK (quantity > 0),
   unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
   UNIQUE(order_id, product_id)
);


CREATE TABLE payments (
   payment_id SERIAL PRIMARY KEY,
   order_id INT UNIQUE NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
   payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   payment_method VARCHAR(50) NOT NULL,
   amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
   payment_status payment_status_enum DEFAULT 'Pending'
);

 -- Indexing Strategy:
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_payments_order ON payments(order_id); 

-- Sample Data Population --
--Categories
INSERT INTO categories (category_name)
VALUES ('Electronics'), 
	   ('Clothing')
ON CONFLICT (category_name) DO NOTHING;

-- Products
INSERT INTO products (category_id, product_name, description, price, stock_quantity)
VALUES
(1, 'Laptop', '14 inch business laptop', 800.00, 50),
(1, 'Headphones', 'Noise cancelling', 150.00, 100),
(2, 'T-Shirt', 'Cotton T-Shirt', 25.00, 200);

-- Customers
INSERT INTO customers (first_name, last_name, email, phone)
VALUES
('John', 'Doe', 'john@example.com', '1234567890'),
('Jane', 'Smith', 'jane@example.com', '0987654321');

-- Addresses
INSERT INTO addresses (customer_id, street, city, state, postal_code, country)
VALUES
(1, '123 Main St', 'San Jose', 'CA', '95112', 'USA'),
(2, '456 Market St', 'San Francisco', 'CA', '94105', 'USA');

-- Orders
INSERT INTO orders (customer_id, shipping_address_id, status)
VALUES
(1, 5, 'Delivered'),
(2, 6, 'Pending');

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 800.00),
(1, 2, 1, 150.00),
(2, 3, 1, 25.00);

-- Payments
INSERT INTO payments (order_id, payment_method, amount, payment_status)
VALUES
(1, 'Credit Card', 950.00, 'Completed'),
(2, 'PayPal', 25.00, 'Pending');


SELECT * FROM categories;

-- Analytical Queries & Reports --
-- Order Details Report
SELECT
o.order_id,
CONCAT(c.first_name,' ', c.last_name) AS customer_name,
o.order_date,
o.status,
SUM(oi.quantity * oi.unit_price) AS total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.first_name, c.last_name, o.order_date, o.status
ORDER BY o.order_date DESC;

-- Detailed Sales Report
SELECT
   o.order_id,
   p.product_name,
   oi.quantity,
   oi.unit_price,
   (oi.quantity * oi.unit_price) AS line_total
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id;

-- Total Sales by Product
SELECT
   p.product_name,
   SUM(oi.quantity) AS total_units_sold,
   SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;


-- Sales Summary View
CREATE VIEW sales_summary AS
SELECT
   o.order_id,
   c.first_name,
   c.last_name,
   SUM(oi.quantity * oi.unit_price) AS total_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.first_name, c.last_name;

-- Top 3 Revenue Generating Products (Using Window Function)
SELECT *
FROM (
    SELECT 
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue,
        RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS revenue_rank
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_name
) ranked_products
WHERE revenue_rank <= 3;
