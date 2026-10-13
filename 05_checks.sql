-- Проверка заявок в 3NF (запустить в bakery_3nf)
SELECT o.order_number,c.customer_name,e.full_name,o.delivery_date,o.status,
 COUNT(oi.order_item_id) AS positions, SUM(oi.quantity*oi.unit_price) AS amount
FROM customer_order o JOIN customer c ON c.customer_id=o.customer_id
JOIN employee e ON e.employee_id=o.employee_id
JOIN order_item oi ON oi.order_id=o.order_id
GROUP BY o.order_id,o.order_number,c.customer_name,e.full_name,o.delivery_date,o.status
ORDER BY o.order_number;

-- Проверка Data Vault с учетом исторических версий (запустить в bakery_data_vault)
WITH latest_customers AS (
 SELECT DISTINCT ON(customer_hk) customer_hk,customer_name,address
 FROM sat_customer_details ORDER BY customer_hk,load_date DESC
), latest_employees AS (
 SELECT DISTINCT ON(employee_hk) employee_hk,full_name
 FROM sat_employee_details ORDER BY employee_hk,load_date DESC
), latest_orders AS (
 SELECT DISTINCT ON(order_hk) order_hk,delivery_date,status
 FROM sat_order_details ORDER BY order_hk,load_date DESC
), latest_items AS (
 SELECT DISTINCT ON(link_hk) link_hk,quantity,unit_price
 FROM sat_order_item ORDER BY link_hk,load_date DESC
)
SELECT ho.order_bk AS order_number,lc.customer_name,lc.address,le.full_name,
 lo.delivery_date,lo.status,COUNT(lop.link_hk) AS positions,
 SUM(li.quantity*li.unit_price) AS amount
FROM hub_order ho
JOIN link_order_customer loc ON ho.order_hk=loc.order_hk
JOIN latest_customers lc ON loc.customer_hk=lc.customer_hk
JOIN link_order_employee loe ON ho.order_hk=loe.order_hk
JOIN latest_employees le ON loe.employee_hk=le.employee_hk
JOIN latest_orders lo ON ho.order_hk=lo.order_hk
JOIN link_order_product lop ON ho.order_hk=lop.order_hk
JOIN latest_items li ON lop.link_hk=li.link_hk
GROUP BY ho.order_bk,lc.customer_name,lc.address,le.full_name,lo.delivery_date,lo.status
ORDER BY ho.order_bk;
