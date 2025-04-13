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






-- find the total sales amoun
select
	sum(amount) as total_sales_amount
from
	sales;


-- Find the starting and ending date of sales
select
    max(saledate) as Starting_date, min(saledate) as End_date
from
    sales;









-- Find the sales data where maximum 50 boxse are sold
select
	*
from
	sales
where
	boxes>0 and boxes<=50
	

-- Find the total number of sales data where maximum 50 boxse are sold

select
	count(*) as total_sales
from
	sales
where
	boxes between 0 and 50;





--Find how many countries are there  under every region.
select
	region , count(geo) as total_country
from 
	geo
group by 1
order by total_country desc;






-- Find the selling amount per box
select
	spid, amount/boxes as sell_amount_per_box
from sales
	where boxes>0;





-- Find the 10 highest amount of selling data
select * from sales where amount >10000 order by amount desc;


-- Find top 10 selling amount's sales data
select * from sales order by amount desc limit 10;



-- Find the country name along with their total selling amount
select
	geo, sum(amount) as total_amount
from
	sales
inner join
	geo on sales.geoid = geo.geoid
group by
	geo
order by
	total_amount desc;









