--Create database
CREATE DATABASE sql_project1;

--Use databse
USE sql_project1;

-- **import data from your csv file**--

--Check the content in the table
SELECT * FROM retail_sales;

--viewing null values in the table
SELECT * FROM retail_sales 
WHERE transactions_id is null
     or 
	 sale_date is null
	 or 
	 sale_time is null
	 or
	 customer_id is null
	 or 
	 gender is null
	 or
	 age is null
	 or 
	 category is null
	 or 
	 price_per_unit is null
	 or 
	 cogs is null
	 or
	 total_sale is null;

--we have many null values in age attribute so let us find the average age 

SELECT Avg(age) AS average_age FROM retail_sales;


--managing null values by assigning the average value to the age attribute
update retail_sales
SET age = 41
WHERE age is null;

--deleting null values in the table
DELETE FROM retail_sales 
WHERE transactions_id is null
     or 
	 sale_date is null
	 or 
	 sale_time is null
	 or
	 customer_id is null
	 or 
	 gender is null
	 or
	 age is null
	 or 
	 category is null
	 or 
	 price_per_unit is null
	 or 
	 cogs is null
	 or
	 total_sale is null;


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

SELECT * FROM retail_sales
WHERE sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022.

SELECT * FROM retail_sales 
WHERE category='clothing'
     AND 
	  quantity >= 4
     AND
	  sale_date>='2022-11-01' AND   sale_date< '2022-12-01';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,sum(total_sale) AS net_sale, count(*) AS total_orders FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT avg(age) AS AVG_AGE FROM retail_sales
WHERE category = 'beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category,gender,count(*) AS total_transactions FROM retail_sales
GROUP BY category,gender
ORDER BY 1,2 DESC;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT year,
       month,
	   avg_sale
FROM
(
	SELECT
		  datepart(year,sale_date) as year,
		  datepart(month,sale_date) as month,
		  avg(total_sale) as avg_sale,
		  rank() over(partition by datepart(year,sale_date) order by avg(total_sale) desc ) as rank
	FROM retail_sales
	GROUP BY datepart(year,sale_date),datepart(month,sale_date)
) AS new
WHERE rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT TOP 5 customer_id,sum(total_sale) 
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category ,count(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sales
AS
(
	SELECT *,
		CASE WHEN datepart(hour,sale_time)<12 THEN 'Morning'
		WHEN datepart(hour,sale_time) between 12 and 16 THEN 'Afternoon'
		ELSE 'Evening'
		END AS shifts
	FROM retail_sales
)
SELECT shifts,count(*) as num_of_orders 
FROM hourly_sales
GROUP BY shifts; 


-- END OF THE PROJECT --