SELECT current_database();

-- Droping the table if was already exists:

DROP TABLE IF EXISTS Students;

-- Creating a new Students table:

CREATE TABLE Students( 
Students_Id SERIES PRIMARY KEY, 
First_Name VARCHAR(50) NOT NULL, 
Last_Name VARCHAR(50) NOT NULL, 
Email VARCHAR(100) UNIQUE NOT NULL, 
Age INT NOT NULL, 
Grades FLOAT, 
DOB DATE
);

-- Insering few values to the student data:

NSERT INTO Students(First_Name, Last_Name, Email, Age, Grades, DOB) 
VALUES 
('Sam', 'Jois','sam_jois@gmail.com', 21, 3.8, '2003-08-06'), 
('Jane', 'Hopper', 'jane_hopper@gmail.com', 23, 3.2, '2001-04-15'), 
('David', 'Brown', 'david_brown@gmail.com', 20, 2.9, '2003-06-20'), 
('Niya', 'Patel', 'niya_patel@gmail.com', 22, 3.0, '2002-09-10'), 
('Sara', 'Pie', 'sara_pie@gmail.com', 21, 3.3, '2002-03-30');

-- Checking all the values in the Student data:

SELECT *
FROM Students;

-- Inserting invalid values to the data to see how constraint failures:

INSERT INTO Students
VALUES
(NULL, NULL, 'Rosely', 'brown@gmail.com', 24, 3.9, '2000-05-05'); 

/* ERROR:  null value in column "students_id" of relation "students" violates not-null constraint
Failing row contains (null, Rosely, Brown, brown@gmail.com, 24, 3.9, 2000-05-05). 

SQL state: 23502
Detail: Failing row contains (null, Rosely, Brown, brown@gmail.com, 24, 3.9, 2000-05-05) */

-- Inserting duplicate value to the data to see how constraint failures:

/INSERT INTO Students 
VALUES
(6, 'John', 'Lee', 'niya_patel@gmail.com', 20, 3.3, '2004-01-01'); 

/* ERROR:  duplicate key value violates unique constraint "students_email_key"
Key (email)=(niya_patel@gmail.com) already exists. 

SQL state: 23505
Detail: Key (email)=(niya_patel@gmail.com) already exists */

-- Adding new column to the Student data:

ALTER TABLE Students
ADD COLUMN Phone VARCHAR(12);

-- Renaming an existing column in the Student data:

ALTER TABLE Students
RENAME COLUMN DOB TO Date_Of_Birth;

-- Droping the existing column in the Student data:

ALTER TABLE STUDENTS
DROP COLUMN Phone;


SELECT *
FROM students;

/* Constrain and the valid data types are very important for sql queries because,
thay ensure data integrity by not allowing invalid data, duplications and ,issing data in the table.
In this data, have used SERIAL - for sequences, PRIMARY KEY - identify unique values in each row, 
NOT NULL - ensures no missing values, UNIQUE - ensures no duplicate values, DATE - for valid date format, 
VARCHAR(100) - text within 100 letters, INT - numeric values, FLOAT - decimal values. */