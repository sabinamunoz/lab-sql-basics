use bank;
-- 1. Get the id values of the first 5 clients from district_id with a value equals to 1.
select client_id, district_id from bank.client where district_id = '1'
limit 5;
-- 2. In the client table, get an id value of the last client where the district_id equals to 72.
select client_id, district_id from client where district_id= '72'
order by client_id desc
limit 1;
-- 3. Get the 3 lowest amounts in the loan table.
select amount from bank.loan order by amount asc
limit 3;
-- 4. What are the possible values for status, ordered alphabetically in ascending order in the loan table?
select distinct status from loan order by status;
-- 5. What is the loan_id of the highest payment received in the loan table?
select loan_id, payments from loan order by payments desc
limit 1;
-- 6. What is the loan amount of the lowest 5 account_ids in the loan table? Show the account_id and the corresponding amount.
select account_id, amount from loan order by account_id asc
limit 5;
-- 7. What are the account_ids with the lowest loan amount that have a loan duration of 60 in the loan table?
select account_id, amount from loan where duration = '60' order by amount asc
limit 5;
-- 8. What are the unique values of k_symbol in the order table?
select distinct k_symbol from bank.order;
-- 9. In the order table, what are the order_ids of the client with the account_id 34?
select order_id, account_id from bank.order where account_id='34';
-- 10. In the order table, which account_ids were responsible for orders between order_id 29540 and order_id 29560 (inclusive)?
select account_id, order_id from bank.order where order_id between '29540' and '29560';
-- 11. In the order table, what are the individual amounts that were sent to (account_to) id 30067122?
select amount, account_to from bank.order where account_to = '30067122';
-- 12. In the trans table, show the trans_id, date, type and amount of the 10 first transactions from account_id 793 in chronological order, from newest to oldest.
select trans_id, date, type, amount from bank.trans where account_id='793' order by date desc
limit 10;
-- 13. In the client table, of all districts with a district_id lower than 10, how many clients are from each district_id? Show the results sorted by the district_id in ascending order.
select district_id, count(*) as client_count
from client
where district_id < 10
group by district_id
order by district_id asc;
-- 14. In the card table, how many cards exist for each type? Rank the result starting with the most frequent type.
select type, count(*) as type_count from bank.card 
group by type
order by type_count;
-- 15. Using the loan table, print the top 10 account_ids based on the sum of all of their loan amounts.
select account_id, sum(amount) as total_loan_amount from bank.loan
group by account_id
order by total_loan_amount desc
limit 10;
-- 16. In the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order.
select date as loans_per_day, count(*) as loan_count from loan
where date < '930907'
group by loans_per_day
order by loans_per_day desc;
-- 17. In the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, ordered by date and duration, both in ascending order. You can ignore days without any loans in your output.
select date as numbe_loans, duration, count(*) as loan_count from loan
where date >= '971201' and date < '980101'
group by numbe_loans, duration
order by numbe_loans, duration asc;
-- 18. In the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). Your output should have the account_id, the type and the sum of amount, named as total_amount. Sort alphabetically by type.
select account_id, type, sum(amount) as total_amount from bank.trans
where account_id='396' 
group by account_id, type
order by type asc;
-- 19. From the previous output, translate the values for type to English, rename the column to transaction_type, round total_amount down to an integer
select account_id,
case 
when type = 'PRIJEM' THEN 'Incoming'
when type = 'VYDAJ' THEN 'Outgoing'
end as transaction_type,
floor (total_amount)
from (select account_id, type, sum(amount) as total_amount from bank.trans
where account_id='396' 
group by account_id, type
order by type asc) as subquery order by transaction_type asc;
-- 20. From the previous result, modify your query so that it returns only one row, with a column for incoming amount, outgoing amount and the difference.
select  sum(case when type = 'PRIJEM' then total_amount end) as incoming_amount,
    sum(case when type = 'VYDAJ' then total_amount end) as outgoing_amount,
    sum(case when type = 'PRIJEM' then total_amount else -total_amount end) as difference
    from (select account_id, type, sum(amount) as total_amount from bank.trans
where account_id='396' 
group by account_id, type
order by type asc) as subquery;
-- 21. Continuing with the previous example, rank the top 10 account_ids based on their difference.
select account_id, difference
from (select account_id, sum(case when type = 'PRIJEM' then total_amount else -total_amount end) as difference
    from(select account_id, type, sum(amount) as total_amount
        from trans group by account_id, type) as subquery
   group by account_id order by difference desc) as ranked_accounts
limit 10;
