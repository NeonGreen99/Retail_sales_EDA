-- Creating the database and the tables 
CREATE DATABASE sql_project_p1;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- Check the number of rows
SELECT * FROM retail_sales 
Limit 5

SELECT  COUNT(*) FROM retail_sales 



-- Check for null values in the dataset 
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	Sale_date IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL 
	OR 
	category IS NULL 
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL 
	OR
	total_sale IS NULL 


-- Due to the low quantity of the rows which contain null values, i would just delete them 
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	Sale_date IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL 
	OR 
	category IS NULL 
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL 
	OR
	total_sale IS NULL 

-- Exploring our dataset, we find that we have 155 unique customers
SELECT COUNT(DISTINCT(customer_id)) FROM retail_sales; 
-- we also know that we have 3 main categories,'Electronics, Clothing, and Beauty'
SELECT DISTINCT(category) FROM retail_sales;

-- The top 3 largest transacations are from customer 75,55,94  
SELECT * FROM retail_sales
ORDER BY total_sale DESC
LIMIT 3

-- Data Analyst
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:
-- A total of 11 records was found 

SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05'


-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
AND (sale_date >= '2022-10-31' AND sale_date < '2022-11-30')
AND quantity >= 4


WITH temp_table AS 
(
SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
AND (sale_date >= '2022-10-31' AND sale_date < '2022-11-30')
AND quantity >= 4
)

Select Count(*) FROM temp_table


-- Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, COUNT(*) AS total_orders,  SUM(total_sale) AS Total_sales FROM retail_sales
GROUP BY category 

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT ROUND (AVG(age), 0) FROM retail_sales
WHERE category = 'Beauty'

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retail_sales
WHERE total_sale >1000

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT Category, Gender, COUNT(*) AS total_transaction  FROM retail_sales
GROUP BY Category, Gender
ORDER BY Category

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
-- To manually check 
SELECT  EXTRACT(YEAR FROM sale_date) AS YEAR, 
EXTRACT(MONTH FROM sale_date) AS MONTH, 
AVG(total_sale) AS AVG_SALE FROM retail_sales,
GROUP BY 1,2
ORDER BY 1,2

-- To query using rank() and a CTE 
WITH Best_Sales_Month_Year AS 
(
SELECT  EXTRACT(YEAR FROM sale_date) AS YEAR, 
EXTRACT(MONTH FROM sale_date) AS MONTH, 
AVG(total_sale) AS AVG_SALE,
RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS RANK_MONTH_FOR_EACH_YEAR 
FROM retail_sales
GROUP BY 1,2
)

SELECT YEAR, MONTH, AVG_SALE, RANK_MONTH_FOR_EACH_YEAR FROM Best_Sales_Month_Year
WHERE RANK_MONTH_FOR_EACH_YEAR = 1

-- Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS CUSTOMER_TOTAL_TRANSACTION FROM retail_sales
GROUP BY customer_id 
ORDER BY CUSTOMER_TOTAL_TRANSACTION DESC
LIMIT 5 

-- Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT category, COUNT(DISTINCT(customer_id)) AS UNIQUE_Customers  FROM retail_sales
GROUP BY category

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH Hourly_SHIFT_Table AS 
(
SELECT *, 
	CASE
	WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'MORNING'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
	ELSE 
	'EVENING'
	END AS SHIFT
FROM retail_sales	
)

SELECT SHIFT, COUNT(*) AS TOTAL_ORDER FROM Hourly_SHIFT_Table
GROUP BY SHIFT
ORDER BY 2 DESC