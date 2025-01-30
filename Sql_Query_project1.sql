-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

select * from retail_sales
limit 10


--    

select 
    count(*) 
from retail_sales;

-- Data Cleaning
select * from retail_sales
where transactions_id is null;
--
select * from retail_sales
where sale_date is null;
--
select * from retail_sales
where sale_time is null;
--
select * from retail_sales
where 
    transactions_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    gender is null
    or
    category is null
    or
    quantiy is null
    or
    cogs is null
    or
    total_sale is null;
    
-- 
Delete from retail_sales
where
    transactions_id is null
    or
    sale_date is null
    or 
    sale_time is null
    or
    gender is null
    or
    category is null
    or
    quantiy is null
    or
    cogs is null
    or
    total_sale is null;
    
-- Data Exploration

-- How many sales we have?
select count(*) as total_sale from retail_sales;

-- How many uniuque customers we have ?

select count(distinct customer_id) as total_sale from retail_sales;

-- How many unique category we have ?

select distinct (category) from retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equl to 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'?

--Start
select * from retail_sales
 where sale_date='2022-11-05';

--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
 --and the quantity sold is more than or equl to 4 in the month of Nov-2022 ?

select * from retail_sales
where category='Clothing' and quantiy>=4 
and to_char(sale_date,'YYYY-MM')='2022-11';

--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category ?

select category,
sum(total_sale) as total_sale,
count(*) as total_orders
from retail_sales
group by category;

--Q.4 Write a SQL query to find the average age of 
--customers who purchased items from the 'Beauty' category ?
select category,
avg(age) as average_age
from retail_sales
where category='Beauty'
group by category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales 
where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of 
--transactions (transactions_id) made by each gender in each category.

select gender,category,
count(transactions_id) as total_transactions
from retail_sales
group by gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month.
--Find out best selling month in each year

select * from 
( select 
    extract (month from sale_date) ,
    extract (year from sale_date) ,
    avg(total_sale) ,
    Rank() over (partition by extract (year from sale_date) order by avg(total_sale)desc) as rank
 from retail_sales
 group by 2,1) as NT 
where rank=1;

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,
sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category,
count(distinct customer_id) as total_customers
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders 
--(Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(select *,
       case 
	   when extract(hour from sale_time)<12 then 'Morning'
	   when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	   else 'Evening'
	   end as shift
from retail_sales)
select shift,
count(*) as total_orders
from hourly_sale
group by shift;

-- END OF PROJECT
