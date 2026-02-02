SELECT current_database();
DROP VIEW IF EXISTS view_employees;
DROP VIEW IF EXISTS view_employee_details;


DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;


-- Create Departments Table:
CREATE TABLE departments(
    department_id INT,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
	CONSTRAINT d_primary_key PRIMARY KEY (department_id)
);


-- Create Employees Table:
CREATE TABLE employees(
employee_id SERIAL,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
salary NUMERIC(10,2) CHECK (salary > 0),
hire_date DATE,
department_id INT,
active BOOLEAN DEFAULT TRUE,
CONSTRAINT e_primary_key PRIMARY KEY (employee_id),
CONSTRAINT d_foreign_key FOREIGN KEY (department_id) REFERENCES departments (department_id)
);


-- Insert Valid Records on departments:
INSERT INTO departments(department_id, department_name, location)
VALUES
(11, 'HR', 'New York'),
(12, 'IT', 'London'),
(13, 'Finance', 'Singapore'),
(14, 'HR', 'Bengalore'),
(15, 'IT', 'Chennai'),
(16, 'Finance', 'California');


-- Insert Valid Records on employees:
INSERT INTO employees(first_name, last_name, salary, hire_date, department_id)
VALUES
('John', 'Doe', 75000, '2021-03-15', 11),
('Jane', 'Smith', 68000, '2020-06-01', NULL),
('Mike', 'Brown', 90000, '2019-09-10', 13),
('Sara', 'Wilson', 72000, '2022-01-20', 14),
('David', 'Lee', 40000, '2023-07-01', NULL),
('Emma', 'Taylor', 65000, '2021-11-11', 16); 


-- Basic queries:
SELECT * 
FROM employees;

SELECT * 
FROM departments;


-- A complex JOIN query:
SELECT e.first_name, e.salary, d.department_name, d.location, e.department_id
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;


-- Converting this query into a VEWI:
CREATE VIEW view_employee AS
SELECT e.first_name, e.salary, d.department_name, d.location, e.department_id
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;
-- A view is a stored query that behaves like a virtual table. And, No data is stored... only SQL logic.


-- Quering data directly from the VIEW:
SELECT * 
FROM view_employee;
-- To the user, it looks like a table... but it is not.


-- Appling filtering on a VIEW:
SELECT *
FROM view_employee
WHERE salary > 60000;


-- Appling sorting on a VIEW:
SELECT *
FROM view_employee
ORDER BY salary DESC;


-- Security:
GRANT SELECT ON view_employee TO reporting_user;
-- User can see employee details

/*  Views are virtual tables that encapsulate joins and business logic, 
	improve security by limiting column access, simplify reporting, 
	and can sometimes allow updates when based on a single table  */

/*  Inserting data through a VIEW to above cluase will FAIL.
	Because: View is based on multiple tables
	PostgreSQL does not know how to split the insert	*/

-- When INSERT into VIEW works:
CREATE VIEW view_employees_basic AS
SELECT first_name, last_name, salary, hire_date, department_id
FROM employees;

INSERT INTO view_employees_basic (first_name, last_name, salary, hire_date, department_id)
VALUES ('Grace', 'joe', 48000, '2022-06-01', 16);


-- Droping view:
DROP VIEW IF EXISTS view_employee_details;


-- Recreating view:
CREATE OR REPLACE VIEW view_employee_details AS
SELECT first_name, last_name, salary, hire_date, department_id
FROM employees;