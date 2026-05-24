--STEP 4: Generate Sample Transaction Data (1500+ Sales)
DO $$
DECLARE
    v_sale_id INT;
    v_branch_id INT;
    v_customer_id INT;
    v_staff_id INT;
    v_payment VARCHAR(20);
    v_item_count INT;
    v_item_id INT;
    v_qty INT;
BEGIN
    FOR i IN 1..1500 LOOP
        -- FIXED: Safe random selection
        v_branch_id := floor(random() * 3) + 1;     -- 1,2,3 only
        v_customer_id := floor(random() * 500) + 1; -- 1 to 500
        v_staff_id := floor(random() * 5) + 1;      -- 1 to 5
        
        v_payment := (ARRAY['Cash', 'UPI', 'Card', 'Wallet'])[floor(random()*4)+1];

        INSERT INTO sales (sale_date, branch_id, customer_id, staff_id, payment_method)
        VALUES (
            CURRENT_TIMESTAMP - (floor(random()*400) + 1) * INTERVAL '1 day',
            v_branch_id, 
            v_customer_id, 
            v_staff_id, 
            v_payment
        )
        RETURNING sale_id INTO v_sale_id;

        v_item_count := floor(random()*5) + 2;   -- 2 to 6 items

        FOR j IN 1..v_item_count LOOP
            v_item_id := floor(random() * 8) + 1;  -- 1 to 8 items
            v_qty := floor(random()*3) + 1;

            INSERT INTO sale_items (sale_id, item_id, quantity, unit_price)
            SELECT v_sale_id, item_id, v_qty, price 
            FROM menu_items WHERE item_id = v_item_id;
        END LOOP;

        -- Update totals
        UPDATE sales
        SET total_amount = (SELECT SUM(subtotal) FROM sale_items WHERE sale_id = v_sale_id),
            tax_amount = (SELECT SUM(subtotal) * 0.18 FROM sale_items WHERE sale_id = v_sale_id)
        WHERE sale_id = v_sale_id;
    END LOOP;
END;
$$;