------  Understand The data  -------
select * from geo;
select * from people;
select * from products;
select * from sales;





-- Find those salesperson who is not assigned to any team.
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'people';





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
     min(saledate) as Start_date, max(saledate) as End_date
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




-- Find how many salesperson are working on each country
select
	geo, count(people.spid) as total_salesperson
from
	sales
inner join geo on geo.geoid = sales.geoid
inner join people on people.spid = sales.spid
group by 1
order by
	total_salesperson desc;




--Categories the total amout of sale into 4 group
/*
less than 1000
1000 to 3000
3000 to 5000
more than 5000

*/



select
	case
		when amount < 1000 then 'Less than 1000'
        when amount between 1000 and 3000 then '1000 to 3000'
        when amount between 3000 and 5000 then '3000 to 5000'
        else 'More than 5000'
    end as amount_category,
	count(*) as total_sales
from
	sales
group by 1
order by total_sales;







--Categories the total amout of sale into 4 group by geo location
/*
less than 1000
1000 to 3000
3000 to 5000
more than 5000

*/


-- solution 1


select
	case
		when amount < 1000 then 'Less than 1000'
        when amount between 1000 and 3000 then '1000 to 3000'
        when amount between 3000 and 5000 then '3000 to 5000'
        else 'More than 5000'
    end as amount_category,
	geo,
	count(*) as total_sales	
from
	sales
inner join geo on sales.geoid = geo.geoid
group by 1,2
order by total_sales desc;





--solution 2

SELECT
geo,
    COUNT(CASE WHEN amount < 1000 THEN 1 END) AS "Less than 1000",
    COUNT(CASE WHEN amount BETWEEN 1000 AND 3000 THEN 1 END) AS "1000 to 3000",
    COUNT(CASE WHEN amount BETWEEN 3000 AND 5000 THEN 1 END) AS "3000 to 5000",
    COUNT(CASE WHEN amount > 5000 THEN 1 END) AS "More than 5000"
FROM sales
inner join geo on sales.geoid = geo.geoid
group by geo
;








--Find top sales amount by month of 2021
select
	extract(month from saledate) as month_ , sum(amount) as total_sales
from
	sales
where
	extract(year from saledate) = 2021
group by 1
order by 2 desc;







-- Find out the unique date for 2021
SELECT DISTINCT
    EXTRACT(MONTH FROM saledate) AS month_of_2021
FROM
    sales
WHERE
    EXTRACT(YEAR FROM saledate) = 2021
ORDER BY month_of_2021;