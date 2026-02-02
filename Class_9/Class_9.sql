SELECT current_database();
DROP TABLE IF EXISTS employees;


-- Creating a Employees Table:
CREATE TABLE employees(
employee_id SERIAL,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
salary NUMERIC(10,2) CHECK (salary > 0),
hire_date DATE,
department VARCHAR(50),
active BOOLEAN DEFAULT TRUE,
CONSTRAINT e_primary_key PRIMARY KEY (employee_id)
--CONSTRAINT d_foreign_key FOREIGN KEY (department_id) REFERENCES departments (department_id)
);


-- Inserting Valid Records on employees:
INSERT INTO employees(first_name, last_name, salary, hire_date, department)
VALUES
('John', 'Doe', 75000, '2021-03-15', 'IT'),
('Jane', 'Smith', 68000, '2020-06-01', 'HR'),
('Mike', 'Brown', 90000, '2019-09-10', 'SALES'),
('Sara', 'Wilson', 72000, '2022-01-20', 'IT'),
('David', 'Lee', 40000, '2023-07-01', 'HR'),
('Emma', 'Taylor', 65000, '2021-11-11', 'SALES'); 


-- Basic subquery for employees earning more than average salary:
SELECT first_name, salary, department
FROM employees
WHERE salary > (SELECT AVG(salary) 
FROM employees);
-- The subquery is evaluated first and returns a scalar value, which is then used by the outer queries like WHERE clause.


-- Subquery in the SELECT clause:
SELECT first_name, salary, department, ROUND((SELECT AVG(salary) FROM employees), 2) AS avg_salary
FROM employees;
-- THE subquery will executed once and is not correlated nut the result will bereused for all rows.


-- Equivalent JOIN based solution:
SELECT e.first_name, e.salary, e.department
FROM employees e
JOIN (SELECT AVG(salary) AS avg_salary FROM employees) es
ON e.salary > es.avg_salary;
-- Same as basic sub query.


-- Correlated subquery:
SELECT first_name, salary, department
FROM employees e
WHERE salary > (SELECT AVG(salary) AS avg_salary FROM employees WHERE e.department = department);
-- A correlated subquery depends on the outer query and is executed once per row, which can impact performance on large datasets,


-- Equivalent JOIN version for correlated subquery:
SELECT e.first_name, e.salary, e.department
FROM employees e
JOIN (SELECT department, AVG(salary) AS avg_salary FROM employees GROUP BY department) d
ON e.department = d.department
WHERE e.salary > d.avg_salary;


-- When subqueries are UNAVOIDABLE:
SELECT first_name, salary, department
FROM employees
WHERE salary > (SELECT MAX(salary) 
FROM employees);
-- No scalar value from this clause.


/* 		Query part			Order
		Subquery			First
		FROM				Next
		WHERE				After
		SELECT				Last   		 */