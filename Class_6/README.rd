Created a new table:

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

Used transactions:

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
