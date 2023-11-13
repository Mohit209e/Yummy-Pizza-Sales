use pizza_db;
select * from pizza_sales;

select count(*) from pizza_sales;

-- selecting all the columns
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'pizza_sales';
-- Performing Required Queries

-- Total Revenue
select round(sum(total_price),2) as Total_Revenue from pizza_sales;

-- Total order
select count(distinct(order_id)) as Total_Order from pizza_sales;
-- Total Pizza Sold 
select sum(quantity) as Total_Pizza_Sold from pizza_sales;

-- Average Order values
select avg(total_price) as Avg_Order_Value from pizza_sales; -- this is giving a different value as this calculating based on pizza id
select (sum(total_price)/count(distinct(order_id))) as Avg_Order_Value from pizza_sales; -- average solution

-- gpt solution
SELECT AVG(order_total) AS average_order_value
FROM (
    SELECT SUM(total_price) AS order_total
    FROM pizza_sales
    GROUP BY order_id
) AS subquery;

-- my solution
select avg(order_value) 
from (select sum(total_price) as order_value from pizza_sales
group by order_id) as subquery;

-- 5 Avg pizzas per order
Select round(sum(quantity)/count(distinct(order_id)),2) as Avg_Pizzas_Per_order 
from pizza_sales;

-- checking the data type of a column
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
TABLE_NAME = 'pizza_sales'
AND COLUMN_NAME = 'temp_date';

-- Change order date data type from text to date
		-- First create a backup
        -- Add a temporary column
        -- convert "dd-mm-yyyy" format to date format
        -- drop the older Order_date
        -- rename the temporary column
set sql_safe_updates = 0;         
	-- Add a temporary column
    Alter table pizza_sales Add temp_date Date;
	-- convert "dd-mm-yyyy" format to date format
    Update pizza_sales
    set temp_date = str_to_date(order_date, '%d-%m-%Y');
	-- drop the older Order_date
    Alter table pizza_sales drop order_date;
	-- rename the temporary column
    Alter table pizza_sales change temp_date order_date date;
set sql_safe_updates = 1;    

-- B number of orders per day
select dayname(order_date) as order_day, count(distinct(order_id)) as total_orders 
from pizza_sales
GROUP BY dayname(order_date)
Order by case when min(dayofweek(order_date)) = 1 then 7 else min(dayofweek(order_date)) - 1 end;
