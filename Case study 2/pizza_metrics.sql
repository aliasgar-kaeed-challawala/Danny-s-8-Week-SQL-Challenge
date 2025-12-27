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

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

Select 
c.customer_id,
p.pizza_name,
Count(p.pizza_name) as order_count
from
customer_orders c inner join pizza_names p
on c.pizza_id = p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id
;
 
-- 6. What was the maximum number of pizzas delivered in a single order?

Select
MAX(pizza_count_per_order) as Maximum_pizzas_delivered
from
(Select
c.order_id,
count(pizza_id) as pizza_count_per_order
from
customer_orders c inner join runner_orders r 
on c.order_id =  r.order_id
where r.cancellation is null or r.cancellation = ''
group by c.order_id
Order by c.order_id) a
;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

Select customer_id,
SUM(
	CASE WHEN 
  		 c.exclusions = '' AND c.extras = '' THEN 1 ELSE 0
  	END	
) AS no_change,
SUM(
	CASE WHEN 
  		 c.exclusions != '' OR c.extras != '' THEN 1 ELSE 0
  	END	
) AS changed
from customer_orders c inner join runner_orders r
on c.order_id = r.order_id
and r.cancellation = ''
GROUP BY customer_id
ORDER BY customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?

Select
SUM(
	CASE WHEN 
  		 c.exclusions != '' AND c.extras != '' THEN 1 ELSE 0
	END
) as both_exclusions_and_extras
from customer_orders c inner join runner_orders r
on c.order_id = r.order_id
and r.cancellation = ''
;

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT EXTRACT(HOUR from order_time) as hour ,count(order_id) AS order_count_per_hour
FROM customer_orders
group by EXTRACT(HOUR from order_time);

-- 10. What was the volume of orders for each day of the week?
SELECT
    TO_CHAR(order_time, 'FMDay') AS weekday_name,
    COUNT(*) AS orders
FROM customer_orders
GROUP BY weekday_name
ORDER BY weekday_name;