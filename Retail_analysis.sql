-- SQL Retail Sales Analysis - P1
DROP TABLE IF EXISTS retail_sales
create table retail_sales
(
       transactions_id	INT PRIMARY KEY,
	   sale_date DATE,
	   sale_time TIME,
	   customer_id	INT,
	   gender VARCHAR(15),
	   age	INT,
	   category VARCHAR(15),
	   quantiy INT,
	   price_per_unit FLOAT,
	   cogs FLOAT,
	   total_sale FLOAT
)
select * from retail_sales limit 10;
select count(*) from retail_sales ;


-- Data Cleaning

select * from retail_sales 
where
transactions_id is NULL or
sale_date is NULL or
sale_time is NULL or
customer_id is NULL or
gender is NULL or
age is NULL or
category is NULL or
quantity is NULL or
price_per_unit is NULL or
cogs is NULL or
total_sale is NULL;

-- Rename column
ALTER TABLE retail_sales RENAME COLUMN quantiy TO quantity;


-- replacing missing values with median values 
update retail_sales
set age = (
select
percentile_cont(0.5) within group (order by age) 
from retail_sales
where age is not null
)
where age is null;

-- deleteing null values
delete from retail_sales 
where
transactions_id is NULL or
sale_date is NULL or
sale_time is NULL or
customer_id is NULL or
gender is NULL or
age is NULL or
category is NULL or
quantity is NULL or
price_per_unit is NULL or
cogs is NULL or
total_sale is NULL;

-- Data Exploration
select * from retail_sales limit 10;
-- How many saleswe have?
select count(*) as tol_sales from retail_sales;

-- how many unique customers?
select count(Distinct customer_id) as tol_customers from retail_sales;

-- distinct categories?
select distinct category from retail_sales;


-- Data analysis, business problems and solution
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
-- the quantity sold is more than 10 in the month of Nov-2022 
select * from retail_sales
where
category = 'Clothing' and
quantity >= 4 and
TO_CHAR(sale_date,'YYYY-MM') = '2022-11';



--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as tol_sale_amt , count(*) as tol_sales 
from retail_sales
group by category;



-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select Round(avg(age),2) as avg_age
from retail_sales where category = 'Beauty';



-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id)
-- made by each gender in each category.
select category,gender,count(transactions_id) as tol_trans
from retail_sales
group by category,gender
order by category;


-- Q.7 Write a SQL query to calculate the average sale for each month. 
-- Find out best selling month in each year
select * from
(select 
Extract(Year from sale_date) As year_,
Extract(Month from sale_date) As mon_,
Round(avg(total_sale)::Numeric, 2) As avg_sale,
Rank() over(partition by Extract(Year from sale_date) order by avg(total_sale) desc) as ranks
from retail_sales 
group by year_,mon_) t1 where ranks=1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id,sum(total_sale) as tol_sales
from retail_sales
group by 1
order by 2 desc limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(Distinct customer_id) 
from retail_sales
group by 1;


-- Q.10 Write a SQL query to create each shift and number of orders 
-- (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
With shift_hourly as(
select *, 
case 
    when Extract(hour from sale_time) < 12 then 'Morning'
	when Extract(hour from sale_time) Between 12 and 17 then 'Afternoon'
	else 'Evening'
	end
as shift
from retail_sales) 
select shift,count(*) as no_of_orders from shift_hourly group by shift;













