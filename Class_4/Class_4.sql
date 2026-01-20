-- Creating a Dashboard:
CREATE DATABASE Students;


-- Creating a table:
CREATE TABLE Students_data(
    gender VARCHAR(10),
    race_ethnicity VARCHAR(20),
    parental_level_of_education VARCHAR(50),
    lunch VARCHAR(20),
    test_preparation_course VARCHAR(20),
    math_score INT,
    reading_score INT,
    writing_score INT);



/* Notes:
Imported a dataset with 1000 rows called StudentsPerformance.csv file has:
	CSV HEADER 
	Path: /Users/username/Downloads/StudentsPerformance.csv
	Columns in parentheses */


-- View all data:
SELECT * 
FROM Students_data;


-- Count total rows:
SELECT COUNT(*) AS Total_count
FROM Students_data;


-- Sort DESC / ASC:
SELECT gender, math_score
FROM Students_data
ORDER BY math_score DESC;


-- Multi-column sorting:
SELECT gender, math_score, reading_score
FROM Students_data
ORDER BY math_score DESC, reading_score ASC;


-- WHERE + ORDER BY + LIMIT:
SELECT *
FROM Students_data
WHERE test_preparation_course = 'completed'
ORDER BY math_score DESC
LIMIT 10;


-- Pagination using OFFSET:
SELECT *
FROM Students_data
ORDER BY math_score 
LIMIT 5 
OFFSET 5;


-- OFFSET Beyond Row Count:
SELECT *
FROM Students_data
ORDER BY math_score 
LIMIT 5 
OFFSET 5000;
/* PostgreSQL returns empty set but no error messages */

-- Leaderboard style query & handle NULL values:
SELECT gender, (math_score + reading_score + writing_score) AS Total_score
FROM Students_data
ORDER BY Total_score DESC NULLS LAST
LIMIT 15;


-- Edge case: OFFSET beyond row count:
SELECT gender, math_score
FROM Students_data
ORDER BY math_score DESC, gender ASC NULLS LAST
LIMIT 10;


-- Adding a Unique ID for Leaderboard:
/*ALTER TABLE Students_data
ADD COLUMN student_id SERIAL PRIMARY KEY;*/


-- Duplicate score:
SELECT student_id, gender, math_score
FROM Students_data
ORDER BY math_score DESC, student_id ASC
LIMIT 15;


-- Performance analysis :
EXPLAIN ANALYZE
SELECT *
FROM Students_data
ORDER BY math_score DESC
LIMIT 10 OFFSET 30;


/* ORDER BY ascending/descending
Multi column sorting
LIMIT
WHERE + ORDER BY
OFFSET pagination & OFFSET = (page_number - 1) * page_size
Leaderboard style query
Edge cases
Performance check */