-- Лабораторная работа № 1. Вариант 11. Data Vault 2.0 (PostgreSQL 18)
-- Выполняется в базе bakery_data_vault (создать через pgAdmin).
-- HUB: устойчивые бизнес-ключи
CREATE TABLE hub_customer (
 customer_hk CHAR(32) PRIMARY KEY, customer_bk VARCHAR(12) NOT NULL UNIQUE,
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 record_source VARCHAR(100) NOT NULL
);
CREATE TABLE hub_employee (
 employee_hk CHAR(32) PRIMARY KEY, employee_bk VARCHAR(20) NOT NULL UNIQUE,
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 record_source VARCHAR(100) NOT NULL
);
CREATE TABLE hub_product (
 product_hk CHAR(32) PRIMARY KEY, product_bk VARCHAR(30) NOT NULL UNIQUE,
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 record_source VARCHAR(100) NOT NULL
);
CREATE TABLE hub_order (
 order_hk CHAR(32) PRIMARY KEY, order_bk VARCHAR(30) NOT NULL UNIQUE,
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 record_source VARCHAR(100) NOT NULL
);
-- LINK: бизнес-связи между хабами
CREATE TABLE link_order_customer (
 link_hk CHAR(32) PRIMARY KEY,
 order_hk CHAR(32) NOT NULL REFERENCES hub_order(order_hk),
 customer_hk CHAR(32) NOT NULL REFERENCES hub_customer(customer_hk),
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 record_source VARCHAR(100) NOT NULL, UNIQUE(order_hk, customer_hk)
);
CREATE TABLE link_order_employee (
 link_hk CHAR(32) PRIMARY KEY,
 order_hk CHAR(32) NOT NULL REFERENCES hub_order(order_hk),
 employee_hk CHAR(32) NOT NULL REFERENCES hub_employee(employee_hk),
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 record_source VARCHAR(100) NOT NULL, UNIQUE(order_hk, employee_hk)
);
CREATE TABLE link_order_product (
 link_hk CHAR(32) PRIMARY KEY,
 order_hk CHAR(32) NOT NULL REFERENCES hub_order(order_hk),
 product_hk CHAR(32) NOT NULL REFERENCES hub_product(product_hk),
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 record_source VARCHAR(100) NOT NULL, UNIQUE(order_hk, product_hk)
);
CREATE TABLE link_order_status_employee (
 link_hk CHAR(32) PRIMARY KEY,
 order_hk CHAR(32) NOT NULL REFERENCES hub_order(order_hk),
 employee_hk CHAR(32) NOT NULL REFERENCES hub_employee(employee_hk),
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 record_source VARCHAR(100) NOT NULL, UNIQUE(order_hk, employee_hk)
);
-- SATELLITE: описательные атрибуты и версии
CREATE TABLE sat_customer_details (
 customer_hk CHAR(32) NOT NULL REFERENCES hub_customer(customer_hk),
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 customer_name VARCHAR(200) NOT NULL, address VARCHAR(300),
 phone VARCHAR(20), email VARCHAR(100), hash_diff CHAR(32),
 record_source VARCHAR(100) NOT NULL, PRIMARY KEY(customer_hk,load_date)
);
CREATE TABLE sat_employee_details (
 employee_hk CHAR(32) NOT NULL REFERENCES hub_employee(employee_hk),
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 full_name VARCHAR(200) NOT NULL, position VARCHAR(100) NOT NULL,
 hash_diff CHAR(32), record_source VARCHAR(100) NOT NULL,
 PRIMARY KEY(employee_hk,load_date)
);
CREATE TABLE sat_product_details (
 product_hk CHAR(32) NOT NULL REFERENCES hub_product(product_hk),
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 product_name VARCHAR(200) NOT NULL, category_name VARCHAR(100) NOT NULL,
 unit VARCHAR(20) NOT NULL, current_price NUMERIC(10,2) NOT NULL
   CHECK(current_price >= 0), hash_diff CHAR(32),
 record_source VARCHAR(100) NOT NULL, PRIMARY KEY(product_hk,load_date)
);
CREATE TABLE sat_order_details (
 order_hk CHAR(32) NOT NULL REFERENCES hub_order(order_hk),
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 order_date TIMESTAMP NOT NULL, delivery_date DATE NOT NULL,
 status VARCHAR(20) NOT NULL
   CHECK(status IN ('new','approved','rejected','processing','completed')),
 comments TEXT, hash_diff CHAR(32), record_source VARCHAR(100) NOT NULL,
 PRIMARY KEY(order_hk,load_date)
);
CREATE TABLE sat_order_item (
 link_hk CHAR(32) NOT NULL REFERENCES link_order_product(link_hk),
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 quantity NUMERIC(10,2) NOT NULL CHECK(quantity > 0),
 unit_price NUMERIC(10,2) NOT NULL CHECK(unit_price >= 0),
 hash_diff CHAR(32), record_source VARCHAR(100) NOT NULL,
 PRIMARY KEY(link_hk,load_date)
);
CREATE TABLE sat_order_status_history (
 link_hk CHAR(32) NOT NULL REFERENCES link_order_status_employee(link_hk),
 load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 old_status VARCHAR(20),
 new_status VARCHAR(20) NOT NULL
   CHECK(new_status IN ('new','approved','rejected','processing','completed')),
 changed_at TIMESTAMP NOT NULL, reason TEXT,
 hash_diff CHAR(32), record_source VARCHAR(100) NOT NULL,
 PRIMARY KEY(link_hk,load_date)
);
