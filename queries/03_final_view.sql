-- CREATE VIEW TO COMBINE ALL TRANSFORMATIONS INTO A FINAL OUTPUT
CREATE VIEW 
    v_employees_data AS
SELECT 
    e.employee_id AS [Employee ID], 
    e.proper_name AS [Employee Name], 
    e.gender AS [Gender],
    p.profession_name AS [Profession], 
    pg.profession_group_name AS [Profession Group], 
    e.date_of_birth AS [Date of Birth], 
    e.age AS [Age],
    e.hire_date AS [Hire Date], 
    e.resignation_date AS [Resignation Date]
FROM 
    employees e
INNER JOIN 
    employee_professions p ON e.profession_id = p.profession_id
INNER JOIN 
    employee_profession_groups pg ON p.profession_group_id = pg.profession_group_id

-- QUERY FINAL VIEW
SELECT * FROM v_employees_data

-- QUERY BEFORE AND AFTER VIEW CREATION TO VALIDATE DATA
CREATE VIEW 
    v_employees_data_before_after AS
SELECT 
    r.full_name AS [Raw Name (Before)],
    e.proper_name AS [Proper Name (After)]
FROM 
    employees e
INNER JOIN 
    employees_raw r ON e.employee_id = r.employee_id

-- QUERY COMPARISON OF RAW NAMES AND PROPER NAMES
SELECT * FROM v_employees_data_before_after
