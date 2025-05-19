WITH tRXN_SUMMARY AS (
SELECT 
    t1.id as plan_id , 
    t1.description,
    t1.owner_id,
    CASE 
        WHEN t1.is_a_fund = 1 THEN 'Investment'
        WHEN t1.is_regular_savings = 1 THEN 'Savings'
    END AS plan_type,
    MAX(DATE(t2.transaction_date)) AS last_trxn_date,
	DATEDIFF(CURRENT_DATE, MAX(DATE(t2.transaction_date))) AS days_since_last_trxn
FROM 
    plans_plan AS t1
JOIN
    savings_savingsaccount AS t2 ON t1.id = t2.plan_id
WHERE 
    t1.is_a_fund = 1 OR t1.is_regular_savings = 1
GROUP BY 
    t1.id, 
    t1.description,
    t1.owner_id,
    plan_type
    )
select plan_id,
	owner_id,
    plan_type,
    last_trxn_date,
    days_since_last_trxn as Inactive_days
from tRXN_SUMMARY
where days_since_last_trxn > 365