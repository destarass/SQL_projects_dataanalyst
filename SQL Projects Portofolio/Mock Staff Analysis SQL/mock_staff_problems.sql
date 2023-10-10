show databases;

show tables;


Select * from staff;
Select * from company_divisions;
Select * from company_regions;

-- Basic statistic sql

SELECT * FROM company_divisions
LIMIT 5 ;

SELECT * FROM staff
LIMIT 5 ;

SELECT * FROM company_regions
LIMIT 5 ;

-- How many total employees in this company
SELECT COUNT(*) FROM staff;

-- What about gender distribution ?
SELECT gender, COUNT(*) AS total_employees
FROM staff
GROUP BY gender;

-- how many employees in each department
SELECT department, COUNT(*) AS total_employees
FROM staff
GROUP BY department
ORDER BY department ASC;

-- How many distinct departments are there, and what are their types? ?
SELECT DISTINCT(department)
FROM staff
ORDER BY department;


-- What is the highest and lowest salary of employees?
SELECT concat("Rp. ", format(MAX(salary), 0)) as The_Highest_Salary, concat("Rp. ", format(MIN(salary), 0)) as The_Lowest_Salary
FROM staff;


-- What about salary distribution by gender grou?
-- Data Interpretation: It seems like the average between male and female group is pretty close, 
-- with slighly higher average salary for female group

SELECT gender, concat("Rp. ", format(MIN(salary), 0)) as The_Lowest_Salary, concat("Rp. ", format(MAX(salary), 0)) as The_Highest_Salary, concat("Rp. ", format(AVG(salary), 0)) as The_AVERAGE_Salary
from staff
GROUP BY GENDER;


-- How much total salary companyis spending rach year
SELECT concat("Rp. ", format(SUM(salary), 0)) as Total_salary_eachyear
FROM staff;


-- want to know distrubution of min, max, average salary by department
-- Data interpretation: it seems like outdooes department has the highest average salary paid and Jewelery department with Lowest

SELECT
department,
concat("Rp. ", format(MIN(salary), 0)) as Min_Salary,
concat("Rp. ", format(MAX(salary), 0)) as Max_Salary,
concat("Rp. ", format(AVG(salary), 0)) as Average_Salary,
COUNT(*) as total_emoployees
FROM staff
GROUP BY department
ORDER BY 4 DESC;


-- how spread out those salary around the average salary in each department ?
-- Data Interpretatioon : Although average salary for Outdoors is highest
-- department, it seems like data points.are pretty close to average salary compared to other departments.

SELECT 
	department, 
	MIN(salary) As Min_Salary, 
	MAX(salary) AS Max_Salary, 
	AVG(salary) AS Average_Salary,
	VAR_POP(salary) AS Variance_Salary,
	STDDEV_POP(salary) AS StandardDev_Salary,
	COUNT(*) AS total_employees
FROM staff
GROUP BY department
ORDER BY 4 DESC;


/* which department has the highest salary spread out ? */
/* Data Interpretation: based on the findings, Health department has the highest spread out. So let's find out more */
SELECT 
	department, 
	MIN(salary) As Min_Salary, 
	MAX(salary) AS Max_Salary, 
	ROUND(AVG(salary),2) AS Average_Salary,
	ROUND(VAR_POP(salary),2) AS Variance_Salary,
	ROUND(STDDEV_POP(salary),2) AS StandardDev_Salary,
	COUNT(*) AS total_employees
FROM staff
GROUP BY department
ORDER BY 6 DESC;


-- See the employees who in health department
SELECT t2.last_name, t2.department, t2.salary as Salary_employee
FROM company_divisions t1 
INNER JOIN staff t2 using (department)
WHERE department = 'Health'
Order by Salary_employee desc;


SELECT t2.last_name, t2.department, CONCAT("Rp. ", FORMAT(t2.salary, 0)) AS Salary_employee
FROM company_divisions t1
INNER JOIN staff t2 USING (department)
WHERE department = 'Health'
ORDER BY t2.salary ASC;


-- we will make 3 buckets to see the salary earning status
-- for health department
CREATE VIEW health_dept_earning_status
AS
	SELECT
		CASE
			WHEN salary >= 100000 THEN 'high earner'
			WHEN salary >= 50000 AND salary <100000 THEN 'middle earner'
			ELSE 'low earner'
		END AS earning_status
	FROM staff
	WHERE department LIKE 'Health';



