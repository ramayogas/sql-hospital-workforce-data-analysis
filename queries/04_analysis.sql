PRAGMA table_info(employees);

select * from employees

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


-- ANALYZING PROFESSION DISTRIBUTION
SELECT 
	p.profession_name AS [Profession],
	COUNT ( p.profession_id ) AS [Number of Employees],
    ROUND(COUNT(p.profession_id) * 100 / CAST((SELECT COUNT(*) FROM employees) AS FLOAT),2) || '%' AS [Percentage of Total Employees]
  
FROM
	employees e
	INNER JOIN employee_professions p ON e.profession_id = p.profession_id 
GROUP BY
	p.profession_id


-- 5 MOST COMMON PROFESSIONS
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


-- AGES , pr ini substr dll, buat kategori umur, misal 20-30, 31-40, dst, kasi label misal gen z boomer dll,sama persentase
select date_of_birth from employees --28/12/1974


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