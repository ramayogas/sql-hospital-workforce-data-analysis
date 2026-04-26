-- Employee professions group table
CREATE TABLE IF NOT EXISTS employee_profession_groups (  
    profession_group_id INTEGER PRIMARY KEY,
    profession_group_name TEXT NOT NULL UNIQUE
);

-- Employee professions table
CREATE TABLE IF NOT EXISTS employee_professions (  
    profession_id INTEGER PRIMARY KEY AUTOINCREMENT,
    profession_name TEXT NOT NULL UNIQUE,
    profession_group_id INTEGER NOT NULL,
    FOREIGN KEY (profession_group_id)
        REFERENCES employee_profession_groups(profession_group_id)
);

-- Employee table, for cleaning data
CREATE TABLE IF NOT EXISTS employees (
    employee_id INTEGER,
    full_name TEXT,
    profession_id INTEGER,
    profession_group_id INTEGER,
    gender TEXT,
    date_of_birth DATE,
    hire_date DATE,
    resignation_date DATE,
    FOREIGN KEY (profession_id)
        REFERENCES employee_professions(profession_id),
    FOREIGN KEY (profession_group_id)
        REFERENCES employee_profession_groups(profession_group_id)
);

-- Employee_raw table
CREATE TABLE IF NOT EXISTS employees_raw (
    employee_id INTEGER,
    full_name TEXT,
    profession_id INTEGER,
    profession_group_id INTEGER,
    gender TEXT,
    date_of_birth DATE,
    hire_date DATE,
    resignation_date DATE,
    FOREIGN KEY (profession_id)
        REFERENCES employee_professions(profession_id),
    FOREIGN KEY (profession_group_id)
        REFERENCES employee_profession_groups(profession_group_id)
);

