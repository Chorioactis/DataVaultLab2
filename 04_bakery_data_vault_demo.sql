-- Демонстрационная загрузка Data Vault: запуск один раз после схемы.
BEGIN;
INSERT INTO hub_customer(customer_hk,customer_bk,record_source) VALUES
(md5('7701234567'),'7701234567','bakery_3nf'),(md5('7702345678'),'7702345678','bakery_3nf'),(md5('7703456789'),'7703456789','bakery_3nf');
INSERT INTO hub_employee(employee_hk,employee_bk,record_source) VALUES
(md5('EMP001'),'EMP001','bakery_3nf'),(md5('EMP002'),'EMP002','bakery_3nf');
INSERT INTO hub_product(product_hk,product_bk,record_source) VALUES
(md5('PR001'),'PR001','bakery_3nf'),(md5('PR002'),'PR002','bakery_3nf'),(md5('PR003'),'PR003','bakery_3nf'),(md5('PR004'),'PR004','bakery_3nf');
INSERT INTO hub_order(order_hk,order_bk,record_source) VALUES
(md5('ORD001'),'ORD001','bakery_3nf'),(md5('ORD002'),'ORD002','bakery_3nf'),(md5('ORD003'),'ORD003','bakery_3nf');
INSERT INTO link_order_customer(link_hk,order_hk,customer_hk,record_source) VALUES
(md5('ORD001|7701234567'),md5('ORD001'),md5('7701234567'),'bakery_3nf'),
(md5('ORD002|7702345678'),md5('ORD002'),md5('7702345678'),'bakery_3nf'),
(md5('ORD003|7703456789'),md5('ORD003'),md5('7703456789'),'bakery_3nf');
INSERT INTO link_order_employee(link_hk,order_hk,employee_hk,record_source) VALUES
(md5('ORD001|EMP001'),md5('ORD001'),md5('EMP001'),'bakery_3nf'),
(md5('ORD002|EMP002'),md5('ORD002'),md5('EMP002'),'bakery_3nf'),
(md5('ORD003|EMP001'),md5('ORD003'),md5('EMP001'),'bakery_3nf');
INSERT INTO link_order_product(link_hk,order_hk,product_hk,record_source) VALUES
(md5('ORD001|PR001'),md5('ORD001'),md5('PR001'),'bakery_3nf'),
(md5('ORD001|PR003'),md5('ORD001'),md5('PR003'),'bakery_3nf'),
(md5('ORD002|PR002'),md5('ORD002'),md5('PR002'),'bakery_3nf'),
(md5('ORD003|PR004'),md5('ORD003'),md5('PR004'),'bakery_3nf');
INSERT INTO link_order_status_employee(link_hk,order_hk,employee_hk,record_source) VALUES
(md5('STATUS|ORD001|EMP001'),md5('ORD001'),md5('EMP001'),'bakery_3nf'),
(md5('STATUS|ORD002|EMP002'),md5('ORD002'),md5('EMP002'),'bakery_3nf'),
(md5('STATUS|ORD003|EMP001'),md5('ORD003'),md5('EMP001'),'bakery_3nf');
INSERT INTO sat_customer_details(customer_hk,customer_name,address,phone,email,hash_diff,record_source) VALUES
(md5('7701234567'),'ООО Ромашка','Москва, ул. Лесная, 10','+74951234567','info@romashka.ru',md5('ООО Ромашка|Москва, ул. Лесная, 10|+74951234567|info@romashka.ru'),'bakery_3nf'),
(md5('7702345678'),'ООО Продукты','Москва, ул. Мира, 25','+74952345678','zakaz@produkty.ru',md5('ООО Продукты|Москва, ул. Мира, 25|+74952345678|zakaz@produkty.ru'),'bakery_3nf'),
(md5('7703456789'),'ООО Торговый Дом','Москва, ул. Центральная, 5','+74953456789','office@td.ru',md5('ООО Торговый Дом|Москва, ул. Центральная, 5|+74953456789|office@td.ru'),'bakery_3nf');
INSERT INTO sat_employee_details(employee_hk,full_name,position,hash_diff,record_source) VALUES
(md5('EMP001'),'Иванов Иван Иванович','Менеджер по продажам',md5('Иванов Иван Иванович|Менеджер по продажам'),'bakery_3nf'),
(md5('EMP002'),'Петров Петр Сергеевич','Специалист по работе с клиентами',md5('Петров Петр Сергеевич|Специалист по работе с клиентами'),'bakery_3nf');
INSERT INTO sat_product_details(product_hk,product_name,category_name,unit,current_price,hash_diff,record_source) VALUES
(md5('PR001'),'Хлеб Бородинский','Хлеб','шт.',65,md5('Хлеб Бородинский|Хлеб|шт.|65.00'),'bakery_3nf'),
(md5('PR002'),'Хлеб Пшеничный','Хлеб','шт.',55,md5('Хлеб Пшеничный|Хлеб|шт.|55.00'),'bakery_3nf'),
(md5('PR003'),'Батон Нарезной','Батоны','шт.',60,md5('Батон Нарезной|Батоны|шт.|60.00'),'bakery_3nf'),
(md5('PR004'),'Булочка с маком','Выпечка','шт.',45,md5('Булочка с маком|Выпечка|шт.|45.00'),'bakery_3nf');
INSERT INTO sat_order_details(order_hk,order_date,delivery_date,status,comments,hash_diff,record_source) VALUES
(md5('ORD001'),'2026-10-13 09:00','2026-10-20','approved','Поставка к 9:00',md5('2026-10-13|2026-10-20|approved|Поставка к 9:00'),'bakery_3nf'),
(md5('ORD002'),'2026-10-13 10:00','2026-10-21','new','Ожидает подтверждения',md5('2026-10-13|2026-10-21|new|Ожидает подтверждения'),'bakery_3nf'),
(md5('ORD003'),'2026-10-13 11:00','2026-10-22','processing','Заказ передан в производство',md5('2026-10-13|2026-10-22|processing|Заказ передан в производство'),'bakery_3nf');
INSERT INTO sat_order_item(link_hk,quantity,unit_price,hash_diff,record_source) VALUES
(md5('ORD001|PR001'),100,65,md5('100|65.00'),'bakery_3nf'),
(md5('ORD001|PR003'),50,60,md5('50|60.00'),'bakery_3nf'),
(md5('ORD002|PR002'),80,55,md5('80|55.00'),'bakery_3nf'),
(md5('ORD003|PR004'),120,45,md5('120|45.00'),'bakery_3nf');
INSERT INTO sat_order_status_history(link_hk,old_status,new_status,changed_at,reason,hash_diff,record_source) VALUES
(md5('STATUS|ORD001|EMP001'),'new','approved','2026-10-13 09:30','Заявка согласована',md5('new|approved|2026-10-13 09:30:00|Заявка согласована'),'bakery_3nf'),
(md5('STATUS|ORD002|EMP002'),NULL,'new','2026-10-13 10:00','Заявка зарегистрирована',md5('NULL|new|2026-10-13 10:00:00|Заявка зарегистрирована'),'bakery_3nf'),
(md5('STATUS|ORD003|EMP001'),'approved','processing','2026-10-13 11:30','Заявка передана в производство',md5('approved|processing|2026-10-13 11:30:00|Заявка передана в производство'),'bakery_3nf');
COMMIT;
-- Демонстрация новой исторической версии; запускать отдельно, однократно.
-- INSERT INTO sat_customer_details(customer_hk,load_date,customer_name,address,phone,email,hash_diff,record_source)
-- VALUES(md5('7701234567'),CURRENT_TIMESTAMP + INTERVAL '1 second','ООО Ромашка',
-- 'Москва, ул. Новая, 15','+74951234567','info@romashka.ru',
-- md5('ООО Ромашка|Москва, ул. Новая, 15|+74951234567|info@romashka.ru'),'manual_update');
