-- 1. Write a SQL query to remove the details of an employee whose first name ends in ‘even’ 
DELETE FROM EMPLOYEES WHERE substr(lower(EMPLOYEES.FIRST_NAME), -4, 4) = 'even';
-- ANOTHER APPROACH
-- DELETE FROM EMPLOYEES WHERE lower(FIRST_NAME) LIKE '%even';

-- 2. Write a query in SQL to show the three minimum values of the salary from the table.
SELECT * FROM EMPLOYEES ORDER BY SALARY LIMIT 3;

-- 3. Write a SQL query to remove the employees table from the database 
DROP TABLE EMPLOYEES;

-- 4. Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table 
CREATE TABLE COPYEMPLOYEES AS SELECT * FROM EMPLOYEES;
SELECT * FROM COPYEMPLOYEES;



-- 5. Write a SQL query to remove the column Age from the table 
ALTER TABLE COPYEMPLOYEES ADD COLUMN AGE INT;
SELECT * FROM COPYEMPLOYEES;
ALTER TABLE COPYEMPLOYEES DROP COLUMN AGE;
SELECT * FROM COPYEMPLOYEES;

-- 6. Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000 
SELECT CONCAT(FIRST_NAME, space(1), LAST_NAME) AS FULL_NAME, EMAIL, year(HIRE_DATE) AS HIRE_YEAR FROM COPYEMPLOYEES WHERE year(HIRE_DATE) < 2000;

-- 7. Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999 
SELECT EMPLOYEE_ID, JOB_ID, HIRE_DATE FROM COPYEMPLOYEES WHERE year(HIRE_DATE) BETWEEN 1990 AND 1999;

-- 8. Find the first occurrence of the letter 'A' in each employees Email ID. Return the employee_id, email id and the letter position 
SELECT EMPLOYEE_ID, EMAIL, charindex('A', EMAIL), CHE AS LETTER_POSITION FROM COPYEMPLOYEES WHERE LETTER_POSITION <> 0;
 

-- 9. Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12
SELECT EMPLOYEE_ID, concat_ws(' ', FIRST_NAME, LAST_NAME) AS FULL_NAME, EMAIL, (length(FULL_NAME)-1) AS CHARACTER_LENGTH FROM COPYEMPLOYEES WHERE (length(FULL_NAME)-1) < 12;


-- 10. Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID. Return the employee_id, and their corresponding UNQ_ID; 
SELECT EMPLOYEE_ID, concat_ws('-', FIRST_NAME, LAST_NAME, EMAIL) AS UNIQUE_ID FROM COPYEMPLOYEES;

-- 11. Write a SQL query to update the size of email column to 30 
DESCRIBE TABLE COPYEMPLOYEES;
ALTER TABLE COPYEMPLOYEES MODIFY COLUMN EMAIL VARCHAR(30);
DESCRIBE TABLE COPYEMPLOYEES;

-- 12. Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)  
-- Info : this mean you need to separate phone into 2 parts 
-- eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column 
SELECT FIRST_NAME, EMAIL, PHONE_NUMBER, left(PHONE_NUMBER, charindex(split_part(PHONE_NUMBER, '.', -1), PHONE_NUMBER, 1)-2) AS PHONE, split_part(PHONE_NUMBER, '.', -1) AS EXTENSION FROM COPYEMPLOYEES;

-- 13. Write a SQL query to find the employee with second and third maximum salary. 
SELECT * FROM COPYEMPLOYEES ORDER BY SALARY LIMIT 2 OFFSET 1;

-- 14. Fetch all details of top 3 highly paid employees who are in department Shipping and IT
-- SELECT * FROM COPYEMPLOYEES WHERE DEPARTMENT_ID=50 OR DEPARTMENT_ID = 60 ORDER BY SALARY DESC LIMIT 3;

SELECT *
FROM COPYEMPLOYEES C
INNER JOIN DEPARTMENTS D ON C.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.DEPARTMENT_NAME IN ('Shipping', 'IT');


-- 15. Display employee id and the positions(jobs) held by that employee (including the current position) 
SELECT COPYEMPLOYEES.EMPLOYEE_ID, COPYEMPLOYEES.JOB_ID, JOB_TITLE FROM JOBS, COPYEMPLOYEES WHERE COPYEMPLOYEES.JOB_ID = JOBS.JOB_ID
UNION
SELECT EMPLOYEE_ID, JOB_HISTORY.JOB_ID, JOB_TITLE FROM JOB_HISTORY, JOBS WHERE JOBS.JOB_ID = JOB_HISTORY.JOB_ID ORDER BY EMPLOYEE_ID;

-- 16. Display Employee first name and date joined as WeekDay, Month Day, Year
-- Eg : 
-- Emp ID      Date Joined
-- Monday, June 21st, 1999 

SELECT FIRST_NAME, concat(TO_CHAR((HIRE_DATE),'MMMM'), ', ', monthname(HIRE_DATE),' ', day(HIRE_DATE), year(HIRE_DATE)) AS DATE_JOINED FROM COPYEMPLOYEES;

-- 17. The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 .   The job position might be removed based on market trends (so, save the changes) .   - Later, update the maximum salary to 40,000 .  - Save the entries as well.
-- -  Now, revert back the changes to the initial state, where the salary was 30,000
begin transaction;
ALTER SESSION SET AUTOCOMMIT = FALSE;
INSERT INTO JOBS VALUES('DT_ENGG', 'DATA ENGINEER', 12000, 30000);
UPDATE JOBS SET MAX_SALARY = 40000 WHERE JOB_ID = 'DT_ENGG';
-- savepoint a;
UPDATE JOBS SET MAX_SALARY = 50000 WHERE JOB_ID = 'DT_ENGG';
DELETE FROM JOBS WHERE JOB_ID = 'DT_ENGG';
ROLLBACK;

-- 18. Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals 

SELECT round(avg(SALARY), 3) FROM COPYEMPLOYEES WHERE HIRE_DATE BETWEEN '1996-01-08' AND '1999-12-31';

-- 19. Display  Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
-- A. Display all the regions
-- B. Display all the unique regions
SELECT REGION_NAME FROM REGIONS
UNION ALL SELECT 'Australia'
UNION ALL SELECT 'Antarctica'
UNION ALL SELECT 'Europe';


SELECT REGION_NAME FROM REGIONS
UNION SELECT 'Australia'
UNION SELECT 'Antarctica'
UNION SELECT 'Europe';




