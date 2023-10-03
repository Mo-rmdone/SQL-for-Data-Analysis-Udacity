/* GROUP BY/*

/*Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.*/

SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

/*Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.*/

SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;

/*Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event?
 Your query should return only three values - the date, channel, and account name.*/

SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id 
ORDER BY w.occurred_at DESC
LIMIT 1;

/*Find the total number of times each type of channel from the web_events was used. Your final table should have two columns
 - the channel and the number of times the channel was used.*/

SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel;

/*Who was the primary contact associated with the earliest web_event?*/

SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1; 

/*What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd.
 Order from smallest dollar amounts to largest.*/

SELECT a.name, MIN(total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;


/*Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps.
 Order from fewest reps to most reps.*/

SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;


/*For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns
 - one for the account name and one for the average spent on each of the paper types.*/

SELECT a.name, AVG(o.standard_qty) avg_stand, AVG(o.gloss_qty) avg_gloss, AVG(o.poster_qty) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

/*For each account, determine the average amount spent per order on each paper type. Your result should have four columns
 - one for the account name and one for the average amount spent on each paper type.*/

SELECT a.name, AVG(o.standard_amt_usd) avg_stand, AVG(o.gloss_amt_usd) avg_gloss, AVG(o.poster_amt_usd) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

/*Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns
 - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.*/

SELECT s.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;

/*Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns
 - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.*/

SELECT r.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;


--***************************************************************************************************************************************************************************

/*HAVING*/

/*How many of the sales reps have more than 5 accounts that they manage?*/

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;

-- or using a SUBQUERY as shown below. 

SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
        FROM accounts a
        JOIN sales_reps s
        ON s.id = a.sales_rep_id
        GROUP BY s.id, s.name
        HAVING COUNT(*) > 5
        ORDER BY num_accounts) AS Table1;

/*How many accounts have more than 20 orders?*/

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;

/*Which account has the most orders?*/

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;

/*How many accounts spent more than 30,000 usd total across all orders?*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;

/*How many accounts spent less than 1,000 usd total across all orders?*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

/*Which account has spent the most with us?*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

/*Which account has spent the least with us?*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

/*Which accounts used facebook as a channel to contact customers more than 6 times?*/

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

/*Which account used facebook most as a channel?*/

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;