/* we can see that there are 24 high earners, 14 middle earners and 8 low earners */
SELECT earning_status, COUNT(*)
FROM health_dept_earning_status
GROUP BY 1;

/* Let's find out about Outdoors department salary */
SELECT department, CONCAT("Rp. ", FORMAT(salary, 0)) AS Salary_in_Rupiah
FROM staff
WHERE department LIKE 'Outdoors'
ORDER BY salary ASC;




CREATE VIEW outdoors_dept_earning_status
AS
	SELECT
		CASE
			WHEN salary >= 100000 THEN 'high earner'
			WHEN salary >= 50000 AND salary <100000 THEN 'middle earner'
			ELSE 'low earner'
		END AS earning_status
	FROM staff
	WHERE department LIKE 'Outdoors';


SELECT earning_status, COUNT(*)
FROM outdoors_dept_earning_status
GROUP BY 1;

-- drop the unused views
DROP VIEW health_dept_earning_status;
DROP VIEW outdoors_dept_earning_status;


/* What are the deparment start with B */
SELECT
	DISTINCT(department)
FROM staff
WHERE department LIKE 'B%';

/**************** Data Wrangling / Data Munging *************/

SELECT DISTINCT(department)
FROM staff
ORDER BY 1;

/********* Reformatting Characters Data *********/
SELECT DISTINCT(UPPER(department))
FROM staff
ORDER BY 1;

SELECT DISTINCT(LOWER(department))
FROM staff
ORDER BY 1;

/*** Concatetation ***/
SELECT last_name, job_title || '-' || department as title_with_department
from staff;

/*** Trim ***/

SELECT TRIM('    data science rocks !!!!    ');

SELECT LENGTH(TRIM('    data science rocks !!!!    '));

/* How many employees with Assistant roles */

SELECT job_title
FROM staff;

SELECT COUNT(*)
FROM staff
WHERE job_title like '%Assistant%';

/* let's check which roles are assistant role or not */

SELECT DISTINCT(job_title), job_title LIKE '%Assistant%' is_assistant_role
FROM staff
ORDER BY 1;

/********* Extracting Strings from Characters *********/
-- SUBSTRING('string' FROM position FOR how_many)

---------------------- SubString words ----------------------------------------------------

SELECT 'abcsdefghijk' as test_string;

SELECT SUBSTRING('abcsdefghijk' from 6 for 3) as sub_string;


SELECT SUBSTRING('abcsdefghijk' from 5) as sub_string;

/* We want to extract job category from the assistant position which starts with word Assisant */
SELECT 
	SUBSTRING(job_title FROM LENGTH('Assistant')+1) AS job_category,
	job_title
FROM staff
WHERE job_title LIKE 'Assistant%';


---------------------- Replacing words ----------------------------------------------------

/********* Filtering with Regualar Expressions *********/
-- SIMILAR TO

/* We want to know job title with Assistant with Level 3 and 4 */
-- we will put the desired words into group
-- Pipe character | is for OR condition 
SELECT job_title
FROM staff
WHERE job_title REGEXP 'Assistant(III|IV)';



/* now we want to know job title with Assistant, started with roman numerial I, follwed by 1 character
it can be II,IV, etc.. as long as it starts with character I 

underscore _ : for one character */

SELECT DISTINCT job_title
FROM staff
WHERE job_title REGEXP 'Assistant I.';


-- filtering, join and aggregration

-- we want to know person's salary comparing to his/her department average salary

SELECT
	s.last_name, s.salary, s.department, 
	( SELECT ROUND(AVG(salary),2)
	FROM staff s2
	WHERE s2.department = s.department) AS department_average_salary
FROM staff s ;


--menampilkan komponen dari table staff
SELECT * from staff;
--menampilkan komponen dari table staff


SELECT
    s.last_name,
    s.salary,
    s.department,
    ROUND(avg_salary, 2) AS department_average_salary
FROM staff s
INNER JOIN (
    SELECT
        department,
        AVG(salary) AS avg_salary
    FROM staff 
    GROUP BY department
) s2 ON s.department = s2.department;

SELECT department, ROUND(AVG(salary),2)
FROM staff
GROUP BY department;

