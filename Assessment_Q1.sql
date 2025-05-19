SELECT 
    t1.id as owner_id,
    CONCAT(MIN(first_name), ' ', MIN(last_name)) AS name,
    COUNT(DISTINCT CASE WHEN t2.is_a_fund = 1 AND t3.confirmed_amount > 0 THEN 1 ELSE 0 END) AS Invest_plans,
    COUNT(DISTINCT CASE WHEN t2.is_regular_savings = 1 AND t3.confirmed_amount > 0 THEN 1 ELSE 0 END) AS savings_plan,
    ROUND(
    SUM(CASE WHEN t3.confirmed_amount > 0 THEN t3.confirmed_amount ELSE 0 END) / 100,
    2
) AS Total_deposit_naira
FROM 
    users_customuser AS t1
JOIN
    plans_plan AS t2 ON t1.id = t2.owner_id
LEFT JOIN
    savings_savingsaccount AS t3 ON t2.id = t3.plan_id
GROUP BY 
    t1.id,
    t1.first_name,
    t1.username
HAVING 
    Invest_plans > 0
    AND savings_plan > 0
ORDER BY 
    Total_deposit_naira DESC;