SELECT current_database();

-- Droping the table if was already exists:
DROP TABLE IF EXISTS Students;


-- Creating a new Students table:
CREATE TABLE Students(
Students_Id SERIAL PRIMARY KEY,
First_Name VARCHAR(50) NOT NULL,
Last_Name VARCHAR(50) NOT NULL,
Email VARCHAR(100) UNIQUE,
Age INT NOT NULL,
Grades FLOAT NOT NULL,
DOB DATE,
Gender CHAR(1) NOT NULL
);


-- Insering few values to the student data:
INSERT INTO Students(First_Name, Last_Name, Email, Age, Grades, DOB, Gender)
VALUES
('Sam', 'Jois','sam_jois@gmail.com', 21, 3.8, '2003-08-06', 'M'), 
('Jane', 'Hopper', 'jane_hopper@gmail.com', 23, 3.2, '2001-04-15', 'F'), 
('David', 'Brown', 'david_brown@gmail.com', 20, 2.9, '2003-06-20', 'M'), 
('Niya', 'Patel', 'niya_patel@gmail.com', 22, 3.0, '2002-09-10', 'F'), 
('John', 'Lee', 'john_lee@gmail.com', 24, 3.5, '2000-11-12', 'M');


-- Checking all the values in the Student data:
SELECT *
FROM Students;


-- Adding new column to the Student data:
ALTER TABLE StuDents
ADD COLUMN Phone VARCHAR(10) UNIQUE;


-- Updating all the values to new column:
UPDATE Students
SET Phone = 4155551023
WHERE students_id = 1;

UPDATE Students
SET Phone = 7815554567
WHERE students_id = 2;

UPDATE Students
SET Phone = 4695553434
WHERE students_id = 3;

UPDATE Students
SET Phone = 7035557789
WHERE students_id = 4;

UPDATE Students
SET Phone = 6175559898
WHERE students_id = 5;


-- Checking the values:
SELECT students_id, First_Name, Phone
FROM Students;


-- Using WHERE clause to filter Age:
SELECT CONCAT(First_Name, ' ', Last_Name) AS Full_Name, Age
FROM Students
WHERE Age >= 21;


-- Using Boolean conditions like AND / OR:
SELECT First_Name, Gender, DISTINCT(Age), Grades, Email
FROM Students
WHERE Gender = 'F' AND Grades >= 3;


-- Using Like with wildcards % and _:
SELECT * 
FROM Students
WHERE Last_Name LIKE '%a%' OR Last_Name LIKE '%e_';


-- Using IN and BETWEEN clause in Students Table:
SELECT *
FROM Students
WHERE Age IN(21, 22, 23) OR Grades BETWEEN 3.0 AND 3.5
ORDER BY Age DESC;


-- Using NULL clause and AS clause:
SELECT COALESCE(Phone, 'N/A'), Email AS Email_Id
FROM Students
WHERE Email IS NOT NULL AND Email ILIKE '%gmail%';


/* The Clauses used in this file like SELECT: used to display the columns, 
WHERE: used to filter the rows, ORDER BY: used to sort the results,
FROM: specifies which table to use, DISTINCT: to remove duplicate values,
LIKE/ILIKE: for specific matching values, AND/OR: boolean conditions,
IS NULL/IS NOT NULL: checking missing values, AS: to rename tables/columns,
IN: check multiple values from range, BETWEEN: filtering the range.
COALESCE: fills missing values. */