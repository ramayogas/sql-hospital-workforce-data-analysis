-- 1. ANALYZING GENDER DISTRIBUTION
SELECT
    COUNT(*) AS [total_employees],
    COUNT(CASE WHEN gender = 'M' THEN 'Male' END) AS [male_count],
    COUNT(CASE WHEN gender = 'F' THEN 'Female' END) AS [female_count],
    ROUND((COUNT(CASE WHEN gender = 'M' THEN 'Male' END ) * 100.0) / (SELECT COUNT(*) FROM employees), 2 ) || '%' AS [male_employees_percentage],
    ROUND((COUNT(CASE WHEN gender = 'F' THEN 'Female' END ) * 100.0) / (SELECT COUNT(*) FROM employees), 2 ) || '%' AS [female_employees_percentage]
FROM
	employees


-- 2. ANALYZING PROFESSION DISTRIBUTION
SELECT 
	p.profession_name AS [profession],
	COUNT ( p.profession_id ) AS [number_of_employees],
    ROUND(COUNT(p.profession_id) * 100 / (SELECT COUNT(*) FROM employees),2) || '%' AS [percentage_of_total_employees]
  
FROM
	employees e
	INNER JOIN employee_professions p ON e.profession_id = p.profession_id 
GROUP BY
	p.profession_id
ORDER BY
    COUNT(p.profession_id) DESC


-- 3. MOST COMMON PROFESSIONS
SELECT 
	p.profession_name AS [profession],
	COUNT (p.profession_id) AS [number_of_employees],
    ROUND(COUNT(p.profession_id) * 100 / (SELECT COUNT(*) FROM employees),2) || '%' AS [percentage_of_total_employees]
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
	p.profession_name AS [profession],
	e.gender AS [gender],
	COUNT (e.gender) AS [number_of_employees],
	ROUND(
		COUNT(e.gender)* 100.0 / SUM (COUNT(e.gender)) OVER () ,
		2 
	) || '%' AS [percentage_of_total_employees]
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
    ELSE 'Silent Generation' END AS [generation]
   FROM employees
 )
 SELECT 
    age, generation
    FROM employees_age
    GROUP BY age, generation

-- 6. NAME FORMAT STANDARDIZATION RATE
SELECT 
    COUNT(r.employee_id) AS [count_before_standarization],
    COUNT(e.employee_id) AS [count_after_standardization],
    ROUND(COUNT(CASE WHEN r.full_name = e.proper_name THEN 'SAME' ELSE NULL END) * 100.0 / COUNT(r.employee_id) ,2) || '%' AS [valid_name_format],
    ROUND(COUNT(CASE WHEN r.full_name <> e.proper_name THEN 'NEW' ELSE NULL END) * 100.0 / COUNT(r.employee_id) ,2) || '%' AS [malformed_name_format]
FROM employees_raw r
INNER JOIN employees e ON r.employee_id = e.employee_id

