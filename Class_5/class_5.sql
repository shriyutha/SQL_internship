-- Basic query:
SELECT *
FROM students_data;


-- COUNT (basic aggregation):
SELECT COUNT(*) AS Total_count
FROM students_data
WHERE gender = 'female';


-- SUM & AVG:
SELECT SUM(math_score) AS Total_score, AVG(math_score) AS Average_score
FROM students_data
WHERE gender = 'male';


-- MIN & MAX (combined scores):
SELECT MIN(math_score + reading_score + writing_score) AS Min_score,
MAX(math_score + reading_score + writing_score) AS Max_score
FROM students_data
WHERE test_preparation_course = 'completed';


-- GROUP BY (single column):
SELECT gender, COUNT(*) AS Num_students
FROM students_data
GROUP BY gender;


-- GROUP BY (multiple columns) + ORDER BY + LIMIT:
SELECT gender, parental_level_of_education, 
ROUND(AVG(reading_score), 2) AS Avg_reading
FROM students_data
GROUP BY gender, parental_level_of_education
ORDER  BY Avg_reading DESC
LIMIT 5;


-- WHERE vs GROUP BY (correct usage):
SELECT race_ethnicity, parental_level_of_education, COUNT(*) AS Total_count
FROM students_data
WHERE parental_level_of_education = 'high school'
GROUP BY race_ethnicity, parental_level_of_education 
ORDER  BY Total_count DESC;


-- HAVING (filtering aggregated groups):
SELECT race_ethnicity, parental_level_of_education, COUNT(*) AS Total_count
FROM students_data
WHERE parental_level_of_education = 'high school'
GROUP BY race_ethnicity, parental_level_of_education 
HAVING COUNT(*) >= 25 
ORDER  BY Total_count ASC;


-- NULLs in aggregates:
SELECT COUNT(*) AS Total_students,
COUNT(math_score) AS Students_with_math_score,
ROUND(AVG(COALESCE(math_score)), 2) AS Avg_math_score
FROM students_data;

/* Key Insights

Female and male students showed differences in average subject scores.

Students who completed test preparation courses achieved higher combined scores.

Parental level of education showed a noticeable relationship with reading performance.

Certain race/ethnicity groups had higher representation within specific parental education categories.

Applying HAVING helped focus the analysis on statistically meaningful group sizes. */