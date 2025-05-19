Data Analytics Assessment
Question 1: Identify High-Value Customers with Multiple Products
Task:
Write a SQL query to find customers who have at least one funded savings plan and at least one funded investment plan. The results should be sorted by the total deposits made by each customer.

Approach:
The interviewer provided helpful hints about the relevant tables, which guided the query design. The approach involves joining the users_customuser, plans_plan, and savings_savingsaccount tables to:

    Identify customers (users_customuser) with plans (plans_plan),

    Filter plans that are funded (confirmed deposits > 0),

    Distinguish between investment plans (is_a_fund = 1) and savings plans (is_regular_savings = 1),

    Aggregate total confirmed deposits per customer,

    Finally, filter customers having at least one funded investment plan and at least one funded savings plan,

    Sort the results by total deposits in descending order.


Question 2: Transaction Frequency Analysis
Task:
Calculate the average number of transactions per customer per month and categorize them:

Approach:
This solution uses a Common Table Expression (CTE) approach in two steps:

CTE 1 - Customer Summary:

    Count total transactions per customer.

    Calculate the number of distinct active months (months in which the customer made transactions).

    Compute the average transactions per active month, handling cases where there are zero active months.

CTE 2 - Categorization:

    Classify customers into three frequency groups based on their average monthly transactions:

    High Frequency: 10 or more transactions/month

    Medium Frequency: Between 3 and 9.99 transactions/month

    Low Frequency: Fewer than 3 transactions/month

Final Select:

    Summarize counts of customers in each category.

    Calculate the average monthly transactions per customer within each category.

    Results are ordered by average monthly transactions descending.



Question 3 : Account Inactivity Alert
Task:
Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) :

Approach:
    This solution uses a Common Table Expression (CTE) to summarize the transaction history of all active plans, then filters out those accounts inactive for over a year. The steps are as follows:

Transaction Summary (CTE - tRXN_SUMMARY):

    Select each active plan from the plans_plan table (where is_a_fund = 1 for investments or is_regular_savings = 1 for savings).

    Join with the savings_savingsaccount table to get associated transactions.

    Identify the most recent transaction date per plan.

    Calculate the number of days since the last transaction using DATEDIFF().

Final Select:

    Select plans where the number of days since the last transaction exceeds 365 days.

    Return the plan ID, owner ID, plan type, last transaction date, and inactivity duration.



Question 4 : Customer Lifetime Value (CLV) Estimation
Task:
For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:


Approach:
    This solution estimates CLV by combining customer tenure, transaction count, and per-transaction profit. The steps are:

Transaction Profits (CTE - transaction_profits):

    Join the users_customuser table with savings_savingsaccount to retrieve transaction records per customer.

    Calculate each customer’s tenure in months since they joined.

    Compute the profit per transaction as 0.1% of the confirmed transaction amount.

CLV Calculation:

    For each customer:

    Count total transactions.

    Calculate average monthly transaction profit.

Estimate CLV by:

CLV = (total transactions / tenure months) × 12 × average profit per transaction

Handle cases where tenure is zero by returning CLV as zero.

Final Output:

Return customer ID, name, tenure, total transactions, and estimated CLV.

Order results by highest CLV.