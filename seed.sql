-- Innsert Employee Group Data
INSERT INTO employee_profession_groups (profession_group_id,profession_group_name)
VALUES
(1,'Medical'),
(2,'Non Medical');

-- Insert Employee Profession Data
INSERT INTO employee_professions (profession_name, profession_group_id)
VALUES
    -- MEDICAL (1)
    ('Doctor', 1),
    ('Specialist Doctor', 1),
    ('Nurse', 1),
    ('Midwife', 1),
    ('Medical Support', 1),
    ('Electromedical Technician', 1),
    ('Radiographer', 1),
    ('Laboratory Analyst', 1),
    ('Pharmacist', 1),
    ('Physiotherapist', 1),
    ('Nutritionist', 1),
    ('Blood Bank Officer', 1),

    -- NON MEDICAL (2)
    ('Management', 2),
    ('Casemix / BPJS Claim', 2),
    ('IT Team', 2),
    ('Medical Records', 2),
    ('Administration', 2),
    ('Finance', 2),
    ('Security', 2),
    ('Cleaning Service', 2),
    ('CSSD', 2),
    ('Ambulance Driver', 2),
    ('Laundry Staff', 2),
    ('Building Technician', 2),
    ('K3 / Occupational Health & Safety', 2);

/** Insert Employees Data
1. Insert by importing CSV
2. Access ./sqlite (dbname).db
3. Type .mode csv
4. Type .import (csvname).csv (tablename)
**/

select * from employees