select * from sales.sales_table;
select count(*) from sales.sales_table;

/*  number of rows ( 1987 )--

 how many records we have ?-- (1997)

*/
select count(transactions_id) from sales.sales_table;

/* how many customers we have ? ( 155 )  
*/
select count(distinct customer_id) from sales.sales_table;

/* how many category we have ? ( 3 )  
*/
select count(distinct category) from sales.sales_table;

/* how many name of category we have ?
 (  Clothing	,	Beauty 	,	Electronics )  
*/
select distinct category from sales.sales_table;

/* total sales ? ( '911,720' ) $
*/
select sum(total_sale) from sales.sales_table;

/* total net profit ? ( 721,771 )
*/
select sum( total_sale - cogs) as profit from sales.sales_table   ;

/* total quantity ? ( 5018  ) 
*/
select sum(quantity) as quantity from sales.sales_table   ;

/* profit per unit? ( 143.8364  ) 
*/

-- select (profit / quantity) from sales.sales_table;




/*
   Questions -1-
   write a sql query to retrieve all column for sales  made on 2022-11-05
   
   */
   select * from sales.sales_table  where sale_date = '2022-11-05';
   
   /*
   Questions -2
   write a sql query to retrieve all the transaction where the category is 'clothing'
   (   Clothing	1785   )
   and the quantity sold is more than 4 in the month of NOV -2022
   ( there are 17 record of clothing sold more than 4 in the month )
   
   */
select category , sum(quantity)
from sales_table
where category = 'clothing'
group by  category;

select * from sales_table
where category = 'clothing'
and 
sale_date like '2022-11-%%'
and 
quantity >= 4 ;

/* write a SQL query to calculate the total sales for each category
(Clothing	311070
Beauty	286840
Electronics	313810 )
*/
select category , sum(total_sale) as net_total
from sales.sales_table
group by 1
order by net_total  desc;

/* write a SQL query to find the average age of customers who purchased items from ' Beauty' catefory
 (  Beauty	40.42 )
*/
select category , round(avg(age),2)
from sales_table
where category = 'Beauty' ;


/* Q-5 write a SQL query to find all transactions where the total_sale is greater than 1000
*/
select * from sales_table
where total_sale > 1000;

/* write a SQL query to find the total number of transaction made by each gender in each category

( Clothing	    Male	354
  Clothing	    Female	347
  Electronics	Male	344
  Electronics	Female	340
  Beauty	    Female	330
  Beauty	    Male	282 )
*/
select category ,gender , count(*) as total_trans
from sales_table
group by 1,2
order by  total_trans desc;


/* Q-7 write a SQL query to calculate the average sale for each month .
 find out the best month in each year
 
 ( 2022	7	541.34	1
   2023	2	535.53	1 )

*/



select * from 
(
	select 
	extract(YEAR from sale_date) as year,
	extract( MONTH from sale_date) as month,
	round( avg(total_sale) ,2) ,
	rank() over (partition by extract(YEAR from sale_date) order by avg(total_sale) desc ) as rankk
	from sales.sales_table
	group by 1,2
    ) as t1
where rankk=1;


/* Q-8 write a SQL query to find top 5 customers based on the hightest total sales 
(  
				3	38440
				1	30750
				5	30405
				2	25295
				4	23580 )
*/
select customer_id ,sum(total_sale) as sum_sale
from sales.sales_table
group by customer_id
order by sum_sale DESC
limit 5 ;



/* Q-9 write a SQL query to find the number of unique customers who purchased items from each category
 ( 
			Clothing	149
			Electronics	144
			Beauty	141
)
*/
 
select category , count(distinct customer_id) as num_customers
from sales.sales_table
group by 1
order by num_customers DESC;









/* Q10- write a SQL query to create each shift and number of orders example 
morning < = 12 
afternon  between 12 and 17
evening  >17

ANSWER 
					morning		558
					evening		1062
					afternoon	377
*/


with hourly_sales
as (
select * ,
	case
		when extract( hour from sale_time) < 12 then 'morning'
        when extract( hour from sale_time) between 12 and 17 then 'afternoon'
        else 'evening'
	end as shift
from sales_table
)
select  shift, count(*)  as number_of_orders
from hourly_sales
group by 1;

-- End Of the project
