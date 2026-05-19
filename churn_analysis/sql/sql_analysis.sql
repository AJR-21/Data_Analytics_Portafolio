--list the max price of each plan
SELECT plan, MAX(plan_list_price) AS max_price
FROM account_info
GROUP BY plan
ORDER BY max_price DESC;