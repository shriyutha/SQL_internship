SELECT current_database();
DROP VIEW IF EXISTS active_employees;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees(
employee_id SERIAL,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
department VARCHAR(50),
role VARCHAR(50) NOT NULL,
salary NUMERIC(10,2) CHECK (salary > 0),
hire_date DATE,
active BOOLEAN DEFAULT TRUE,
CONSTRAINT primary_key PRIMARY KEY (employee_id)
--FOREIGN KEY (department_id) REFERENCES departments (department_id)
);


INSERT INTO employees(first_name, last_name, department, role, salary, hire_date)
VALUES
('John', 'Doe', 'IT', 'Data Analyst', 75000, '2021-03-15'),
('Jane', 'Smith', 'HR', 'HR Manager', 68000, '2020-06-01'),
('Mike', 'Brown', 'IT', 'Backend Engineer', 90000, '2019-09-10'),
('Sara', 'Wilson', 'Finance', 'Accountant', 72000, '2022-01-20'),
('David', 'Lee', 'IT', 'Intern', 40000, '2023-07-01'),
('Emma', 'Taylor', 'Marketing', 'Marketing Analyst', 65000, '2021-11-11');

ALTER TABLE employees
ADD COLUMN gender CHAR(1);

UPDATE employees
SET gender = 'F'
WHERE employee_id = 1;

UPDATE employees
SET gender = 'M'
WHERE employee_id = 2;

UPDATE employees
SET gender = 'F'
WHERE employee_id = 3;

UPDATE employees
SET gender = 'M'
WHERE employee_id = 4;

UPDATE employees
SET gender = 'F'
WHERE employee_id = 5;

UPDATE employees
SET gender = 'M'
WHERE employee_id = 6;

ALTER TABLE employees 
ALTER COLUMN hire_date 
SET NOT NULL; 

UPDATE employees
SET active = FALSE
WHERE employee_id = 4;

CREATE VIEW active_employees AS
SELECT employee_id, first_name, last_name, department, salary
FROM employees
WHERE 
active = TRUE; 


-- Select all employees:
SELECT *
FROM employees;


-- ValidatING BEFORE & AFTER:
-- Before
SELECT employee_id, role, active 
FROM employees;


-- Filter by department:
SELECT first_name, last_name, role, salary
FROM employees
WHERE department = 'IT';


-- All employees:
SELECT *
FROM employees
WHERE salary > 70000;


-- Update Records Using Conditions:
--Give IT employees a raise:
UPDATE employees
SET salary = salary + 6000
WHERE department = 'Finance';

-- Mark interns as inactive:
UPDATE employees
SET active = FALSE
WHERE role = 'Intern';


-- Validating BEFORE & AFTER:
-- After update
SELECT employee_id, role, active
FROM employees;


-- Deleting Selective Rows:
DELETE FROM employees
WHERE active = FALSE;


-- Using TRANSACTION:
BEGIN;

DELETE FROM employees
WHERE department = 'Marketing';

-- Validating before committing:
SELECT * 
FROM employees
WHERE department = 'Marketing';

-- If correct
COMMIT;

-- If mistake
--ROLLBACK;