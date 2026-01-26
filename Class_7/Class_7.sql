SELECT current_database();
DROP VIEW IF EXISTS active_employees;
DROP TABLE IF EXISTS employees;


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
('Jane', 'Smith', 68000, '2020-06-01', 12),
('Mike', 'Brown', 90000, '2019-09-10', 13),
('Sara', 'Wilson', 72000, '2022-01-20', 14),
('David', 'Lee', 40000, '2023-07-01', 15),
('Emma', 'Taylor', 65000, '2021-11-11', 16); 


-- Attempting Invalid Foreign Key Insert:
INSERT INTO employees(first_name, last_name, salary, hire_date, department_id)
VALUES
('David', 'Shah', 70000, '2022-08-15', 99); 
-- department_id = 99 does not exist, Foreign key constraint prevents orphan records --
/* ERROR:  insert or update on table "employees" violates foreign key constraint "d_foreign_key"
Key (department_id)=(99) is not present in table "departments". */


-- Implement ON DELETE CASCADE and Explaining ON DELETE CASCADE Behavior:
ALTER TABLE employees
DROP CONSTRAINT d_foreign_key;

ALTER TABLE employees
ADD CONSTRAINT d_foreign_key FOREIGN KEY (department_id) REFERENCES departments (department_id)
ON DELETE CASCADE;

SELECT *
FROM employees;

DELETE FROM departments 
WHERE department_id = 12;

SELECT *
FROM employees;
-- ON DELETE CASCADE propagates the delete to dependent records
/* Department (ID = 2) is deleted and also, all employees in that department are automatically deleted */


-- Referential Integrity Summary:
1. Primary Key - Uniquely identifies a row
2. Foreign Key - Links two tables 
3. Referential Integrity - Prevents invalid relationships
4. ON DELETE CASCADE - Deletes dependent rows automatically
5. FK Violation - Prevents new records 


-- Real world mapping:

 Company
 |-- Department (HR)
 |     |-- Employee (Alice)
 |
 |-- Department (IT)
 |     |-- Employee (Bob)
 |
 |-- Department (Finance)
 |     |-- Employee (Charlie)
 |
 |-- Department (HR)
 |    |-- Employee (Sara)
 |
 |-- Department (IT)
 |     |-- Employee (David)
 |
 |-- Department (Finance)
       |-- Employee (Emma) 

	   
-- Explanation:
Company → concept
Department → parent entity
Employee → child entity
A Department can have many Employees, but an Employee belongs to one and only one Department.
