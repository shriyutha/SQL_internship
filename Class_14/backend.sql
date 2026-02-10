-- Sample Table:

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary NUMERIC(10,2) CHECK (salary > 0),
    join_date DATE DEFAULT CURRENT_DATE);

------------------------------------------------------------------------------------------------

-- Stored Procedure to Insert Employee Data:
CREATE OR REPLACE PROCEDURE insert_employee(
    p_name VARCHAR,
    p_department VARCHAR,
    p_salary NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employees (emp_name, department, salary)
    VALUES (p_name, p_department, p_salary);

    RAISE NOTICE 'Employee % inserted successfully', p_name;

EXCEPTION
    WHEN check_violation THEN
        RAISE EXCEPTION 'Salary must be greater than zero';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error inserting employee: %', SQLERRM;
END;
$$;

-- Calling the procedure:

CALL insert_employee('Shri', 'Data Science', 85000);

-- New row will appear:
SELECT * FROM employees;

---------------------------------------------------------------------------------------

-- User-Defined Function (UDF): Calculate Bonus or Tax:
CREATE OR REPLACE FUNCTION calculate_bonus(p_salary NUMERIC)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN p_salary * 0.10;
END;
$$;

-- Using in the Function:
SELECT 
    emp_name,
    salary,
    calculate_bonus(salary) AS bonus
FROM employees;

---------------------------------------------------------------------------------------

-- User-Defined Function (UDF): Calculate Bonus or Tax for all employees:
CREATE OR REPLACE FUNCTION calculate_tax(p_salary NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN CASE
        WHEN p_salary < 50000 THEN p_salary * 0.05
        WHEN p_salary < 100000 THEN p_salary * 0.10
        ELSE p_salary * 0.20
    END;
END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------

/* -- Mapping for Stored Procedures to Backend Services:
Backend (Python / Node / Java) Flow
API Request
   ↓
Service Layer
   ↓
CALL insert_employee(...)
   ↓
Database handles validation + insert 						*/
