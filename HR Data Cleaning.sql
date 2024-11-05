CREATE DATABASE project2;

USE project2;

-- This is the file name that I use for cleaning data
-- Check data type on all column
SELECT * FROM hr2;

-- Change column name from ï»¿id to emp_id
ALTER TABLE hr2
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE hr2;

SELECT birthdate FROM hr2;

-- Tuning off safe mode in order to execute below query
SET sql_safe_updates = 0;

-- Transforming birthdate to a Standard Date Format
-- This code is intended to clean and standardize birthdate values. It checks for two specific date formats and converts each entry to MySQL’s standard format, %Y-%m-%d. Here’s how it works:

-- 1. Detect Date Format:
--    If the birthdate contains a forward slash (/), the code assumes it is in %m/%d/%Y format (e.g., 12/25/1990).
--    If the birthdate contains a dash (-), the code assumes it is in %m-%d-%y format (e.g., 12-25-90).
-- 2. Conversion Process:
--    Using STR_TO_DATE(), the code parses the date based on its format.
--    The parsed date is then converted to %Y-%m-%d, MySQL’s standard date format, using DATE_FORMAT().
-- 3. Setting Invalid Dates to NULL:
--    If the birthdate value doesn’t match either format, it is set to NULL, indicating an invalid or unrecognized date format.
--    This approach ensures that all birthdate values are in a consistent, standard format for easy querying and analysis. Adjustments can be made if you need a different format.
UPDATE hr2
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Change birthday data type
ALTER TABLE hr2
MODIFY COLUMN birthdate DATE;

-- Convert hire_date calues to date
UPDATE hr2
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Change hire_date column data type
ALTER TABLE hr2
MODIFY COLUMN hire_date DATE;

-- Change termdate calues to date and remove time
UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr2;

-- Set allow invalid date due to need to change termdate to date type
SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr2
MODIFY COLUMN termdate DATE;


SELECT * FROM hr2;

-- Calculate the age
ALTER TABLE hr2 ADD COLUMN age INT;

-- Add age column
UPDATE hr2
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT birthdate, age FROM hr2;

-- Edit data due to youngest is appear as '-46'
-- To update age <= 18 , 

SELECT
	min(age) AS youngest,
    max(age) AS oldest
FROM hr2;

SELECT count(*) FROM hr2  WHERE age < 18;

-- Check Termdates in the future
SELECT COUNT(*) FROM hr2 WHERE termdate > CURDATE();

SELECT COUNT(*)
FROM hr2
WHERE termdate = '0000-00-00';

SELECT location FROM hr2;

