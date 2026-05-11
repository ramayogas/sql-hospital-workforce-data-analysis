-- 1. ANALYZING GENDER DISTRIBUTION
SELECT
	CAST(
        ROUND(
            (COUNT
                (CASE WHEN gender = 'M' THEN 'Male' END ) / 
                CAST((SELECT COUNT(*) FROM employees) AS FLOAT)
            * 100)
        , 2 ) 
    AS TEXT) || '%' AS [Male Employees],
	CAST(
        ROUND( 
            (COUNT 
                (CASE WHEN gender = 'F' THEN 'Female' END ) / 
                CAST((SELECT COUNT(*) FROM employees) AS FLOAT)
            * 100 )
        , 2 ) 
    AS TEXT) || '%' AS [Female Employees]
FROM
	employees


-- 2. ANALYZING PROFESSION DISTRIBUTION
SELECT 
	p.profession_name AS [Profession],
	COUNT ( p.profession_id ) AS [Number of Employees],
    ROUND(COUNT(p.profession_id) * 100 / CAST((SELECT COUNT(*) FROM employees) AS FLOAT),2) || '%' AS [Percentage of Total Employees]
  
FROM
	employees e
	INNER JOIN employee_professions p ON e.profession_id = p.profession_id 
GROUP BY
	p.profession_id


-- 3. MOST COMMON PROFESSIONS
SELECT 
	p.profession_name AS [Profession],
	COUNT ( p.profession_id ) AS [Number of Employees],
    ROUND(COUNT(p.profession_id) * 100 / CAST((SELECT COUNT(*) FROM employees) AS FLOAT),2) || '%' AS [Percentage of Total Employees]
  
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
		CAST(COUNT(e.gender) AS FLOAT) / SUM (COUNT(e.gender)) OVER () * 100.0,
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

-- 5.
WITH employees_age AS(
 SELECT 
    age,
   case 
    when age between 18 and 24 then 'Gen Z'
    when age between 25 and 40 then 'Millennials'
    when age between 41 and 56 then 'Gen X'
    when age between 57 and 75 then 'Baby Boomers'
    else 'Silent Generation' end as [Generation]
   from employees
 )
 select 
    age, generation
    from employees_age