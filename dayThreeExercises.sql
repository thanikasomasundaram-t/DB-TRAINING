-- 1. Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy.
SELECT sum(SALARY) FROM 
COPYEMPLOYEES INNER JOIN DEPARTMENTS
ON COPYEMPLOYEES.DEPARTMENT_ID=DEPARTMENTS.DEPARTMENT_ID 
INNER JOIN LOCATIONS ON LOCATIONS.LOCATION_ID=DEPARTMENTS.LOCATION_ID WHERE CITY = 'Seattle';

SELECT * FROM COPYEMPLOYEES;

-- 2. Fetch all details of employees who has salary more than the avg salary by each department.
SELECT employee_id,  FROM COPYEMPLOYEES as base inner join (select department_id, avg(salary) as avg_salary from copyemployees group by department_id) as sub on sub.department_id = base.department_id having base.salary > sub.avg_salary;

-- 3. Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 7000 and less than 10000 
SELECT COUNT(EMPLOYEE_ID), LOCATIONS.CITY FROM COPYEMPLOYEES AS EMP_TABLE
INNER JOIN DEPARTMENTS ON EMP_TABLE.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
INNER JOIN LOCATIONS ON LOCATIONS.LOCATION_ID = DEPARTMENTS.LOCATION_ID
WHERE SALARY >= 7000 AND SALARY < 10000
GROUP BY LOCATIONS.CITY;

-- 4. Fetch max salary, min salary and avg salary by job and department. 
 -- Info:  grouped by department id and job id ordered by department id and max salary.
SELECT JOB_ID, max(SALARY), min(SALARY), avg(SALARY) FROM COPYEMPLOYEES GROUP BY DEPARTMENT_ID,JOB_ID ORDER BY DEPARTMENT_ID, max(SALARY);

-- 5. Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy  
SELECT sum(SALARY) FROM COPYEMPLOYEES
INNER JOIN DEPARTMENTS ON COPYEMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
INNER JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID
WHERE FIRST_NAME <> 'Nancy' AND COUNTRY_ID = 'US';

-- 6. Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department. 
SELECT  DISTINCT(COPYEMPLOYEES.EMPLOYEE_ID), max(SALARY)  FROM COPYEMPLOYEES
RIGHT JOIN JOB_HISTORY ON COPYEMPLOYEES.EMPLOYEE_ID = JOB_HISTORY.EMPLOYEE_ID
GROUP BY COPYEMPLOYEES.DEPARTMENT_ID, COPYEMPLOYEES.JOB_ID;

-- 7. Display the employee count in each department and also in the same result.  
-- Info: * the total employee count categorized as "Total"
-- the null department count categorized as "-" *;

SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) AS TOTAL FROM COPYEMPLOYEES GROUP BY DEPARTMENT_ID;

-- 8. Display the jobs held and the employee count. 
-- Hint: every employee is part of at least 1 job 
-- Hint: use the previous questions answer
-- Sample
-- JobsHeld EmpCount
-- 1 100
-- 2 4
SELECT FINAL.JOB_HELD, count(FINAL.EMPLOYEE_ID)
FROM (
    SELECT C1.EMPLOYEE_ID, count(EMPLOYEE_ID) AS JOB_HELD
    FROM (
        SELECT C.EMPLOYEE_ID, C.JOB_ID
        FROM COPYEMPLOYEES C
        UNION (SELECT JH.EMPLOYEE_ID, JH.JOB_ID FROM JOB_HISTORY JH)
        ORDER BY 1
    ) C1
    GROUP BY C1.EMPLOYEE_ID
    ) FINAL
GROUP BY FINAL.JOB_HELD;


-- 9. Display average salary by department and country. 
SELECT D.DEPARTMENT_ID, avg(SALARY), COUNTRY_NAME FROM COPYEMPLOYEES AS E
INNER JOIN DEPARTMENTS AS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN LOCATIONS AS L ON D.LOCATION_ID = L.LOCATION_ID
INNER JOIN COUNTRIES AS C ON L.COUNTRY_ID = C.COUNTRY_ID
GROUP BY D.DEPARTMENT_ID,COUNTRY_NAME;

-- 10. Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)
SELECT concat(C2.FIRST_NAME, ' ', C2.LAST_NAME) AS FULL_NAME, COUNT(C.EMPLOYEE_ID), COUNTRY_ID
FROM COPYEMPLOYEES AS C
INNER JOIN COPYEMPLOYEES AS C2 ON C.MANAGER_ID = C2.EMPLOYEE_ID
INNER JOIN DEPARTMENTS AS D ON C.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN LOCATIONS AS L ON L.LOCATION_ID = D.LOCATION_ID
GROUP BY FULL_NAME, COUNTRY_ID;



-- 11. Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.
-- Eg : 
-- DEPT ID 0-10000 10000-20000
-- 50          2               10
-- 60          6                5

SELECT DEPARTMENT_ID, count(CASE WHEN SALARY BETWEEN 0 AND 10000 THEN 1 END) AS "0-10000",
count(CASE WHEN SALARY BETWEEN 10000 AND 20000 THEN 1 END) AS "10000-20000",
count(CASE WHEN SALARY BETWEEN 20000 AND 30000 THEN 1 END) AS "20000-30000",
count(CASE WHEN SALARY > 30000 THEN 1 END) AS ">30000"
FROM COPYEMPLOYEES GROUP BY DEPARTMENT_ID;



