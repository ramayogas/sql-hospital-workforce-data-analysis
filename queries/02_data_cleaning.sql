-- 1. ADD COLUMNS FOR CLEAN_NAME AND TITLE
ALTER TABLE employees ADD COLUMN clean_name TEXT;
ALTER TABLE employees ADD COLUMN title TEXT;

-- 2. EXTRACT TITLE FROM FULL_NAME
UPDATE employees
SET title = TRIM(
    CASE
        -- AFTER COMMA + DOT
        WHEN INSTR(SUBSTR(full_name, INSTR(full_name, ',') + 1), '.') > 0
        THEN TRIM(SUBSTR(full_name, INSTR(full_name, ',') + 1))
        -- BEFORE COMMA + DOT
        WHEN INSTR(SUBSTR(full_name, 1, INSTR(full_name, ',') -1 ), '.') > 0
        THEN TRIM(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1))
        
        -- CHECK UPPERCASE BEFORE COMMA WITHOUT DOT
        WHEN TRIM(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1)) = UPPER(TRIM(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1)))
        THEN TRIM(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1))
        -- CHECK UPPERCASE AFTER COMMA WITHOUT DOT
        WHEN TRIM(SUBSTR(full_name, INSTR(full_name, ',') + 1)) = UPPER(TRIM(SUBSTR(full_name, INSTR(full_name, ',') + 1)))
        THEN TRIM(SUBSTR(full_name, INSTR(full_name, ',') + 1))
        
        -- BEFORE COMMA WITHOUT DOT 
        WHEN INSTR(full_name, ',') > 0 AND LENGTH(
        TRIM(SUBSTR(full_name, INSTR(full_name, ',') + 1))) > LENGTH(TRIM(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1)))
        THEN TRIM(SUBSTR(full_name, 1,INSTR(full_name, ',') - 1))
        -- AFTER COMMA WITHOUT DOT
        WHEN INSTR(full_name, ',') > 0 AND LENGTH(
        TRIM(SUBSTR(full_name, INSTR(full_name, ',') + 1))) < LENGTH(TRIM(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1)))
        THEN TRIM(SUBSTR(full_name, INSTR(full_name, ',') + 1))
        
        ELSE
           NULL
    END
) 

-- 3. EXTRACT NAME FROM FULL_NAME
UPDATE employees
SET clean_name = TRIM(
    CASE
        -- NO COMMA
        WHEN INSTR(full_name, ',') = 0
        THEN full_name

        -- AFTER COMMA
        WHEN INSTR(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1) , '.') > 0 
        THEN TRIM(SUBSTR(full_name, INSTR(full_name, ',') + 1))

        -- BEFORE COMMA
        WHEN INSTR(SUBSTR(full_name, INSTR(full_name, ',') + 1), '.') > 0
        THEN TRIM(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1))
        
        -- UPPERCASE BEFORE COMMA
        WHEN SUBSTR(full_name, INSTR(full_name, ',') + 1) = UPPER(SUBSTR(full_name, INSTR(full_name, ',') + 1))
        THEN TRIM(SUBSTR(full_name,1, INSTR(full_name, ',') - 1))

        -- UPPERCASE AFTER COMMA
        WHEN SUBSTR(full_name, 1, INSTR(full_name, ',') - 1) = UPPER(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1))
        THEN TRIM(SUBSTR(full_name, INSTR(full_name, ',') + 1))

        -- LENGTH BEFORE COMMA > LENGTH AFTER COMMA
        WHEN LENGTH(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1)) > LENGTH(SUBSTR(full_name, INSTR(full_name, ',') + 1))
        THEN TRIM(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1))

        -- LENGTH AFTER COMMA > LENGTH BEFORE COMMA
        WHEN LENGTH(SUBSTR(full_name, INSTR(full_name, ',') + 1)) > LENGTH(SUBSTR(full_name, 1, INSTR(full_name, ',') - 1))
        THEN TRIM(SUBSTR(full_name, INSTR(full_name, ',') + 1))

        ELSE
           NULL

    END
)

-- 4. SPLIT PREFIX AND SUFFIX TITLES
ALTER TABLE employees
ADD COLUMN prefix_title TEXT;

ALTER TABLE employees
ADD COLUMN suffix_title TEXT;

-- 5. UPDATE PREFIX TITLES
UPDATE employees
SET prefix_title = (
        (CASE WHEN title GLOB '*Prof.*' THEN 'Prof. ' ELSE '' END)||
        (CASE WHEN title GLOB '*Dr.*' THEN 'Dr. ' ELSE '' END)||
        (CASE WHEN title GLOB '*Ir.*' THEN 'Ir. ' ELSE '' END)||
        (CASE WHEN title GLOB '*drg.*' THEN 'drg. ' ELSE '' END)||
        (CASE WHEN title GLOB '*dr.*' THEN 'dr. '  ELSE '' END)
)

-- 6. UPDATE SUFFIX TITLE BY REMOVING PREFIX TITLES
UPDATE employees
SET suffix_title = (
                    trim(
                        replace(
                          replace(
                            replace(
                              replace(
                                replace(title, 'drg.', ''),
                              'dr.', ''),
                            'Dr.', ''),
                          'Ir.', ''),
                        'Prof.', '')
                      ) 
                    )
-- 6.1 VALIDATING DATA
SELECT full_name, clean_name, title, prefix_title, suffix_title FROM employees
WHERE title <> '' AND profession_id = 1412

-- 7. CREATE PROPER_NAME BY COMBINING PREFIX TITLE, CLEAN_NAME, AND SUFFIX TITLE
ALTER TABLE employees
ADD COLUMN proper_name TEXT;

UPDATE employees
SET proper_name = TRIM(
  CASE
    WHEN suffix_title <> '' THEN prefix_title || ' ' || clean_name || ', ' || suffix_title
    ELSE prefix_title || ' ' || clean_name 
  END
)

-- 8. UPDATE DATE OF BIRTH TO ISO FORMAT (YYYY-MM-DD)
UPDATE employees
SET date_of_birth =
    SUBSTR(date_of_birth, 7, 4) || '-' ||
    SUBSTR(date_of_birth, 4, 2) || '-' ||
    SUBSTR(date_of_birth, 1, 2)

-- 9. ADDING AGE COLUMN
ALTER TABLE employees 
ADD COLUMN age INTEGER

UPDATE employees 
SET age = CAST(strftime('%Y', 'now') AS DATE) - strftime ('%Y', date_of_birth) - (strftime('%m-%d', 'now') < (strftime('%m-%d', date_of_birth)))
