--STEP 3: Create PL/pgSQL Procedure
CREATE OR REPLACE PROCEDURE record_sale(
    p_branch_id INT,
    p_customer_id INT,
    p_staff_id INT,
    p_payment_method VARCHAR,
    p_items JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_sale_id INT;
    v_item JSONB;
BEGIN
    INSERT INTO sales (branch_id, customer_id, staff_id, payment_method)
    VALUES (p_branch_id, p_customer_id, p_staff_id, p_payment_method)
    RETURNING sale_id INTO v_sale_id;

    FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
    LOOP
        INSERT INTO sale_items (sale_id, item_id, quantity, unit_price)
        SELECT v_sale_id, (v_item->>'item_id')::INT, (v_item->>'quantity')::INT, price
        FROM menu_items WHERE item_id = (v_item->>'item_id')::INT;
    END LOOP;

    UPDATE sales
    SET total_amount = (SELECT SUM(subtotal) FROM sale_items WHERE sale_id = v_sale_id),
        tax_amount = (SELECT SUM(subtotal) * 0.18 FROM sale_items WHERE sale_id = v_sale_id)
    WHERE sale_id = v_sale_id;

    IF p_customer_id IS NOT NULL THEN
        UPDATE customers SET total_visits = total_visits + 1 
        WHERE customer_id = p_customer_id;
    END IF;

    COMMIT;
END;
$$;