--Basic SELECT statements
SELECT * FROM employees;
SELECT * FROM shops;
SELECT * FROM locations;
SELECT * FROM suppliers;



--QS.1 Get the employee id, first names and last names order by last name alphabetically
SELECT employee_id, last_name, first_name
FROM employees
ORDER BY last_name;

SELECT gender, COUNT(gender) FROM employees GROUP BY gender;

--QS.2 Get all male employees who work at Ancient Bean and earn more than 45k
SELECT * 
FROM employees
WHERE salary > 45000
AND coffeeshop_id = 3
AND gender = 'M';

--QS.3 Get top 10 highest paid employees
SELECT employee_id, last_name, first_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10;

--QS.4 Get total number of male and female employees working at Common Grounds
SELECT gender, COUNT(gender) AS no_of_employees
FROM employees
WHERE coffeeshop_id = 1
GROUP BY gender;

--QS.5 Get the difference in the gap between the highest and lowest paid male employee
--and the highest and lowest paid female employee
SELECT male.salary_diff - (SELECT MAX(salary) - MIN(salary) AS salary_diff FROM employees WHERE gender = 'F') pay_gap 
FROM (SELECT MAX(salary) - MIN(salary) AS salary_diff
FROM employees WHERE gender = 'M') male;


--QS.6 Get total number of employees hired in 2023 at each coffeeshop
SELECT EXTRACT(YEAR FROM hire_date) AS year_interv, e.coffeeshop_id AS coffeeshop_no, 
s.coffeeshop_name AS coffeeshop_name, COUNT(e.employee_id) AS total_no_of_employees
FROM employees e
JOIN shops s ON e.coffeeshop_id = s.coffeeshop_id
WHERE EXTRACT(YEAR FROM hire_date) = '2023'
GROUP BY year_interv, coffeeshop_no, coffeeshop_name
ORDER BY coffeeshop_no;

--QS.7 Get the number of employees by gender who joined 
--Urban Grind coffee shop in 2023
SELECT COUNT(e.employee_id) AS number_of_employees,
gender, EXTRACT(YEAR FROM hire_date) AS year_int
FROM employees e
JOIN shops s ON e.coffeeshop_id = s.coffeeshop_id
WHERE e.coffeeshop_id = 4 
GROUP BY gender, year_int
HAVING EXTRACT(YEAR FROM hire_date) = '2023'
ORDER BY year_int DESC;


--QS.8 Get the difference between average salaries paid to women and
--men working at Trembling Cup coffeeshop in New York each year for the last 5 years
SELECT EXTRACT(YEAR FROM hire_date) AS year_interv, male.avg_salary AS male_avg_salary, 
 female.avg_salary AS female_avg_salary, male.avg_salary - female.avg_salary AS avg_salary_diff
FROM (
	SELECT e.coffeeshop_id AS coffeeshop_no, EXTRACT(YEAR FROM hire_date) AS year_int, ROUND(AVG(salary),2) AS avg_salary 
    FROM employees e
    JOIN shops s ON e.coffeeshop_id = s.coffeeshop_id
    WHERE gender='M' AND e.coffeeshop_id = 5
    GROUP BY year_int, e.coffeeshop_id
    ORDER BY year_int
	) male
JOIN ( 
	SELECT e.coffeeshop_id AS coffeeshop_no, EXTRACT(YEAR FROM hire_date) AS year_int, ROUND(AVG(salary),2) AS avg_salary 
    FROM employees e
    JOIN shops s ON e.coffeeshop_id = s.coffeeshop_id
    WHERE gender='F' AND e.coffeeshop_id = 5 
    GROUP BY year_int, e.coffeeshop_id
    ORDER BY year_int
) female ON female.year_int = male.year_int
JOIN employees e ON EXTRACT(YEAR FROM hire_date) = female.year_int
JOIN shops s ON e.coffeeshop_id = s.coffeeshop_id
WHERE EXTRACT(YEAR FROM hire_date) BETWEEN '2019' AND '2023'
GROUP BY male.avg_salary, female.avg_salary, avg_salary_diff, year_interv
ORDER BY year_interv;

--QS.9 Get the number of employees in each pay category
SELECT a.pay_category, COUNT(*)
FROM(
	SELECT
	    employee_id,
	    first_name,
	    last_name,
	    salary,
	    CASE
	        WHEN salary < 20000 THEN 'low pay'
	        WHEN salary BETWEEN 20000 AND 50000 THEN 'medium pay'
	        WHEN salary > 50000 THEN 'high pay'
	        ELSE 'no pay'
	    END AS pay_category
	FROM employees
	ORDER BY salary DESC
	)a
GROUP BY a.pay_category;

--QS.10 Get top 10 female employees who make over 50k and work in a Los Angeles based coffee shop
SELECT employee_id, first_name, last_name, gender, salary
FROM employees
WHERE gender = 'F'
  AND salary > 50000
  AND coffeeshop_id IN
  (
	  SELECT coffeeshop_id
	  FROM shops
	  WHERE city_id IN
	     (
			 SELECT city_id
			 FROM locations
			 WHERE city = 'Los Angeles'
		 )  
  )
  ORDER BY salary DESC
  LIMIT 10;
	
	    
	



