# Challenge 1
# Step 1
use publications;
select ta.au_id, ta.title_id, (ifnull(titles.advance,0) * ifnull(ta.royaltyper, 0)) / 100 as advance, 
(((ifnull(titles.price, 0) * ifnull(sales.qty, 0) * ifnull(titles.royalty, 0)) / 100) * (ifnull(ta.royaltyper, 0) / 100)) as sales_royalty
from titleauthor as ta
left join titles on ta.title_id = titles.title_id
inner join sales on ta.title_id = sales.title_id
order by ta.au_id asc;


# Step 2
use publications;
select au_id, title_id, sum(sales_royalty)
from (
	select ta.au_id, ta.title_id, (ifnull(titles.advance,0) * ifnull(ta.royaltyper, 0)) / 100 as advance, 
	(((ifnull(titles.price, 0) * ifnull(sales.qty, 0) * ifnull(titles.royalty, 0)) / 100) * (ifnull(ta.royaltyper, 0) / 100)) as sales_royalty
	from titleauthor as ta
	left join titles on ta.title_id = titles.title_id
	inner join sales on ta.title_id = sales.title_id) step1
group by au_id, title_id
order by sum(sales_royalty) desc;
    
    
# Step 3
use publications;
select au_id, sum(sum_advance + sum_royalty) as profit
from (
		select au_id, title_id, sum(sales_royalty) as sum_royalty, sum(advance) as sum_advance
		from (
			select ta.au_id, ta.title_id, (ifnull(titles.advance,0) * ifnull(ta.royaltyper, 0)) / 100 as advance, 
			(((ifnull(titles.price, 0) * ifnull(sales.qty, 0) * ifnull(titles.royalty, 0)) / 100) * (ifnull(ta.royaltyper, 0) / 100)) as sales_royalty
			from titleauthor as ta
			left join titles on ta.title_id = titles.title_id
			inner join sales on ta.title_id = sales.title_id
            ) step1
			group by au_id, title_id
		) step2
group by au_id
order by profit desc
limit 3;