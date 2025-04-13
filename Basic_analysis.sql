------  Understand The data  -------
select * from geo;
select * from people;
select * from products;
select * from sales;


-- Find those salesperson who is not assigned to any team.



-- Extract only 5 Rows of data from sales table
select
	*
from
	sales
limit 5;



-- Find the total sales, total geolocation , total sales person and total products.
-- Total Sales
select
	count(*) as total_sales
from
	sales;

-- Total Sales Person
select
	count(*) as total_salesperson
from
	people;


-- Total Products
select
	count(*) as total_products
from
	Products;



-- Total Geo Location
select
	count(*) as total_geolocation
from
	geo;



---------------------------
-- Find the Maximum and Minimum Sales Amount
select
	max(amount) as max_sales_amount , min(amount) as min_sales_amount
from
	sales;



-- Find those sales information where the amount is 0.
select
	*
from
	sales
where
	amount = 0;





