
--How many customers are there?
SELECT COUNT(DISTINCT user_id) AS total_customers
FROM account_info;

--list the min and max price of each pay plans
SELECT plan, 
	MIN(plan_list_price) AS min_price,
	MAX(plan_list_price) AS max_price
FROM account_info
WHERE plan <> 'Free'
GROUP BY plan;

-- How many customer are there in each plan type?
SELECT plan,
	COUNT(*) AS total_customers,
	ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER(), 2) AS percentage
FROM account_info
GROUP BY plan
ORDER BY total_customers DESC;

--What is the proportion of churned customers?
SELECT churn_status,
	COUNT(*) AS total_customers,
	ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER(), 2) AS percentage
FROM account_info
GROUP BY churn_status;

-- What is churn rate by each plan type and overall churn rate
SELECT plan,
	SUM(CASE WHEN churn_status = 'Yes' THEN 1 END) AS total_churned,
	ROUND(100.0*SUM(CASE WHEN churn_status = 'Yes' THEN 1 END)/COUNT(*), 2) AS churn_rate_plan,
	ROUND(100.0*SUM(CASE WHEN churn_status = 'Yes' THEN 1 END)/SUM(COUNT(*)) OVER(), 2) AS overall_churn_rate
FROM account_info
GROUP BY plan
ORDER BY total_churned DESC;

--How many issues were reported by topic?
SELECT topic,
	COUNT(*) AS total_issues
FROM customer_support
GROUP BY topic
ORDER BY total_issues DESC;

--On average how long takes to solve each king of issue?
SELECT topic,
	ROUND(AVG(resolution_time_hours)::NUMERIC, 2) AS avg_resolution_hours,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY resolution_time_hours ))::NUMERIC, 2) AS median_resolution_hours
FROM customer_support
WHERE state_label = 'Solved'
GROUP BY topic
ORDER BY avg_resolution_hours DESC;

-- Clasify the resolution time hours in four groups and count the number of issues solved
WITH resolution_group AS(
	SELECT user_id,
		CASE WHEN resolution_time_hours < 5 THEN 'Very efficient'
			WHEN resolution_time_hours < 10 THEN 'Efficient'
			WHEN resolution_time_hours < 15 THEN 'Unefficient'
		ELSE 'Very Unefficient' END AS efficient_category
	FROM customer_support
	WHERE state_label = 'Solved'
)

SELECT efficient_category,
	COUNT(*) AS total_issues
FROM resolution_group
GROUP BY efficient_category
ORDER BY total_issues DESC;

-- What is the effectiveness solving problems?
SELECT state_label,
	COUNT(*) AS total_issues,
	ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER(), 2) AS percentage
FROM customer_support
GROUP BY state_label
ORDER BY percentage DESC;

-- How many issues was reported in each month?
SELECT TO_CHAR(ticket_Time, 'YYYY-MM') AS month,
	COUNT(*) AS total_issues
FROM customer_support
GROUP BY month
ORDER BY month;

-- Which plan type report more issues?
SELECT plan,
	COUNT(*) AS total_issues,
	ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ranking
FROM customer_support AS cs
LEFT JOIN account_info AS ai
ON cs.user_id = ai.user_id
GROUP BY plan;

--What is the most popular activity on the app
SELECT event_type,
	COUNT(*) AS total_user
FROM user_activity
GROUP BY event_type
ORDER BY total_user DESC
LIMIT 1;

--Which is the most active plan by month
WITH month_activity AS(
	SELECT plan,
		TO_CHAR(event_time, 'YYYY-MM') AS months
	FROM user_activity AS ua
	LEFT JOIN account_info AS ai
	ON ua.user_id = ai.user_id
), plan_activity AS(
	SELECT months,
		plan,
		COUNT(*) AS total_users,
		DENSE_RANK() OVER(PARTITION BY months ORDER BY COUNT(*) DESC) AS rk
	FROM month_activity
	GROUP BY months, plan
)

SELECT months, 
	plan,
	total_users,
	rk
FROM plan_activity
WHERE rk = 1; 

--Top 3 days with the most activity on the app
SELECT TO_CHAR(event_time, 'day') AS days,
	COUNT(*) AS total_users
FROM user_activity
GROUP BY days
ORDER BY total_users DESC
LIMIT 3;

-- Peak hours by day
WITH hours_activity AS(
	SELECT user_id,
		TO_CHAR(event_time, 'day') AS days,
		EXTRACT(HOUR FROM event_time) AS hours
	FROM user_activity
		
), peak_hours AS(
	SELECT days,
		hours,
		COUNT(*) AS total_users,
		DENSE_RANK() OVER(PARTITION BY days ORDER BY COUNT(*)DESC) AS rk
	FROM hours_activity
	GROUP BY days, hours
)

SELECT days,
	hours,
	total_users,
	rk
FROM peak_hours
WHERE rk = 1;