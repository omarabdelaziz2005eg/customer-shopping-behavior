use master;
create database customerbehaviour;
use customerbehaviour;
select top 20 * from customer_shopping_behavior ;
select gender,sum(Purchase_Amount_USD) as revenue 
from customer_shopping_behavior 
group by gender;
select customer_id , purchase_amount_usd 
from customer_shopping_behavior 
where Discount_Applied='Yes' and Purchase_Amount_USD>=(select avg(Purchase_Amount_USD) from customer_shopping_behavior);
select top 5 item_purchased ,round(avg(review_rating),2) as "average product saving"
from customer_shopping_behavior
group by Item_Purchased
order by avg(Review_Rating)
;
select shipping_type,round(avg(purchase_amount_usd),2) 
from customer_shopping_behavior 
where shipping_type in ('standard','express')
group by shipping_type
select subscription_status,count(customer_id)as total_customers,round(avg(purchase_amount_usd),2)as avg_spend,
round(sum(purchase_amount_usd),2)as total_revenue
from customer_shopping_behavior
group by Subscription_Status
order by total_revenue,avg_spend desc
select top 5 item_purchased,round(100*sum(case when discount_applied='Yes' then 1 else 0 end)/count(*) ,2)as discount_rate
from customer_shopping_behavior
group by item_purchased
order by discount_rate desc;
with customer_type as (select customer_id,previous_purchases,
case 
when previous_purchases=1 then 'New'
when previous_purchases between 2 and 10 then 'Returning'
Else 'Loyal'
End as customer_segment
from
customer_shopping_behavior
)
select customer_segment,count(*)as 'Number of customers'
from customer_type
group by customer_segment
with item_counts as (select category,item_purchased,
count(customer_id)as total_orders,
ROW_NUMBER()over(partition by category order by count(customer_id) desc )as item_rank
from customer_shopping_behavior	
group by category,Item_Purchased
)
select item_rank,category,item_purchased,item_purchased,total_orders
from item_counts
where item_rank<=3
select subscription_status,count(customer_id)as repeat_buyers
from customer_shopping_behavior
where Previous_Purchases>5
group by Subscription_Status