-- 12. Display employee count by country and the avg salary 
-- Eg : 
-- Emp Count       Country        Avg Salary
-- 10                     Germany      34242.8


SELECT count(C.EMPLOYEE_ID) TOTAL_EMPLOYEES, L.COUNTRY_ID, avg(SALARY) AVERAGE_SALARY
FROM COPYEMPLOYEES C 
INNER JOIN DEPARTMENTS D ON C.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
GROUP BY COUNTRY_ID;

-- 13. Display region and the number off employees by department
-- Eg : 
-- Dept ID   America   Europe  Asia
-- 10            22               -            -
-- 40             -                 34         -
-- (Please put "-" instead of leaving it NULL or Empty);

SELECT replace('000', '0', '-');

SELECT C.DEPARTMENT_ID,
replace(CAST(count(CASE WHEN R.REGION_NAME = 'Americas' THEN 1 END)AS STRING), '0', '-') AS "AMERICAS",
replace(CAST(count(CASE WHEN R.REGION_NAME = 'Europe' THEN 1 END)AS STRING), '0', '-') AS "EUROPE",
replace(CAST(count(CASE WHEN R.REGION_NAME = 'Asia' THEN 1 END)AS STRING), '0', '-') AS "ASIA",
replace(CAST(count(CASE WHEN R.REGION_NAME = 'Middle East and Africa' THEN 1 END)AS STRING), '0', '-') AS "MIDDLE EAST AND AFFRICA"
FROM COPYEMPLOYEES C
INNER JOIN DEPARTMENTS D ON C.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN LOCATIONS L ON L.LOCATION_ID = D.LOCATION_ID
INNER JOIN COUNTRIES CDS ON CDS.COUNTRY_ID = L.COUNTRY_ID
INNER JOIN REGIONS R ON R.REGION_ID = CDS.REGION_ID
GROUP BY C.DEPARTMENT_ID;


-- 14. Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department ;
SELECT employee_id,iff(count(department_id)=0, 'Not yet joined/allocated to any department','Working in one or more department') AS "RESULT"
FROM employees 
GROUP BY employee_id,department_id;

-- 15. write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers 
SELECT C.FIRST_NAME AS E_FIRST_NAME, C.LAST_NAME AS E, C2.FIRST_NAME, C2.LAST_NAME
FROM COPYEMPLOYEES C
INNER JOIN COPYEMPLOYEES C2 ON C.MANAGER_ID = C2.EMPLOYEE_ID;

-- 16. write a SQL query to display the department name, city, and state province for each department.
SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME, L.CITY, L.STATE_PROVINCE
FROM DEPARTMENTS D
INNER JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID;


-- 17. write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't.
SELECT C.FIRST_NAME, C.LAST_NAME, D.DEPARTMENT_NAME, iff(C.DEPARTMENT_ID IS NULL, 'NOT BELONG', 'BELONG')
FROM COPYEMPLOYEES C
LEFT JOIN DEPARTMENTS D ON C.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- 18. The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department.  List the above along with the department id, department name 

SELECT C.DEPARTMENT_ID, D.DEPARTMENT_NAME, avg(C.SALARY), count(C.EMPLOYEE_ID)
FROM COPYEMPLOYEES C
INNER JOIN DEPARTMENTS D ON C.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY C.DEPARTMENT_ID, D.DEPARTMENT_NAME;

-- 19. Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.

SELECT * FROM COPYEMPLOYEES, JOBS;

-- 20. Write a query to display first_name, last_name, and email of employees who are from Europe and Asia 

SELECT C.FIRST_NAME, C.LAST_NAME, C.EMAIL
FROM COPYEMPLOYEES C
INNER JOIN DEPARTMENTS D ON C.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN LOCATIONS L ON L.LOCATION_ID = D.LOCATION_ID
INNER JOIN COUNTRIES CDS ON CDS.COUNTRY_ID = L.COUNTRY_ID
INNER JOIN REGIONS R ON R.REGION_ID = CDS.REGION_ID
WHERE R.REGION_NAME IN ('Europe', 'Asia');

-- 21. Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department. 

SELECT concat_ws(' ', C.FIRST_NAME, C.LAST_NAME) AS FULL_NAME, L.CITY
FROM COPYEMPLOYEES C
INNER JOIN DEPARTMENTS D ON C.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
WHERE L.CITY = 'Oxford' AND substr(C.LAST_NAME, -2, 1) = 'e'  AND D.DEPARTMENT_NAME NOT IN ('Finance', 'Shipping');

-- 22.Display the first name and phone number of employees who have less than 50 months of experience .
SELECT C.FIRST_NAME, C.PHONE_NUMBER
FROM COPYEMPLOYEES C WHERE datediff('month', current_date(), HIRE_DATE) < 50;


-- 23. Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023,  and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).
SELECT year(HIRE_DATE), TT.FIRST_NAME, TT.LAST_NAME, TT.HIRE_DATE, TT.SALARY FROM (
SELECT year(HIRE_DATE), C.FIRST_NAME, C.LAST_NAME, C.HIRE_DATE, C.SALARY,
RANK() OVER ( PARTITION BY year(HIRE_DATE) ORDER BY C.SALARY DESC) RANK_SALARY
FROM COPYEMPLOYEES C
) TT
WHERE RANK_SALARY = 1;





