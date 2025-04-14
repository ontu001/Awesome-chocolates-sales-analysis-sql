-- Requirements
1.----- Find the most popular product in every country.

with top_product as(
select 
	geo.geo as country,
	product,
	sum(boxes) as total_boxes,
	rank() over (partition by geo order by sum(boxes) desc) as rank
	from sales
	inner join geo on geo.geoid = sales.geoid
	inner join products on products.pid = sales.pid
	group by 1,2

)

select
	country,
	product, 
	total_boxes
from top_product
where rank = 1 
order by total_boxes desc



------------


2.----- What is the month with the most sales in every country?
with top_month as(
select
	geo.geo as country,
	extract(month from saledate) as month_,
	sum(boxes) as total_boxes,
	rank() over (partition by geo order by sum(boxes) desc) as rank
from sales
inner join geo on geo.geoid = sales.geoid
group by 1,2
)

select
	country,
	month_,
	total_boxes
from top_month
where rank = 1
order by total_boxes desc


3.----- Which regions have more selling persons?
select 
	region,
	count(distinct spid) as total_salesperson
from geo
inner join sales on sales.geoid = geo.geoid
group by 1
order by total_salesperson desc
limit 1;



4.----- Top 3 countries considering selling person.
select 
	geo.geo as country,
	count(distinct spid) as total_salesperson
from geo
inner join sales on sales.geoid = geo.geoid
group by 1
order by total_salesperson desc
limit 3;




5.----- Top 3 countries considering selling days in 4 amount categories('10k or more', 'Under 10k', 'Under 5k', 'Under 1k'
with top_country as(
select
	case
	when sum(amount) >=10000 then '10k or more'
	when sum(amount) <10000 then 'Under 10k'
	when sum(amount) <5000 then 'Under 5k'
	when sum(amount) <1000 then 'Under 1k'
	else 'Invaalid'
	end as amount_category,
	geo.geo as country,
	count(distinct saledate) as selling_day
from sales
inner join geo on geo.geoid = sales.geoid
group by 2
)
select
	amount_category,
	country,
	selling_day
from top_country
order by selling_day desc
limit 3;
	




6.----- Which salespersons did not make any shipments in the first 7 days of January 2022?
SELECT
	salesperson,
	boxes,
	amount
FROM people
LEFT JOIN sales ON people.spid = sale s.spid
    AND sales.saledate BETWEEN '2022-01-01' AND '2022-01-07'
WHERE sales.spid IS NULL
ORDER BY people.salesperson;