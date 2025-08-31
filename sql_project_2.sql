create database sql_project_2;
use sql_project_2;
drop table if exists retail_sales;
create table retail_sales
(transactions_id int primary key,
sale_date date,	
sale_time time,	
customer_id int,	
gender varchar(10),	
age	int,
category varchar(25),	
quantiy	int,
price_per_unit float,	
cogs float,	
total_sale float
);
select * from retail_sales;
select count(*)
from retail_sales;

-- data cleaning --

select * from retail_sales
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or 
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or 
price_per_unit is null
or
cogs is null
or
total_sale is null;

-- data exploration
-- what is the total sales we have
select count(*) as total_sales from retail_sales;


-- (1) write a sql querry to retrieve all columns for sales made on '2022-11-05'?

select * from retail_sales
where sale_date = '2022-11-05';

-- (2) write  a sql querry to retrive all transactions where the category is "clothing" and the quantity sold is more than
-- or equal to 4 in the month of Nov-2022? 

select * from retail_sales
where category = 'Clothing' and sale_date like '2022-11-%'
and quantiy >= 4;


-- (3) write a sql querry to calculate the total sales (total_sale) for each category?

select category, sum(total_sale) as total_sale
from retail_sales
group by category;


-- (4) write a sql querry to find the average  age of customers who purchased items from the "Beauty" category?

select category, round(avg(age),2) as avg_age_of_customer
from retail_sales
where category = "Beauty"
group by category;

-- (5) write a sql querry to find all transactions where the total_sale is greater than 1000?

select * from retail_sales
where total_sale > 1000;

-- (6) write a sql querry to find the total number of transactions (transaction_id) made by each gender in each category?

select category, gender, count(transactions_id)
from retail_sales
group by category, gender
order by 1;

-- (7) write a sql querry to calculate the average sale for each month. find out best selling month in each year?


select*from
(
   select 
      extract(year from sale_date) as year,
      extract(month from sale_date) as month,
	  avg(total_sale) as avg_of_sale,
      RANK() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as ranking
  from retail_sales
group by 1, 2
) as t1
where ranking = 1;


-- (8) write a sql querry to find the top 5 customers based on the highest sales?

select customer_id, sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc limit 5;


-- (9) write a sql querry to find the number of unique customers who purchased items from each category?

select category, count(distinct(customer_id)) as unique_customer
from retail_sales
group by 1;

-- (10) write a sql querry to create each shift and number of orders(example Morning <= 12, Afternoon Between 12 and 17,
-- Evening >17)?

with hourly_sale
as
(
select *,
case
    when extract(hour from sale_time)<= 12 then "Morning"
    when extract(hour from sale_time) between 12 and 17 then "Afternoon"
    else "Evening"
    end as shift
    from retail_sales
    )
select
    shift,
    count(*) as total_orders
    from hourly_sale
    group by shift;
     










