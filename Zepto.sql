use zepto;
select * from zepto_v1;
-- count of rows
select count(*) from zepto_v1;
-- null values
select * from zepto_v1
where Category is null or 
name is null or 
mrp is null or
discountpercent is null or 
availablequantity is null or 
discountedSellingPrice is null or 
weightInGms is null or 
outofstock is null or 
quantity is null;

-- different product cat.
select distinct Category from zepto_v1

-- product is stock and out of stock

select outofstock, count(name) from zepto_v1
Group by outofstock;

-- product name present multiple times

SELECT 
    name, 
    COUNT(*) AS occurrence
FROM 
    zepto_v1
GROUP BY 
    name
HAVING 
    COUNT(*) > 1
ORDER BY COUNT(*)DESC;

-- DATA CLEAN

-- PRODUCT with PRICE 0 --
SELECT * FROM ZEPTO_V1
where MRP =0 OR discountedSellingPrice=0;

DELETE FROM ZEPTO_V1
where mrp =0;


-- CONVERT PAISE TO RUPEE
UPDATE ZEPTO_V1
SET MRP = MRP/100, discountedSellingPrice = discountedSellingPrice/100; 

SET SQL_SAFE_UPDATES =0;

-- 1.  FIND TOP 10 BEST VALUE PRODUCTS BASED ON DISCOUNT %---

SELECT DISTINCT NAME, discountPercent FROM ZEPTO_V1
ORDER BY DISCOUNTPERCENT DESC
LIMIT 10;

-- 2. product with high mrp but out of stock

-- Query 1 = Aggregated total MRP per product (all out-of-stock).

select name, sum(mrp), outofstock from zepto_v1
where outofstock = 'True'
GROUP BY 
    name
order by 
   sum(mrp);

-- Query 2 = List of expensive out-of-stock products (MRP > 300, no aggregation).

SELECT DISTINCT NAME, MRP FROM ZEPTO_V1
where OUTOFSTOCK = TRUE AND MRP>300
order by MRP DESC;

-- 3. CALCULATE ESTIMATED REVENUE FOR EACH CATEGORY

SELECT Category, SUM(discountedSellingPrice*availableQuantity) REVENUE FROM ZEPTO_V1
GROUP BY Category
ORDER BY REVENUE DESC;

-- 4. FIND ALL PRODUCT where MRP IS > THAN 500 AND DISCOUNT IS LESS THAN 10

SELECT DISTINCT NAME, MRP, discountPercent FROM ZEPTO_V1
where MRP > 500 AND discountPercent < 10
ORDER BY MRP DESC, discountPercent DESC ;

-- 5. IDENTIFIY TOP 5 CATEGORY OFFERENING THE AVERAGE DISCOUNT PERCENTAGE 

SELECT CATEGORY,
round(avg(DISCOUNTPERCENT),2) FROM ZEPTO_V1
GROUP BY Category
ORDER BY avg(DISCOUNTPERCENT) DESC
LIMIT 5;

-- 6. Find the price per gram for products above 100g and sort by best value

select * from zepto_v1;
select name, round(mrp/weightInGms,2) as price_per_gram from zepto_v1
where weightInGms >100
order by price_per_gram;

-- 7. group the products into categories like low, medium, bulk based on weight in grams

select distinct name, weightInGms,
case when weightInGms <1000 then 'low'
when weightInGms < 5000 then 'avg'
Else 'Bulk'
end as weight_Category
from zepto_v1;

-- 8. total inventory weight per Category

select Category, sum(weightInGms* availableQuantity ) as inventory_weight from zepto_v1
group by Category
order by sum(weightInGms) desc;





