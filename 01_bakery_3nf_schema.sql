-- Лабораторная работа № 1. Вариант 11. Модель 3NF (PostgreSQL 18)
-- Выполняется в базе bakery_3nf (создать через pgAdmin).
CREATE TABLE customer (
 customer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 customer_name VARCHAR(200) NOT NULL,
 inn VARCHAR(12) NOT NULL UNIQUE,
 address VARCHAR(300), phone VARCHAR(20), email VARCHAR(100)
);
CREATE TABLE employee (
 employee_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 personnel_number VARCHAR(20) NOT NULL UNIQUE,
 full_name VARCHAR(200) NOT NULL, position VARCHAR(100) NOT NULL
);
CREATE TABLE product_category (
 category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 category_name VARCHAR(100) NOT NULL UNIQUE,
 description TEXT
);
CREATE TABLE product (
 product_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 category_id INTEGER NOT NULL REFERENCES product_category(category_id),
 product_code VARCHAR(30) NOT NULL UNIQUE,
 product_name VARCHAR(200) NOT NULL, unit VARCHAR(20) NOT NULL,
 current_price NUMERIC(10,2) NOT NULL CHECK (current_price >= 0)
);
CREATE TABLE customer_order (
 order_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 order_number VARCHAR(30) NOT NULL UNIQUE,
 customer_id INTEGER NOT NULL REFERENCES customer(customer_id),
 employee_id INTEGER NOT NULL REFERENCES employee(employee_id),
 order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 delivery_date DATE NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'new'
   CHECK (status IN ('new','approved','rejected','processing','completed')),
 comments TEXT
);
CREATE TABLE order_item (
 order_item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 order_id INTEGER NOT NULL REFERENCES customer_order(order_id),
 product_id INTEGER NOT NULL REFERENCES product(product_id),
 quantity NUMERIC(10,2) NOT NULL CHECK (quantity > 0),
 unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
 UNIQUE(order_id, product_id)
);
CREATE TABLE order_status_history (
 history_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 order_id INTEGER NOT NULL REFERENCES customer_order(order_id),
 employee_id INTEGER NOT NULL REFERENCES employee(employee_id),
 old_status VARCHAR(20),
 new_status VARCHAR(20) NOT NULL
   CHECK (new_status IN ('new','approved','rejected','processing','completed')),
 changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 reason TEXT
);
