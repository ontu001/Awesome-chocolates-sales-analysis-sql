------- Understand The Data ------
select * from geo;
select * from people;
select * from products;
select * from sales;
------------- * -----------

-------- Data Type & Constrains ----
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE lower(table_name) = 'sales';
------------- * -----------

-------------  EDA Sales -----
-- To find out the total rows and columns:
select count(*) Total_row from sales;
-- Columns Number
select count(*) as Total_num 
from
information_schema.columns 
where table_name ='sales';
-- Min
select min(amount) as min_amount from sales;
-- Max
select Max(amount) as min_amount from sales;
--- Total Sales
select sum(amount) from sales;
-- Agerage Sales
select avg(amount) from sales;

-- Sale period
select min(saledate),max(saledate) from sales;

-- BETWEEN condition in SQL with < & > operators

select * from sales where boxes >0 and boxes <=50;

-- Using the between operator in SQL
select * from sales where boxes between 0 and 50;
------------- * -----------

-----------------EDA Products ------------
-- Count products
select count(product) from products;
-- What are unique products and sales person?
select distinct product from products;
-----------------EDA People -----------
-- Sales person
select distinct salesperson from people;
--- Sales person count
select count(distinct salesperson) from people;


------------------ EDA geo--------------------
select * from geo;
--- Region wise country count
select region,count(geo) as count_
from geo
group by 1;

-- Calculating a new column from existing columns
-- Giving the new column a name
SELECT SaleDate, Amount, Boxes, Amount / Boxes AS "amount_per_box"
	FROM sales ;

--- Zero check
select * from sales
where boxes=0;

-- Giving the new column a name
SELECT SaleDate, Amount, Boxes, Amount / Boxes AS "amount_per_box"
	FROM sales
where boxes > 0;

--Zero amount sales
select * from sales where amount = 0;


-------------
-- Showing sales data where amount is greater than 10,000 by descending order
select * from sales
where amount > 10000
order by amount desc;

--Where amounts are > 2,000 and boxes are <100 and top 5 by amount?

select * from sales 
where amount > 2000 and boxes < 100 
order by amount limit 5;

-- Select all data in a specific year

select SaleDate, Amount from sales
where amount > 10000 and extract( year from SaleDate) = 2022
order by amount desc;

--How many times we shipped more than 1,000 boxes in each month?
select extract(year from saledate) from sales;

--
select 
extract(year from saledate) as Year, 
extract( month from saledate) as Month, 
count(*) "More 1k boxes" from sales
where boxes>1000
group by extract(year from saledate), extract( month from saledate)
order by extract(year from saledate), extract( month from saledate);


------ In which month average sales is high ?

select 
extract(month from saledate), 
avg(amount) avg_amount
from 
sales
group by extract( month from saledate)
order by avg_amount desc;

--- Week Day Wise Sales
select 
to_char(saledate,'Day'), 
avg(amount) avg_amount
from 
sales
group by to_char(saledate,'Day')
order by avg_amount desc;

---How which products sell more boxes Top 5?

select pr.product, sum(boxes) as Total_Boxes
from sales s
join products pr on s.pid = pr.pid
group by pr.product order by Total_boxes desc limit 5;


--------- People
select team,count(salesperson)
from people
group by 1
order by 2 desc;


-- LIKE operator in SQL

select * from people
where salesperson like 'B%';

select * from people
where salesperson like '%B%';


--- Most selling countryMost-selling
select
geo,
sum(amount) sales_amount	
from sales 
join geo
on sales.geoid = geo.geoid
group by 1
order by 2 desc;


-- Using CASE to create branching logic in SQL

select 	SaleDate, Amount,
		case 	when amount < 1000 then 'Under 1k'
				when amount < 5000 then 'Under 5k'
                when amount < 10000 then 'Under 10k'
			else '10k or more'
		end as "Amount category"
from sales;

----------------
select 
		case 	when amount < 1000 then 'Under 1k'
				when amount < 5000 then 'Under 5k'
                when amount < 10000 then 'Under 10k'
			else '10k or more'
		end as "Amount category",
		count(distinct SaleDate),
		sum(amount)
from sales
group by 1
order by 2 desc;


-----
select * from (
select 
	"Amount category",
	geo,
	sales_amount,
	row_number() over(partition by "Amount category" order by sales_amount desc) rank
from
(
select 
		case 	when amount < 1000 then 'Under 1k'
				when amount < 5000 then 'Under 5k'
                when amount < 10000 then 'Under 10k'
			else '10k or more'
		end as "Amount category",
		geo,
		--count(distinct SaleDate),
		sum(amount) sales_amount
		
from sales 
join geo
on sales.geoid = geo.geoid
group by 1,2
)  ) 
where rank between 1 and 3;


---
-- How many shipments (sales) each of the sales persons had in the month of January 2022?

select p.Salesperson, count(*) as "Shipment Count"
from sales s
join people p on s.spid = p.spid
where SaleDate between '2022-01-01' and '2022-01-31'
group by p.Salesperson;

--  Which product sells more boxes? Milk Bars or Eclairs?

select pr.product, sum(boxes) as "Total Boxes"
from sales s
join products pr on s.pid = pr.pid
where pr.Product in ('Milk Bars', 'Eclairs')
group by pr.product;


--Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?

select pr.product, sum(boxes) as "Total Boxes"
from sales s
join products pr on s.pid = pr.pid
where pr.Product in ('Milk Bars', 'Eclairs')
and s.saledate between '2022-02-1' and '2022-2-7'
group by pr.product;



----
--Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?

select  extract(year from saledate) ,  
extract(month from saledate) ,
case when sum(boxes)>1 then 'yes' else 'no' end as status
--if(sum(boxes)>1, 'Yes','No') Status
from sales s
join products pr on pr.PID = s.PID
join geo g on g.GeoID=s.GeoID
where pr.Product = 'After Nines' and g.Geo = 'New Zealand'
group by  extract(year from saledate),  extract(month from saledate)
order by  extract(year from saledate),  extract(month from saledate);



-- India or Australia? Who buys more chocolate boxes on a monthly basis?

select
extract(year from saledate),  
extract(month from saledate),
sum(CASE WHEN g.geo='India'  THEN boxes ELSE 0 END) "India Boxes",
sum(CASE WHEN g.geo='Australia' THEN boxes ELSE 0 END) "Australia Boxes"
from sales s
join geo g on g.GeoID=s.GeoID
group by  extract(year from saledate),  extract(month from saledate)
order by  extract(year from saledate),  extract(month from saledate);


--To find the top sales day in terms of revenue for each region:
select * from
(
SELECT
    region,
    saledate,
    amount,
    ROW_NUMBER() OVER(
        PARTITION BY region
        ORDER BY amount DESC
    ) AS row_num
FROM
    sales
    JOIN geo USING (geoid)
)
where
    row_num = 1;


select * from people;