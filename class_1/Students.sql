SELECT current_database();


CREATE TABLE Students(
Id SERIAL Primary Key,
First_Name VARCHAR(50),
Last_Name VARCHAR(50),
Email VARCHAR(100),
Age INT,
Grade FLOAT);


INSERT INTO Students(First_Name, Last_Name, Email, Age, Grade)
VALUES
('Sam', 'Jois','sam_jois@gmail.com', 21, 3.8),
('Jane', 'Hopper', 'jane_hopper@gmail.com', 23, 3.2),
('David', 'Brown', 'david_brown@gmail.com', 20, 2.9),
('Niya', 'Patel', 'niya_patel@gmail.com', 22, 3.0),
('Sara', 'Pie', 'sara_pie@gmail.com', 21, 3.3);


SELECT * 
FROM Students;

SELECT concat(First_Name, ' ', Last_Name) as Full_Name
FROM Students;

SELECT First_Name, Email
FROM Students
WHERE age > 21;

SELECT First_Name, Last_Name, (Grade/4.0)*100 as Percentage
FROM Students; 

SELECT Email, Grade
FROM Students
WHERE Grade BETWEEN 3.5 AND 4.5;