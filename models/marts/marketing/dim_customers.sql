with customers as (
    select * from {{ ref('stg_jaffle_shop_customers') }}
),
orders as (
    select * from {{ ref('fct_orders') }}
)

,employees as (
    select * from {{ ref('employees') }}
    )

,customer_orders as (
    select
        customer_id,
        min (order_date) as first_order_date,
        max (order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value
    from orders
    group by 1
),

 final as (
SELECT
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customer_orders.first_order_date,
    customer_orders.most_recent_order_date,
    COALESCE(customer_orders.number_of_orders, 0) AS number_of_orders,
    customer_orders.lifetime_value,
    employees.employee_id,
    employees.email
FROM customers
LEFT JOIN customer_orders USING (customer_id)
LEFT JOIN employees 
    ON employees.customer_id = customers.customer_id

)
select * from final