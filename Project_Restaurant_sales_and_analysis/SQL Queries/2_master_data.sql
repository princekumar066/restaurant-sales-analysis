-- STEP 2 : Insert Basic Master Data
INSERT INTO branches (branch_name, location, manager_name) VALUES 
('Connaught Place', 'Delhi', 'Rahul Sharma'),
('South Extension', 'Delhi', 'Priya Singh'),
('Karol Bagh', 'Delhi', 'Amit Verma');

-- Categories
INSERT INTO menu_categories (category_name) VALUES 
('Starters'), ('Main Course'), ('Beverages'), ('Desserts'), ('Breads');

-- Menu Items (8 items)
INSERT INTO menu_items (item_name, category_id, price, cost_price) VALUES
('Paneer Tikka', 1, 320.00, 180.00),
('Butter Chicken', 2, 420.00, 250.00),
('Dal Makhani', 2, 280.00, 120.00),
('Masala Dosa', 2, 180.00, 80.00),
('Mango Lassi', 3, 120.00, 60.00),
('Gulab Jamun', 4, 150.00, 70.00),
('Butter Naan', 5, 60.00, 25.00),
('Veg Biryani', 2, 350.00, 180.00);

-- Staff (5 staff)
INSERT INTO staff (staff_name, branch_id, role) VALUES
('Ramesh Kumar', 1, 'Waiter'),
('Suresh Yadav', 1, 'Chef'),
('Neha Gupta', 2, 'Manager'),
('Amit Sharma', 2, 'Waiter'),
('Pooja Verma', 3, 'Cashier');

-- Customers (500 customers)
INSERT INTO customers (customer_name, phone, email, join_date)
SELECT 
    'Customer ' || i,
    '98' || floor(random()*90000000)::text,
    'cust' || i || '@gmail.com',
    CURRENT_DATE - (random()*365)::int
FROM generate_series(1,500) i;