-- Tentukan jumlah dari jobtitle 
SELECT job_title, count(job_title)
FROM staff
GROUP BY job_title;



-- we want to know person's salary comparing to his/her jobtitle average salary
-- solution-1
SELECT s.last_name, s.email, s.job_title,
	(SELECT ROUND(AVG(salary),2)
	FROM staff s2
	WHERE s2.job_title = s.job_title) as jobtitle_average_salary
FROM staff s ;


-- solution-2
SELECT s.last_name, s.salary, s.job_title, avg_jobtitle
FROM staff s INNER JOIN (
	SELECT job_title, ROUND(AVG(salary),2) as avg_jobtitle
	FROM staff 
	GROUP BY job_title
) s2 using (job_title);

-- how many people ar earning above/below the average salary of his/her department?
--Berapa banyak orang yang mendapatkan gaji di atas/di bawah rata-rata gaji departemennya?
-- solusi 1
CREATE VIEW vw_salary_comparison_by_department
AS 
	SELECT
	s.department, 
	( s.salary > (SELECT ROUND(AVG(s2.salary),2)
					FROM staff s2
					WHERE s2.department = s.department)
	) AS is_higher_than_dept_avg_salary
	FROM staff s
	ORDER BY s.department;

SELECT * FROM vw_salary_comparison_by_department;

-- solusi 2
CREATE VIEW vw2_salary_comparison_by_department AS
SELECT
    s.department,
    CASE
        WHEN s.salary > avg_salary.avg_salary THEN 1
        ELSE 0
    END AS is_higher_than_dept_avg_salary
FROM staff s
JOIN (
    SELECT
        department,
        ROUND(AVG(salary), 2) AS avg_salary
    FROM staff
    GROUP BY department
) AS avg_salary
ON s.department = avg_salary.department
ORDER BY s.department;

SELECT * FROM vw2_salary_comparison_by_department;

SELECT department, is_higher_than_dept_avg_salary, COUNT(*) AS total_employees
FROM vw_salary_comparison_by_department
GROUP BY department, is_higher_than_dept_avg_salary;


/* Assume that people who earn at latest 100,000 salary is Executive.
We want to know the average salary for executives for each department.

Data Interpretation: it seem like Sports department has the highest average salary for
Executives where Movie department has the lowest.*/

--solution 1
SELECT department, ROUND(AVG(salary),2) as Average_Salary
FROM staff
WHERE salary >= 100000
GROUP BY department
ORDER BY Average_Salary DESC;

--solution 2
SELECT department, ROUND(AVG(salary), 2) as Average_Salary
FROM (
  SELECT department, salary
  FROM staff
  WHERE salary >= 100000
) filtered_staff
GROUP BY department
ORDER BY Average_Salary DESC;


--solution 3
SELECT 
  department, 
  CONCAT('Rp ', FORMAT(AVG(salary), 0)) as Average_Salary
FROM staff
WHERE salary >= 100000
GROUP BY department
ORDER BY Average_Salary DESC;

/* who earn the most in the company? 
It seems like Stanley Grocery earns the most.
*/

SELECT MAX(salary)
from staff;

SELECT last_name, department, salary
from staff
WHERE salary = (
	SELECT MAX(salary)
from staff
);

SELECT s1.last_name, s1.department, s1.salary
FROM staff s1
JOIN (
  SELECT MAX(salary) AS max_salary
  FROM staff
) s2 ON s1.salary = s2.max_salary;


/* who earn the most in his/her own department */
SELECT s.department, s.last_name, s.salary
FROM staff s
WHERE s.salary = (
	SELECT MAX(s2.salary)
	FROM staff s2
	WHERE s2.department = s.department
)
ORDER BY 1;





 SELECT department, MAX(salary) AS max_salary
  FROM staff
  GROUP BY department;



----------------------------------------------------------------------------------------------

SELECT * FROM company_divisions;

/* full details info of employees with company division
Based on the results, we see that there are only 953 rows returns. We know that there are 1000 staffs.
*/


SELECT s.last_name, s.department, cd.company_division
FROM staff s
JOIN company_divisions cd
	ON cd.department = s.department;




SELECT s.last_name, s.department, cd.company_division
FROM staff s
LEFT JOIN company_divisions cd
	ON cd.department = s.department
