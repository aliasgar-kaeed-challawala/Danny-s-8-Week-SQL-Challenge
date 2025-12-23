-- PIZZA METRICS:

-- 1. How amny Pizzas were ordered?

Select COUNT(*) as pizza_count
from customer_orders;

-- 2. How many unique customer orders were made?

Select count(distinct order_id) as unique_order_count
from customer_orders;

-- 3. How many successful orders were delivered by each runner?

Select 
runner_id,
Count(order_id)
from runner_orders
where 
cancellation = '' and distance != 0
Group by runner_id;

-- 4. How many of each type of pizza was delivered?

Select p.pizza_name,
count(c.pizza_id) as delivered_pizza_count
from customer_orders c
join runner_orders r
on c.order_id = r.order_id
join pizza_names p
on c.pizza_id = p.pizza_id
WHERE r.cancellation = ''
GROUP by p.pizza_name;