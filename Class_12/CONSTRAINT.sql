DROP TABLE IF EXISTS employees;


-- SQL Schema: Creating a table:
CREATE TABLE employees (
    employee_id SERIAL 
		PRIMARY KEY,

    email VARCHAR(100)
        UNIQUE NOT NULL,

    age INT
        CHECK (age BETWEEN 18 AND 65),

    salary NUMERIC(10,2)
        CHECK (salary > 0),

    department VARCHAR(50)
        CHECK (department IN ('HR', 'IT', 'Finance', 'Sales')),

    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP
);

/* 
1. email
email VARCHAR(100) UNIQUE NOT NULL
NOT NULL → email must exist
UNIQUE → no duplicates allowed
- Prevents duplicate user accounts
- Multiple constraints on one column
2. age
- CHECK (age BETWEEN 18 AND 65)
- Enforces numeric range
- Prevents invalid ages
- This is numeric validation at database level
3. salary
- CHECK (salary > 0)
- Salary must be positive
- Prevents negative or zero salary
4. department
- CHECK (department IN ('HR', 'IT', 'Finance', 'Sales'))
- Restricts values to known categories
- Prevents spelling mistakes
5. created_at
- DEFAULT CURRENT_TIMESTAMP
- Automatically stores insert time
- No need to supply value manually
*/

-- Inserting Valid Data:
INSERT INTO employees (email, age, salary, department)
VALUES ('alice@example.com', 30, 75000, 'IT');


SELECT *
FROM employees;


-- Test Constraint Violations:
INSERT INTO employees (email, age, salary, department)
VALUES ('alice@example.com', 28, 65000, 'HR');
-- ERROR: duplicate key value violates unique constraint "employees_email_key"

INSERT INTO employees (email, age, salary, department)
VALUES ('bob@example.com', 15, 40000, 'Sales');
-- ERROR: violates check constraint, new row for relation "employees" violates check constraint "employees_age_check"

INSERT INTO employees (email, age, salary, department)
VALUES ('charlie@example.com', 35, -5000, 'Finance');
-- ERROR: ew row for relation "employees" violates check constraint "employees_salary_check"


-- Combining Multiple Constraints on One Column:
ALTER TABLE employees
ALTER COLUMN email TYPE VARCHAR(100);

ALTER TABLE employees
ALTER COLUMN email SET NOT NULL;

LTER TABLE employees
ADD CONSTRAINT email_unique UNIQUE (email);

-- OR --

CREATE TABLE employees (
    email VARCHAR(100) UNIQUE NOT NULL);