WHERE company_division IS NULL;



/***** Grouping Sets *****************/
-- Grouping Sets : allows to have more than one grouping in the results table
-- there is no need to seperately use group by per query statement
CREATE VIEW vw_staff_div_reg AS
	SELECT s.*, cd.company_division, cr.company_regions
	FROM staff s
	LEFT JOIN company_divisions cd ON s.department = cd.department
	LEFT JOIN company_regions cr ON s.region_id = cr.region_id;


SELECT COUNT(*)
FROM vw_staff_div_reg;

SELECT *
FROM vw_staff_div_reg;

SELECT company_regions, COUNT(*) AS total_employees
FROM vw_staff_div_reg
GROUP BY 1
ORDER BY 1;


SELECT company_regions, company_division, COUNT(*) AS total_employees
FROM vw_staff_div_reg
GROUP BY 
	GROUPING SETS(company_regions, company_division)
ORDER BY 1,2;
/***** Grouping Sets *****************/
-- Grouping Sets : allows to have more than one grouping in the results table
-- there is no need to seperately use group by per query statement

-- 2 groupings
SELECT company_regions, company_division, COUNT(*) AS total_employees
FROM vw_staff_div_reg
GROUP BY 
	GROUPING SETS(company_regions, company_division)
ORDER BY 1,2;


------------ FETCH FIRST ----------
/* 
Fetch First works different from Limit.

For Fetch First, Order By Clause works first for sorting. Then Fetch First selets the rows.

For Limit, Limit acutally limits the rows and then performs the operations.

*/


/* What are the top salary earners ? */
SELECT last_name, salary
FROM staff
ORDER BY salary DESC
FETCH FIRST	10 ROWS ONLY;

SELECT
	company_division,
	COUNT(*) AS total_employees
FROM vw_staff_div_reg_country
GROUP BY company_division
ORDER BY company_division
LIMIT 5;



/******** Windows Functions and Ordered Data ************/

-- allows us to make sql statements about rows that are related to current row during processing.
-- somewhat similar to Sub Query.


--------------------- OVER (PARTITION BY) ---------------------------

/* employee salary vs average salary of his/her department */

SELECT 
	department, 
	last_name, 
	salary,
	AVG(salary) OVER (PARTITION BY department)
FROM staff;


/* employee salary vs max salary of his/her department */
SELECT 
	department, 
	last_name, 
	salary,
	MAX(salary) OVER (PARTITION BY department)
FROM staff;



---------------------  RANK ()  ---------------------------

-- give the rank by salary decending oder withint the specific department group.
-- the ranking 1, 2, 3 will restart when it reaches to another unique group.
-- works same as Row_Number Function

SELECT
	department,
	last_name,
	salary,
	RANK() OVER (PARTITION BY department ORDER BY salary DESC)
FROM staff;

---------------------  ROW_NUBMER ()  ---------------------------
-- same as above
SELECT
	department,
	last_name,
	salary,
	ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC)
FROM staff;	


--------------------- LAG() function ---------------------------

--MEMBANDINGAN SAMA VALUE SEBELUMNYA
-- to reference rows relative to the currently processed rows.
-- LAG() allows us to compare condition with the previous row of current row.

/* we want to know person's salary and next lower salary in that department */
/* that is an additional column LAG. First row has no value because there is no previous value to compare.
So it continues to next row and lag value of that second row will be the value of previous row, etc.
It will restart again when we reache to another department.
*/
SELECT 
	department,
	last_name,
	salary,
	LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC)
FROM staff;


--------------------- LEAD() function ---------------------------
--MEMBANDINGAN SAMA VALUE SETELAHNYA
-- opposite of LAG()
-- LEAD() allows us to compare condition with the next row of current row.
-- now the last line of that department's LEAD value is empty because there is no next row value to compare.
SELECT 
	department,
	last_name,
	salary,
	LEAD(salary) OVER(PARTITION BY department ORDER BY salary DESC)
FROM staff;


--------------------- NTILE(bins number) function ---------------------------
-- allows to create bins/ bucket

/* there are bins (1-10) assigned each employees based on the decending salary of specific department
and bin number restart for another department agian */
SELECT 
	department,
	last_name,
	salary,
	NTILE(3) OVER(PARTITION BY department ORDER BY salary DESC)
FROM staff;
