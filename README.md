# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_p1`

This is a beginner project that I have followed to practice and demostrate my SQL skills and techniques to explore, clean and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. 

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
    total_sale FLOAT;
);
```

### 2. Data Exploration & Cleaning
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
```sql
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
	total_sale IS NULL ;


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
	total_sale IS NULL ;
```

- **Record Count**: Determine the total number of records in the dataset.
```sql
SELECT  COUNT(*) FROM retail_sales;
```

- **Customer Count**: Find out how many unique customers are in the dataset.
```sql
SELECT COUNT(DISTINCT(customer_id)) FROM retail_sales; 
```

- **Category Count**: Identify all unique product categories in the dataset.
```sql
SELECT DISTINCT(category) FROM retail_sales;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
AND (sale_date >= '2022-10-31' AND sale_date < '2022-11-30')
AND quantity >= 4;

-- To make it cleaner I would use a CTE 
WITH temp_table AS 
(
SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
AND (sale_date >= '2022-10-31' AND sale_date < '2022-11-30')
AND quantity >= 4
)

Select Count(*) FROM temp_table;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category, COUNT(*) AS total_orders,  SUM(total_sale) AS Total_sales FROM retail_sales
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND (AVG(age), 0) FROM retail_sales
WHERE category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale >1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT Category, Gender, COUNT(*) AS total_transaction  FROM retail_sales
GROUP BY Category, Gender
ORDER BY Category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
-- To manually check 
SELECT  EXTRACT(YEAR FROM sale_date) AS YEAR, 
EXTRACT(MONTH FROM sale_date) AS MONTH, 
AVG(total_sale) AS AVG_SALE FROM retail_sales,
GROUP BY 1,2
ORDER BY 1,2;

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
WHERE RANK_MONTH_FOR_EACH_YEAR = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id, SUM(total_sale) AS CUSTOMER_TOTAL_TRANSACTION FROM retail_sales
GROUP BY customer_id 
ORDER BY CUSTOMER_TOTAL_TRANSACTION DESC
LIMIT 5 ;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category, COUNT(DISTINCT(customer_id)) AS UNIQUE_Customers  FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
ORDER BY 2 DESC;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.


