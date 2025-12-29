-- Runner and Customer Experience:

-- 1. How many runners signed up for each 1 week period? 
SELECT
    EXTRACT(WEEK FROM registration_date)::int AS week,
    COUNT(runner_id)
FROM runners
GROUP BY EXTRACT(WEEK FROM registration_date)
ORDER BY week;

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
Select ROUND(AVG(pickup_mins),2)
from 
	(
  Select 
  c.order_id,
  EXTRACT(EPOCH FROM (r.pickup_time - c.order_time)) / 60 AS pickup_mins
  from customer_orders c
  inner join runner_orders r
  on c.order_id = r.order_id
  where r.cancellation = '' or r.cancellation is NULL
  group by c.order_id,c.order_time,r.pickup_time
	) a;


-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

with order_time_metrics as(
	Select c.order_id,
  	count(*) as pizza_count,
  	EXTRACT(EPOCH FROM (r.pickup_time - c.order_time)) / 60 AS prep_time_mins
  	From customer_orders c
  	join runner_orders r
  on c.order_id = r.order_id
  GROUP BY c.order_id,c.order_time,r.pickup_time
)

Select pizza_count,
ROUND(AVG(prep_time_mins)) as avg_prep_time_mins,
count(*) as total_orders
from order_time_metrics
group by pizza_count
order by pizza_count;