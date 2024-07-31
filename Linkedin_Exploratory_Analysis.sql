-- Cleaned raw data in Excel to prepare it for analysis
-- Exploratory Analyses


-- Check if Data imported and get an understanding of the Contents of the data
SELECT * FROM linkedinjobs_africa_cleaned;



-- Change data format of date column from string to date 
-- first Run select statement to check the conversion is correct
SELECT posted_date, 
STR_TO_DATE(posted_date, '%m/%d/%Y')
from linkedinjobs_africa_cleaned;

-- Update the table 
update linkedinjobs_africa_cleaned
set posted_date = STR_TO_DATE(posted_date, '%m/%d/%Y');


select posted_date from linkedinjobs_africa_cleaned;

-- Alter the data from string to date
alter table linkedinjobs_africa_cleaned
modify column posted_date date;


-- Show all data analyst jobs that are internships or entry level
SELECT title, company, criteria, employment_type FROM linkedinjobs_africa_cleaned
WHERE criteria LIKE '%internship%' 
OR criteria LIKE '%entry level%'
ORDER BY criteria DESC;

-- Count how many entry level jobs there are posted in south africa 
SELECT * FROM linkedinjobs_africa_cleaned
WHERE criteria LIKE '%internship%' 
OR criteria LIKE '%entry level%'
AND location LIKE '%south africa%'
ORDER BY criteria DESC;


-- Find the total Amount of Entry level and Internship Job vacancies in South africa
SELECT count(company) FROM linkedinjobs_africa_cleaned
WHERE criteria LIKE '%entry level%' 
OR criteria LIKE '%internship%'
AND location LIKE '%south africa%';

-- Find the total amount of entry level jobs, internship jobs and associate level jobs available in south africa
SELECT 
    COUNT(CASE WHEN criteria LIKE '%entry level%' THEN 1 END) AS entry_level_count,
    COUNT(CASE WHEN criteria LIKE '%internship%' THEN 1 END) AS internship_count,
    COUNT(CASE WHEN criteria LIKE '%associate%' THEN 1 END) AS associate_count
FROM linkedinjobs_africa_cleaned
WHERE location LIKE '%south africa%';

-- Count and show jobs that are entry level and available at home location(jhb and dbn)
SELECT 
    company, title, location, COUNT(CASE WHEN criteria LIKE '%entry level%' THEN 1 END) AS entry_level_count,
    COUNT(CASE WHEN criteria LIKE '%internship%' THEN 1 END) AS internship_count
    FROM linkedinjobs_africa_cleaned
    WHERE location LIKE '%johannesburg%'
    OR location LIKE '%durban%'
    GROUP BY company, title, location;
    
    
 -- Query to find out the percentage between remote work and onsite work
 -- Shows use of CTe to perform task efficiently 
WITH total_count AS 
(
    SELECT COUNT(*) AS total
    FROM linkedinjobs_africa_cleaned
    WHERE onsite_remote LIKE '%onsite%' OR onsite_remote LIKE '%remote%'
)
SELECT 
ROUND(100 * SUM(CASE WHEN onsite_remote LIKE '%onsite%' THEN 1 ELSE 0 END) / COUNT(*),2) AS Onsite_percentage,
ROUND(100 * SUM(CASE WHEN onsite_remote LIKE '%remote%' THEN 1 ELSE 0 END) / COUNT(*),2) AS remote_percentage
FROM linkedinjobs_africa_cleaned, total_count
WHERE onsite_remote LIKE '%onsite%' OR onsite_remote LIKE '%remote%';


-- check data for western cape 
select * from linkedinjobs_africa_cleaned where location like '%western cape%';



-- Compare the difference between western cape and jhb, 
-- By showing a percentage of the jobs available in jhb vs western cape that entry level and internships

WITH total_count AS -- Use cte to first calculate total jobs that are posted in jhb and capetown that are entry level and internships
(
    SELECT COUNT(*) AS total
    FROM linkedinjobs_africa_cleaned
    WHERE location LIKE '%johannesburg%' OR location LIKE '%western cape%'
    AND criteria LIKE '%entry level%' 
	OR criteria LIKE '%internship%'
)
SELECT 
ROUND(100 * SUM(CASE WHEN location LIKE '%johannesburg%' THEN 1 ELSE 0 END) / COUNT(*),2) AS Johannesburg,
ROUND(100 * SUM(CASE WHEN location LIKE '%western cape%' THEN 1 ELSE 0 END) / COUNT(*),2) AS Western_Cape
FROM linkedinjobs_africa_cleaned, total_count
WHERE location LIKE '%johannesburg%' OR location LIKE '%western cape%';


