/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

Select 
s.customer_id,
SUM(m.price)
from 
sales s
inner join menu m
on s.product_id = m.product_id
GROUP BY s.customer_id
Order by s.customer_id desc;

-- 2. How many days has each customer visited the restaurant?

Select customer_id,
Count(Distinct order_date)
from sales
group by customer_id;

-- 3. What was the first item from the menu purchased by each customer?

With ranked as (Select customer_id,
order_date,
product_id,
ROW_NUMBER() OVER(partition by customer_id order by order_date ASC) as rn
from sales
)

Select customer_id,
product_name from ranked r
join menu m on r.product_id = m.product_id
where rn = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

Select m.product_name,
Count(s.product_id) as purchase_count
from 
sales s join menu m
on s.product_id = m.product_id
GROUP BY m.product_name
order by purchase_count desc limit 1;