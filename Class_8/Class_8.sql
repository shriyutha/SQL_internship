SELECT current_database();
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


-- Employees with valid departments only using INNER JOIN:
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;

-- Identifying employees without departments using LEFT JOIN:
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;


-- Listing all departments, including empty ones using RIGHT JOIN:
SELECT d.department_id, d.department_name, e.first_name
FROM employees e
RIGHT JOIN departments d
ON d.department_id = e.department_id;


-- Returns all the rows from both tables:
SELECT e.employee_id, e.first_name, d.department_name 
FROM employees e
FULL JOIN departments d
ON d.department_id = e.department_id;


--UNION removes duplicate rows:
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
UNION
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e
RIGHT JOIN departments d
ON d.department_id = e.department_id;


--UNION ALL gets all duplicate records and null values:
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
UNION ALL
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e
RIGHT JOIN departments d
ON d.department_id = e.department_id;


/*  INNER JOIN returns matching records, 
	LEFT JOIN identifies missing relationships, 
	RIGHT JOIN highlights unused master data, 
	FULL JOIN ensures complete reconciliation.
	In MySQL, FULL JOIN is simulated using UNION. */


