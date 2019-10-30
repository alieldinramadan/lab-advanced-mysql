#Challenge 2
# To creat the first Table
use publications;
create temporary table cal_roy_adv
select ta.au_id, ta.title_id, (ifnull(titles.advance,0) * ifnull(ta.royaltyper, 0)) / 100 as advance, 
(((ifnull(titles.price, 0) * ifnull(sales.qty, 0) * ifnull(titles.royalty, 0)) / 100) * (ifnull(ta.royaltyper, 0) / 100)) as sales_royalty
from titleauthor as ta
left join titles on ta.title_id = titles.title_id
inner join sales on ta.title_id = sales.title_id
order by ta.au_id asc;

# To test that the first table is working fine
use publications;
select au_id, title_id, sum(sales_royalty) as sum_royalty,  sum(advance) as sum_advance
from cal_roy_adv
group by au_id, title_id
order by sum(sales_royalty) desc;

#To create the second table using the first temporary table (cal_roy_adv)
use publications;
create temporary table sum_roy_adv
select au_id, title_id, sum(sales_royalty) as sum_royalty,  sum(advance) as sum_advance
from cal_roy_adv
group by au_id, title_id
order by sum(sales_royalty) desc;

# To test that the second table is working fine
use publications;
select au_id, sum(sum_advance + sum_royalty) as profit
from sum_roy_adv
group by au_id
order by profit desc
limit 3;

#To create the third table using the second temporary table (sum_roy_adv)
use publications;
create temporary table total_profit
select au_id, sum(sum_advance + sum_royalty) as profit
from sum_roy_adv
group by au_id
order by profit desc;

# To test that the third table is working fine
use publications;
select *
from total_profit
order by profit desc;