DROP TABLE IF EXISTS sales_large;

CREATE TABLE sales_large (
    order_id BIGSERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    region VARCHAR(50),
    order_date DATE,
    sales_amount NUMERIC(10,2)
);


INSERT INTO sales_large (customer_id, product_id, region, order_date, sales_amount)
SELECT
    (random() * 100000)::INT,
    (random() * 5000)::INT,
    (ARRAY['East','West','North','South'])[floor(random()*4)+1],
    DATE '2018-01-01' + (random() * 2000)::INT,
    round((random() * 1000)::numeric, 2)
FROM generate_series(1, 1000000);


SELECT COUNT(*)
FROM sales_large;


-- Slow Running Queries:
-- Query 1: Filter by region
EXPLAIN ANALYZE
SELECT *
FROM sales_large
WHERE region = 'West';

-- Query 2: Date range:
EXPLAIN ANALYZE
SELECT *
FROM sales_large
WHERE order_date BETWEEN '2022-01-01' AND '2022-12-31';

-- Query 3: Aggregation:
EXPLAIN ANALYZE
SELECT customer_id, SUM(sales_amount)
FROM sales_large
GROUP BY customer_id;SELECT customer_id, SUM(sales_amount)
FROM sales_large
GROUP BY customer_id;


-- Creating Indexes:
-- Index on region:
CREATE INDEX idx_sales_region
ON sales_large(region);

-- Index on order_date:
CREATE INDEX idx_sales_order_date
ON sales_large(order_date);

-- Index on customer_id:
CREATE INDEX idx_sales_customer
ON sales_large(customer_id);


-- Reruning the Queries & Comparing the Performance:
-- After Indexing
-- Query 1: Filter by region
EXPLAIN ANALYZE
SELECT *
FROM sales_large
WHERE region = 'West';

-- Query 2: Date range:
EXPLAIN ANALYZE
SELECT *
FROM sales_large
WHERE order_date BETWEEN '2022-01-01' AND '2022-12-31';

-- Query 3: Aggregation:
EXPLAIN ANALYZE
SELECT customer_id, SUM(sales_amount)
FROM sales_large
GROUP BY customer_id;


-- Clustered vs Non Clustered Index:
-- Non Clustered Index: Index is separate from table data and PostgreSQL indexes are non-clustered by default.
CREATE INDEX idx_sales_region
ON sales_large(region);

-- Clustered Index: PostgreSQL allows CLUSTER, but only one at a time.
CLUSTER sales_large USING idx_sales_order_date;
/* After clustering:
Table data physically reordered
Faster range queries on order_date
Needs to be re-run periodically (not automatic) */


-- Cases Where Indexes HURT Performance:
CREATE INDEX idx_sales_region_bad
ON sales_large(region);
/* Too many indexes:
Slower INSERT, UPDATE, DELETE
Higher disk usage */


-- Best Indexing Practices:
/* Index columns used in:
WHERE
JOIN
ORDER BY
GROUP BY

Avoid indexing:
Small tables
Columns with very few unique values
Columns rarely used in filters */