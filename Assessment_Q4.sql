WITH transaction_profits AS (
    SELECT
        t1.id AS customer_id,
        t1.first_name,
        t1.last_name,
        TIMESTAMPDIFF(MONTH, t1.date_joined, NOW()) AS tenure_months,
        t2.transaction_reference,
        (t2.confirmed_amount * 0.001) AS profit_per_transaction
    FROM
        users_customuser t1
    LEFT JOIN
        savings_savingsaccount t2
        ON t1.id = t2.owner_id
        AND t2.confirmed_amount > 0
)

SELECT
    customer_id,
    CONCAT(MIN(first_name), ' ', MIN(last_name)) AS name,
    tenure_months,
    COUNT(transaction_reference) AS total_transactions,
    ROUND(
        CASE 
            WHEN tenure_months = 0 THEN 0
            ELSE (COUNT(transaction_reference) / tenure_months) * 12 * (SUM(profit_per_transaction) / COUNT(transaction_reference))
        END, 2
    ) AS estimated_clv
FROM
    transaction_profits
GROUP BY
    customer_id, tenure_months
ORDER BY
    estimated_clv DESC;
