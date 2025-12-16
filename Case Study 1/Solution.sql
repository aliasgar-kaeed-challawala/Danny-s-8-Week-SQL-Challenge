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

-- 5. Which item was the most popular for each customer?

with fav_item as(
	Select customer_id,
  	product_id,
    count(product_id) as pop_count,
  	Rank() Over(partition by customer_id order by count(product_id) desc) as rnk
    from sales
    group by customer_id, product_id 
)
Select 
customer_id, m.product_name
from
fav_item a
inner join menu m 
on a.product_id = m.product_id
where rnk = 1
order by customer_id
;

-- 6. Which item was purchased first by the customer after they became a member?


Select 
customer_id,
product_name
from (Select 
s.customer_id,
order_date,
join_date,
product_id,
Rank() over(partition by s.customer_id order by order_date asc) as rnk
from 
sales s
inner join members m
on s.customer_id = m.customer_id
and 
s.order_date > m.join_date) a 
inner join menu m
on a.product_id = m.product_id
where rnk = 1
order by a.customer_id;

-- 7. Which item was purchased just before the customer became a member?

Select 
s.customer_id,
m.product_name
from
(
  Select 
  s.customer_id,
  order_date,
  join_date,
  product_id,
  Row_Number() over(partition by s.customer_id order by order_date desc) as rn
  from Sales s
  join members m
  on s.customer_id = m.customer_id
  and s.order_date < m.join_date
) s
 join menu m on 
 s.product_id = m.product_id
 where rn = 1
  ;


-- 8. What is the total items and amount spent for each member before they became a member?
Select 
s.customer_id,
Count(s.product_id) as total_items,
SUM(m.price) as amount_spent
from Sales s
inner join members me
on
	s.customer_id = me.customer_id
    AND s.order_date < me.join_date
inner join menu m
on 
	s.product_id = m.product_id
Group by 
s.customer_id
order by s.customer_id

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
Select customer_id,
SUM(
  CASE WHEN
      m.product_name = 'sushi' Then price*20
      ELSE price*10
      END )AS points
  from sales s
  inner join 
  menu m
  on 
  s.product_id = m.product_id
  Group by customer_id
  order by customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

with dates as (
	Select customer_id,
  	join_date,
  join_date + 6 as valid_date,
  DATE_TRUNC(
  	'month','2021-01-31'::DATE)
  +interval '1 month'
  -interval '1 day' as last_date
  from members)
  
 Select 
 s.customer_id,
 SUM(
 	CASE WHEN 
   			m.product_name = 'sushi' THEN 2 *10 * m.price
   		 WHEN
   			s.order_date BETWEEN d.join_date and d.valid_date THEN 2 * 10 * m.price
   		 ELSE 
   			m.price * 10
  	END
 )as points
 from sales s
 join dates d on s.customer_id = d.customer_id
 and d.join_date <= s.order_date
 and s.order_date <= d.last_date
 inner join menu m
 on s.product_id = m.product_id
Group by s.customer_id