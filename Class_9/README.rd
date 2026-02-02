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


Query part			Order
		Subquery			First
		FROM				Next
		WHERE				After
		SELECT				Last   
