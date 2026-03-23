SELECT current_database();

DROP TABLE IF EXISTS analyst;

-- This project analyzes data analyst job postings to identify which skills and factors most influence salary --

CREATE TABLE analyst(
	position_level TEXT NOT NULL,
    company_name TEXT NOT NULL,
    salary DOUBLE PRECISION NOT NULL,
    url TEXT NOT NULL,
    description TEXT NOT NULL,

    longitude FLOAT,
    latitude FLOAT,

    created_at TIMESTAMP NOT NULL,
    category TEXT NOT NULL,

    year INTEGER NOT NULL,
    month INTEGER NOT NULL,

    city TEXT NOT NULL,
    region TEXT,

    job_type TEXT NOT NULL,

    "401k" BOOLEAN NOT NULL,
    health_insurance BOOLEAN NOT NULL,
    dental BOOLEAN NOT NULL,
    vision BOOLEAN NOT NULL,
    parental_leave BOOLEAN NOT NULL,

    python_r INTEGER NOT NULL,
    data_analysis INTEGER NOT NULL,
    sql INTEGER NOT NULL,
    excel INTEGER NOT NULL,
    tableau_bi INTEGER NOT NULL,
    statistics INTEGER NOT NULL,
    problem_solving INTEGER NOT NULL,

    remote BOOLEAN NOT NULL,
    job_roles TEXT NOT NULL
);

SELECT COUNT(*)
FROM analyst;

SELECT *
FROM analyst
LIMIT 5;

-- Data Cleaning / Preparation Steps:
DELETE FROM analyst WHERE salary IS NULL;

UPDATE analyst
SET job_type = LOWER(job_type);

-- 1. Salary by Seniority Level:
SELECT 
position_level,
COUNT(*) AS job_count,
ROUND(AVG(salary), 2) AS avg_salary,
MIN(salary) AS min_salary,
MAX(salary) AS max_salary
FROM analyst
GROUP BY position_level
ORDER BY avg_salary DESC;


-- 2. Salary Impact of Skills:
SELECT 'SQL' AS skill,
ROUND(AVG(CASE WHEN sql = 1 THEN salary END), 2) AS with_skill,
ROUND(AVG(CASE WHEN sql = 0 THEN salary END), 2) AS without_skill
FROM analyst

UNION ALL

SELECT 'Python_R',
ROUND(AVG(CASE WHEN python_r = 1 THEN salary END), 2),
ROUND(AVG(CASE WHEN python_r = 0 THEN salary END), 2)
FROM analyst


-- 3. Top Paying Skill Combinations:
SELECT python_r, sql, tableau_bi, COUNT(*) AS job_count, ROUND(AVG(salary), 2) AS avg_salary
FROM analyst
GROUP BY python_r, sql, tableau_bi
HAVING COUNT(*) > 10
ORDER BY avg_salary DESC;


-- 4. Percentage of Jobs Requiring Each Skill:
SELECT 
ROUND(100.0 * SUM(sql)/COUNT(*), 2) AS sql_pct,
ROUND(100.0 * SUM(python_r)/COUNT(*), 2) AS python_pct,
ROUND(100.0 * SUM(excel)/COUNT(*), 2) AS excel_pct,
ROUND(100.0 * SUM(tableau_bi)/COUNT(*), 2) AS tableau_pct
FROM analyst;

-- 5. Highest Paying Roles:
SELECT job_roles, company_name, job_type, salary
FROM analyst
ORDER BY salary DESC
LIMIT 10;


-- 6. Salary percentile by role:
SELECT job_roles, position_level, salary,
PERCENT_RANK() OVER (PARTITION BY position_level ORDER BY salary DESC) AS salary_percentile
FROM analyst;

SELECT job_roles, salary,
AVG(salary) OVER (PARTITION BY job_roles) AS role_avg_salary
FROM analyst;


-- 7. Jobs above average salary
SELECT job_roles, position_level, salary, category, region, job_type
FROM analyst j
WHERE salary > (SELECT AVG(salary)
    			FROM analyst
    			WHERE position_level = j.position_level
 			    );


-- 8. Multi-Dimensional Analysis:
SELECT position_level, sql, python_r, COUNT(*) AS job_count, AVG(salary) AS avg_salary
FROM analyst
GROUP BY position_level, sql, python_r
ORDER BY avg_salary DESC;


-- 9. Clean pipeline logic:
WITH skill_salary AS (
SELECT sql, python_r, salary
FROM analyst
), aggregated AS (
SELECT sql, python_r, AVG(salary) AS avg_salary
FROM skill_salary
GROUP BY sql, python_r
)
SELECT *
FROM aggregated
ORDER BY avg_salary DESC;


-- 10. Running totals / trends:
SELECT year, month, COUNT(*) AS jobs_posted,
SUM(COUNT(*)) OVER (ORDER BY year, month) AS cumulative_jobs
FROM analyst
GROUP BY year, month;


-- 11. Benefits Analysis:
SELECT health_insurance, job_type, AVG(salary) AS avg_salary
FROM analyst
GROUP BY health_insurance, job_type;