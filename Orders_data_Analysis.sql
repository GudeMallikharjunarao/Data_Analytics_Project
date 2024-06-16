CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE,
    ship_mode VARCHAR(255),
    segment VARCHAR(255),
    country VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postal_code INTEGER,
    region VARCHAR(255),
    category VARCHAR(255),
    sub_category VARCHAR(255),
    product_id VARCHAR(255),
    quantity INTEGER,
    discount DECIMAL,
    sale_price DECIMAL,
    profit DECIMAL
);

select * from orders;

--find top 10 highest reveue generating products 

select product_id,sum(sale_price) as sales
from orders
group by product_id
order by sales desc
Limit 10;

--find top 5 highest selling products in each region

---select distinct region from orders;

with cte as(
select region,product_id,sum(sale_price) as sales
from orders
group by region,product_id)
select * from(
select * ,
row_number() over(partition by region order by sales desc) as rn
from cte) a
where rn<=5;

--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

WITH cte AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS order_year,
        EXTRACT(MONTH FROM order_date) AS order_month,
        SUM(sale_price) AS sales
    FROM Orders
    GROUP BY 1, 2
)
SELECT 
    order_month,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte 
GROUP BY order_month;

--for each category which month had highest sales 

WITH cte AS (
SELECT category,to_char(order_date, 'YYYYMM') AS order_year_month,
sum(sale_price) AS sales 
FROM orders
group by category,to_char(order_date, 'YYYYMM')
)
select * from(
select *,row_number() over(partition by category order by sales desc) as rn
from cte) a
where rn=1;