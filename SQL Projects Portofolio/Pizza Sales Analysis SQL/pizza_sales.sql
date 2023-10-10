----------- set up data-------------

CREATE TABLE pizza_sales 
(
    pizza_id INT,
    order_id INT,
    pizza_name_id VARCHAR(512),
    quantity INT,
    order_date VARCHAR(512),
    order_time VARCHAR(512),
    unit_price VARCHAR(512),
    total_price VARCHAR(512),
    pizza_size VARCHAR(512),
    pizza_category VARCHAR(512),
    pizza_ingredients VARCHAR(512),
    pizza_name VARCHAR(512)
);




select * from pizza_sales
order by pizza_id;

ALTER TABLE pizza_sales
ADD COLUMN order_time_backup VARCHAR(512);

UPDATE pizza_sales
SET order_time_backup = order_time;

UPDATE pizza_sales
SET order_time = TO_TIMESTAMP(SUBSTRING(order_time, 1, 5), 'HH24:MI')

UPDATE pizza_sales
SET order_time = TO_CHAR(order_time::timestamp, 'HH24:MI');

-- Mengubah format tanggal ke "YYYY-MM-DD" menggunakan TO_DATE
ALTER TABLE pizza_sales
ALTER COLUMN order_date TYPE date USING TO_DATE(order_date, 'DD-MM-YYYY');


----------- PROBLEM STATEMENT ANSWER -------------
-- KPI REQUIREMENT
--1. Find Total Revenue
SELECT SUM(total_price) as total_revenue
from pizza_sales;


SELECT CAST(SUM(total_price) AS numeric(10, 4)) AS total_revenue
FROM pizza_sales;

--2. Average Order Value
SELECT (SUM(total_price)/ COUNT(DISTINCT order_id)) as avg_order_value from pizza_sales;
-- Answer :38.30726229508163

--3. Total Pizza Sold
--Answer : 49574
SELECT SUM(quantity) as Total_pizza_sold FROM pizza_sales;


--4 Total Orders
-- Answer : 21350
SELECT COUNT(DISTINCT order_id) as total_orders from pizza_sales;

--5. Average Pizzas Per Order : Dividing total number of pizzas sold by the total number of orders
-- Answer : 2.32

SELECT CAST(
    CAST(SUM(quantity) AS decimal(10,2)) / CAST(COUNT(DISTINCT order_id) AS decimal(10,2)) AS decimal(10,2)
) AS avg_pizza_sales
FROM pizza_sales;


-- CHART REQUIREMENT
--1. Daily Trend for Total Orders
SELECT TO_CHAR(order_date, 'Day') AS order_day, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY order_day
ORDER BY total_orders;

--2. Monthly Trend for Total Orders
SELECT TO_CHAR(order_date, 'Month') AS order_month, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY order_month
ORDER BY total_orders;

--3 Percentage of Sales by Pizza category  : Popularity of variouus pizza categories and their contribution to overall sales

SELECT
    pizza_category,
    SUM(total_price) AS terjual,
    (SUM(total_price) / total_sales::numeric * 100)::numeric(10, 2) AS percentage
FROM
    pizza_sales,
    (SELECT SUM(total_price) AS total_sales FROM pizza_sales) AS total_sales
GROUP BY
    pizza_category, total_sales
ORDER BY
    pizza_category;

--3 Percentage of Quantity by Pizza category  : Popularity of variouus pizza categories and their contribution to overall qty
SELECT
    pizza_category,
    SUM(quantity) AS terjual,
    (SUM(quantity) / total_quantity::numeric * 100)::numeric(10, 2) AS percentage
FROM
    pizza_sales,
    (SELECT SUM(quantity) AS total_quantity FROM pizza_sales) AS total
GROUP BY
    pizza_category, total_quantity
ORDER BY
    pizza_category;


--4. Percentage of sales by Pizza size
SELECT
    pizza_size,
    SUM(total_price) AS Sales,
    (SUM(total_price) / total_sales::numeric * 100)::numeric(10, 2) AS percentage
FROM
    pizza_sales,
    (SELECT SUM(total_price) AS total_sales FROM pizza_sales) AS total_sales
GROUP BY
    pizza_size, total_sales
ORDER BY
    pizza_size;


--5. Total Pizzas sold by pizza category:
select pizza_category, sum(quantity) as total_pizza_sold
from pizza_sales
WHERE MONTH(order_date) = 2
group by pizza_category;

-- with detail month 

SELECT
    pizza_category,
    SUM(quantity) AS total_pizza_sold
FROM
    pizza_sales
WHERE
    EXTRACT(MONTH FROM order_date) = 1
GROUP BY
    pizza_category;

--6. Total 5 Pizzas by revenue

SELECT pizza_name as Nama_Pizza,  SUM(total_price) as Total_Sales
from pizza_sales
group by pizza_name
order by Total_Sales desc
Limit 5;

--7 Bottom 5 Pizzas by Revenue
SELECT pizza_name as Nama_Pizza,  SUM(total_price) as Total_Sales
from pizza_sales
group by pizza_name
order by Total_Sales ASC
Limit 5;

--8 Top 5 Pizzas by quantity
SELECT pizza_name as Nama_Pizza,  SUM(quantity) as Total_Pizza_Sold
from pizza_sales
group by pizza_name
order by Total_Pizza_Sold desc
Limit 5;

--9 Bottom 5 Pizzas by quantity
SELECT pizza_name as Nama_Pizza,  SUM(quantity) as Total_Pizza_Sold
from pizza_sales
group by pizza_name
order by Total_Pizza_Sold ASC
Limit 5;

--10 Top 5 pizzas by total orders
SELECT pizza_name as Nama_Pizza,  COUNT(DISTINCT order_id) as jumlah_order
from pizza_sales
group by pizza_name
order by jumlah_order DESC
Limit 5;

--11 Top 5 pizzas by total orders
SELECT pizza_name as Nama_Pizza,  COUNT(DISTINCT order_id) as jumlah_order
from pizza_sales
group by pizza_name
order by jumlah_order ASC
Limit 5;