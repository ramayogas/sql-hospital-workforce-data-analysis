PRAGMA table_info(employees);

select distinct count(gender) from employees

-- ANALYZING GENDER DISTRIBUTION
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

--
SELECT 
	p.profession_name AS [Profession],
	COUNT ( p.profession_id ) AS [Number of Employees],
    ROUND(COUNT(p.profession_id) * 100 / CAST((SELECT COUNT(*) FROM employees) AS FLOAT),2) || '%' AS [Percentage of Total Employees]
  
FROM
	employees e
	INNER JOIN employee_professions p ON e.profession_id = p.profession_id 
GROUP BY
	p.profession_id