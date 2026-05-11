-- 1. ANALYZING GENDER DISTRIBUTION
SELECT
    ROUND((COUNT(CASE WHEN gender = 'M' THEN 'Male' END ) * 100.0) / (SELECT COUNT(*) FROM employees), 2 ) || '%' AS [Male Employees],
    ROUND((COUNT(CASE WHEN gender = 'F' THEN 'Female' END ) * 100.0) / (SELECT COUNT(*) FROM employees), 2 ) || '%' AS [Female Employees]
FROM
	employees


-- 2. ANALYZING PROFESSION DISTRIBUTION
SELECT 
	p.profession_name AS [Profession],
	COUNT ( p.profession_id ) AS [Number of Employees],
    ROUND(COUNT(p.profession_id) * 100 / (SELECT COUNT(*) FROM employees),2) || '%' AS [Percentage of Total Employees]
  
FROM
	employees e
	INNER JOIN employee_professions p ON e.profession_id = p.profession_id 
GROUP BY
	p.profession_id
ORDER BY
    COUNT(p.profession_id) DESC


-- 3. MOST COMMON PROFESSIONS
SELECT 
	p.profession_name AS [Profession],
	COUNT ( p.profession_id ) AS [Number of Employees],
    ROUND(COUNT(p.profession_id) * 100 / (SELECT COUNT(*) FROM employees),2) || '%' AS [Percentage of Total Employees]
  
FROM
	employees e
	INNER JOIN employee_professions p ON e.profession_id = p.profession_id 
GROUP BY
	p.profession_id
ORDER BY
    COUNT(p.profession_id) DESC
LIMIT 5


-- 4. GENDER BREAKDOWN PER PROFESSION GROUP
SELECT
	p.profession_name AS [Profession],
	e.gender AS [Gender],
	COUNT (e.gender) AS [Number of Employees],
	ROUND(
		COUNT(e.gender)* 100.0 / SUM (COUNT(e.gender)) OVER () ,
		2 
	) || '%' AS [Percentage]
FROM
	employees e
	INNER JOIN employee_professions p ON e.profession_id = p.profession_id 
GROUP BY
	p.profession_name,
	e.gender
ORDER BY
    COUNT (e.gender) DESC,
    p.profession_name

-- 5. AGE DISTRIBUTION PER GENERATION
WITH employees_age AS(
 SELECT 
    age,
   case 
    WHEN age BETWEEN 18 AND 24 THEN 'Gen Z'
    WHEN age BETWEEN 25 AND 40 THEN 'Millennials'
    WHEN age BETWEEN 41 AND 56 THEN 'Gen X'
    WHEN age BETWEEN 57 AND 75 THEN 'Baby Boomers'
    ELSE 'Silent Generation' END AS [Generation]
   FROM employees
 )
 SELECT 
    age, generation
    FROM employees_age
    GROUP BY age, generation

-- 6. NAME FORMAT STANDARDIZATION RATE
SELECT 
    ROUND(COUNT(CASE WHEN r.full_name = e.proper_name THEN 'SAME' ELSE NULL END) * 100.0 / COUNT(r.employee_id) ,2) || '%' AS [valid_name_format],
    ROUND(COUNT(CASE WHEN r.full_name <> e.proper_name THEN 'NEW' ELSE NULL END) * 100.0 / COUNT(r.employee_id) ,2) || '%' AS [malformed_name_format]
FROM employees_raw r
INNER JOIN employees e ON r.employee_id = e.employee_id
