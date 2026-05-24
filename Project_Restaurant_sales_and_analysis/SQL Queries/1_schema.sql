-- STEP 1 : Create Tables
CREATE TABLE branches (
    branch_id SERIAL PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    manager_name VARCHAR(100),
    opening_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE menu_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE menu_items (
    item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(150) NOT NULL,
    category_id INT REFERENCES menu_categories(category_id),
    price NUMERIC(10,2) NOT NULL,
    cost_price NUMERIC(10,2),
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    join_date DATE DEFAULT CURRENT_DATE,
    total_visits INT DEFAULT 0
);

CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    staff_name VARCHAR(100) NOT NULL,
    branch_id INT REFERENCES branches(branch_id),
    role VARCHAR(50),
    hire_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    branch_id INT REFERENCES branches(branch_id),
    customer_id INT REFERENCES customers(customer_id),
    staff_id INT REFERENCES staff(staff_id),
    total_amount NUMERIC(12,2) DEFAULT 0,
    tax_amount NUMERIC(10,2) DEFAULT 0,
    discount_amount NUMERIC(10,2) DEFAULT 0,
    payment_method VARCHAR(30)
);

CREATE TABLE sale_items (
    sale_item_id SERIAL PRIMARY KEY,
    sale_id INT REFERENCES sales(sale_id) ON DELETE CASCADE,
    item_id INT REFERENCES menu_items(item_id),
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    subtotal NUMERIC(12,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

