-- Демонстрационные данные 3NF. Запуск один раз после 01_bakery_3nf_schema.sql
BEGIN;
INSERT INTO customer(customer_name,inn,address,phone,email) VALUES
('ООО Ромашка','7701234567','Москва, ул. Лесная, 10','+74951234567','info@romashka.ru'),
('ООО Продукты','7702345678','Москва, ул. Мира, 25','+74952345678','zakaz@produkty.ru'),
('ООО Торговый Дом','7703456789','Москва, ул. Центральная, 5','+74953456789','office@td.ru');
INSERT INTO employee(personnel_number,full_name,position) VALUES
('EMP001','Иванов Иван Иванович','Менеджер по продажам'),
('EMP002','Петров Петр Сергеевич','Специалист по работе с клиентами');
INSERT INTO product_category(category_name,description) VALUES
('Хлеб','Хлебобулочные изделия ежедневного спроса'),
('Батоны','Нарезные и традиционные батоны'),
('Выпечка','Сдобные хлебобулочные изделия');
INSERT INTO product(category_id,product_code,product_name,unit,current_price) VALUES
((SELECT category_id FROM product_category WHERE category_name='Хлеб'),'PR001','Хлеб Бородинский','шт.',65.00),
((SELECT category_id FROM product_category WHERE category_name='Хлеб'),'PR002','Хлеб Пшеничный','шт.',55.00),
((SELECT category_id FROM product_category WHERE category_name='Батоны'),'PR003','Батон Нарезной','шт.',60.00),
((SELECT category_id FROM product_category WHERE category_name='Выпечка'),'PR004','Булочка с маком','шт.',45.00);
INSERT INTO customer_order(order_number,customer_id,employee_id,delivery_date,status,comments) VALUES
('ORD001',(SELECT customer_id FROM customer WHERE inn='7701234567'),(SELECT employee_id FROM employee WHERE personnel_number='EMP001'),'2026-10-20','approved','Поставка к 9:00'),
('ORD002',(SELECT customer_id FROM customer WHERE inn='7702345678'),(SELECT employee_id FROM employee WHERE personnel_number='EMP002'),'2026-10-21','new','Ожидает подтверждения'),
('ORD003',(SELECT customer_id FROM customer WHERE inn='7703456789'),(SELECT employee_id FROM employee WHERE personnel_number='EMP001'),'2026-10-22','processing','Заказ передан в производство');
INSERT INTO order_item(order_id,product_id,quantity,unit_price) VALUES
((SELECT order_id FROM customer_order WHERE order_number='ORD001'),(SELECT product_id FROM product WHERE product_code='PR001'),100,65.00),
((SELECT order_id FROM customer_order WHERE order_number='ORD001'),(SELECT product_id FROM product WHERE product_code='PR003'),50,60.00),
((SELECT order_id FROM customer_order WHERE order_number='ORD002'),(SELECT product_id FROM product WHERE product_code='PR002'),80,55.00),
((SELECT order_id FROM customer_order WHERE order_number='ORD003'),(SELECT product_id FROM product WHERE product_code='PR004'),120,45.00);
INSERT INTO order_status_history(order_id,employee_id,old_status,new_status,reason) VALUES
((SELECT order_id FROM customer_order WHERE order_number='ORD001'),(SELECT employee_id FROM employee WHERE personnel_number='EMP001'),'new','approved','Заявка согласована'),
((SELECT order_id FROM customer_order WHERE order_number='ORD002'),(SELECT employee_id FROM employee WHERE personnel_number='EMP002'),NULL,'new','Заявка зарегистрирована'),
((SELECT order_id FROM customer_order WHERE order_number='ORD003'),(SELECT employee_id FROM employee WHERE personnel_number='EMP001'),'approved','processing','Заявка передана в производство');
COMMIT;
