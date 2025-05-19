WITH Customer_summary AS (
    SELECT 
        t1.id AS customer_id,
        COUNT(t3.transaction_reference) AS total_transactions,
        COUNT(DISTINCT DATE_FORMAT(t3.transaction_date, '%Y-%m')) AS total_active_months,
        CASE 
            WHEN COUNT(DISTINCT DATE_FORMAT(t3.transaction_date, '%Y-%m')) = 0 THEN 0
            ELSE ROUND(COUNT(t3.transaction_reference) / COUNT(DISTINCT DATE_FORMAT(t3.transaction_date, '%Y-%m')), 2)
        END AS avg_txn_per_month
    FROM 
        users_customuser AS t1
    LEFT JOIN 
        savings_savingsaccount AS t3 
        ON t1.id = t3.owner_id 
        AND t3.confirmed_amount > 0
    GROUP BY 
        t1.id
),

Categorized_Customers AS (
    SELECT
        customer_id,
        total_transactions,
        total_active_months,
        avg_txn_per_month,
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9.99 THEN 'Medium Frequency'
            WHEN avg_txn_per_month < 2.99 THEN 'Low Frequency'
        END AS frequency_category
    FROM
        Customer_summary
)

SELECT
    frequency_category,
    COUNT(customer_id) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_monthly_txn_per_customer
FROM
    Categorized_Customers
GROUP BY
    frequency_category
ORDER BY
    avg_monthly_txn_per_customer DESC;
