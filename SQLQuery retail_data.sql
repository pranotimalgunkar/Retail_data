create database retail_data

select * from data_retail;

--SQL Query analysis
--Identifies products with prices higher than the average price within their category.
with cte as (
	select product_id,product_name,price,category,avg(price) over(partition by category) as avg_price 
	from data_retail
)
select product_id,product_name,category,price,avg_price from cte
where avg_price<price
order by category,price desc;

---counting category product prices higher than the average price 
with cte as (
	select product_id,product_name,price,category,avg(price) over(partition by category) as avg_price 
	from data_retail
)
select category,count(*) from cte
where avg_price<price
group by category
order by category

--Finding Categories with Highest Average Rating Across Products.
with cte as (
    select category,product_name,avg(rating) as avg_rating,
    rank() over(partition by product_name order by avg(rating) desc) as rnk
    from Data_retail
    group by category,product_name
) 
select category,product_name,avg_rating from cte 
where rnk = 1;

--Find the most reviewed product in each warehouse
with cte as (
    select warehouse,product_name,sum(reviews) as total_reviews,
    rank() over(partition by product_name order by sum(reviews) desc) as rnk from Data_retail
group by warehouse,product_name)

select warehouse,product_name,total_reviews from cte
where rnk=1;

--find products that have higher-than-average prices within their category, along with their discount and supplier.
with cte as (
	select product_id,product_name,price,category,avg(price) over(partition by category) as avg_price,
	discount,Supplier
	from data_retail
)
select product_id,product_name,category,price,avg_price,discount,Supplier from cte
where avg_price<price
order by category,price desc

--Query to find the top 2 products with the highest average rating in each category
WITH cte AS (
    SELECT 
        product_id,
        product_name,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER (PARTITION BY category ORDER BY AVG(rating) DESC) AS rnk
    FROM data_retail
    GROUP BY product_id, product_name, category
 )
SELECT 
    product_id,
    product_name,
    category,
    avg_rating
FROM cte
WHERE rnk <= 2
ORDER BY category, avg_rating DESC;


--Analysis Across All Return Policy Categories(Count, Avgstock, total stock, weighted_avg_rating, etc)
select 
    return_policy,
    count(*) as product_count,
    avg(stock_quantity) as Avgstock,
    sum(stock_quantity) as Total_stock,
    sum(rating * reviews)/sum(reviews) AS weighted_avg_rating
from Data_retail
group by Return_Policy
order by weighted_avg_rating desc;

