
drop table if exists zepto;

create table zepto(
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(120),
	name VARCHAR(150) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent Numeric(5,2),
	availableQuantity INTEGER,
	discountSellingPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outOfStock BOOLEAN,
	quantity INTEGER
);

-- row count
select count(*) from zepto;

--data
select * from zepto limit 10;

--null values
select * from zepto
where name is null
or 
category is null
or 
mrp is null
or 
discountPercent is null
or 
discountsellingPrice is null
or 
weightInGms is null
or 
availableQuantity is null
or 
outOfStock is null
or 
quantity is null


--different product categories

select distinct category 
from zepto 
order by category;

--product in stock vs out of stock
select outOfStock, count(sku_id)
from zepto 
group by outOfStock;

--product names present multiple times

select name, count(sku_id) as "number of SKUs"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;

--data cleaning

--products with price = 0

select * from zepto
where mrp = 0 or discountSellingPrice = 0;

delete from zepto where mrp = 0;

--convert paise to rupees
update zepto 
set mrp = mrp / 100.0, discountSellingPrice = discountSellingPrice / 100.0;

select mrp, discountSellingPrice from zepto;


--Q.1 Find top 10 best-value products based on the discount percentage.

select DISTINCT name, mrp, discountPercent
from zepto
order by discountPercent
limit 10;

--Q.2 Products with max MRP but ouf of stock.

select name, mrp
from zepto 
where outOfStock=True and mrp>300
order by mrp desc;

--Q.3 Calculate estimated revenue for each category.

select category,
sum(discountsellingprice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue

--Q.4 Find all products where MRP is greater than Rs.500 and discount is less than 10%

select distinct name, mrp, discountPercent
from zepto
where mrp>500 and discountPercent<10
order by mrp desc, discountPercent desc;

--Q.5 Identify the top 5 categories offering the highest average discount percentage

select category,
round(avg(discountPercent),2) as avg_discount
from zepto 
group by category
order by avg_discount desc
limit 5;

--Q.6 Find the price per gram for products above 100g and sort by best value.

select distinct name, weightInGms, discountsellingprice,
round(discountsellingprice/weightInGms,2) as price_per_gram
from zepto
where weightInGms >= 100
order by price_per_gram;

--Q.7 Group the products into categories like low, medium, bulk.

select distinct name, weightInGms,
case when weightInGms<1000 then 'Low'
	when weightInGms<5000 then 'Medium'
	else 'Bulk'
	End As weight_category
from zepto;

--Q.8 Total inventory weight per category.

select category,
sum(weightInGms*availableQuantity) as total_weight
from zepto 
group by category
order by total_weight;
