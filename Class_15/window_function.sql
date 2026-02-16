DROP TABLE IF EXISTS employees; 

-- Step 1 — Extending a Employee Table:
CREATE TABLE employees(
emp_id SERIAL PRIMARY KEY,
emp_name VARCHAR(100) UNIQUE,
department VARCHAR(50) NOT NULL,
salary NUMERIC(10,2) CHECK (salary > 0),
joining_date DATE DEFAULT CURRENT_DATE);


-- Inserting Sample Data:
INSERT INTO employees (emp_name, department, salary, joining_date) 
VALUES
('Alice', 'HR', 60000, '2021-01-10'),
('Bob', 'HR', 75000, '2020-03-15'),
('Charlie', 'HR', 75000, '2022-07-01'),
('David', 'IT', 90000, '2019-09-23'),
('Eva', 'IT', 120000, '2018-11-11'),
('Frank', 'IT', 95000, '2021-05-30'),
('Grace', 'Finance', 70000, '2020-12-05'),
('Helen', 'Finance', 85000, '2019-04-17'),
('Ian', 'Finance', 85000, '2022-02-14');


-- ROW_NUMBER(): Unique Rank Per Department:
SELECT emp_name, department, salary,
ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num_rank
FROM employees;


-- RANK(): With Gaps:
SELECT emp_name, department, salary,
RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS s_rank
FROM employees;


-- DENSE_RANK(): No Gaps:
SELECT emp_name, department, salary,
DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS s_dense_rank
FROM employees;


-- Compare all 3:
SELECT emp_name, department, salary,
ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num_rank,
RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank,
DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_dense_rank
FROM employees;


-- Running Total per Department:
SELECT emp_name, department, salary,
SUM(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS running_total
FROM employees;


-- LAG(): Compare Previous Salary:
SELECT emp_name, department, salary,
LAG(salary) OVER (PARTITION BY department ORDER BY joining_date) AS previous_salary
FROM employees;


-- LEAD(): Compare Next Salary:
SELECT emp_name, department, salary,
LEAD(salary) OVER (PARTITION BY department ORDER BY joining_date) AS next_salary
FROM employees;


-- Salary Trend Analysis (With Difference):
SELECT emp_name, department, salary,
salary - LAG(salary) OVER (PARTITION BY department ORDER BY joining_date) AS salary_difference
FROM employees;


-- Compare all 3:
SELECT emp_name, department, salary,
LAG(salary) OVER (PARTITION BY department ORDER BY joining_date) AS previous_salary,
LEAD(salary) OVER (PARTITION BY department ORDER BY joining_date) AS next_salary,
salary - LAG(salary) OVER (PARTITION BY department ORDER BY joining_date) AS salary_difference
FROM employees;


-- Window Function Without Reducing Rows:
-- GROUP BY (Reduces Rows):
SELECT department, AVG(salary)
FROM employees
GROUP BY department;

-- Window Function (Keeps All Rows):
SELECT department, salary,
AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees;


-- Combining Window Function with Subquery:
SELECT *
FROM (
SELECT emp_name, department, salary,
AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees) s
WHERE salary > dept_avg_salary;