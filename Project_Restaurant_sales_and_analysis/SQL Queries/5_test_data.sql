--STEP 5: Test the Data
SELECT COUNT(*) FROM sales;           -- Should show ~1500
SELECT COUNT(*) FROM sale_items;      -- Should show ~4500-6000
SELECT * FROM branches;               -- Verify branch_id 1-3





--STEP 6: Important Analysis Queries
-- Monthly Sales Trend
SELECT DATE_TRUNC('month', sale_date) AS month, 
       COUNT(*) AS orders, 
       SUM(total_amount) AS revenue,
       ROUND(AVG(total_amount),2) AS avg_bill
FROM sales GROUP BY 1 ORDER BY 1;

-- Top 10 Items
SELECT mi.item_name, SUM(si.quantity) AS qty_sold, SUM(si.subtotal) AS revenue
FROM sale_items si
JOIN menu_items mi ON si.item_id = mi.item_id
GROUP BY mi.item_name ORDER BY revenue DESC LIMIT 10;

-- Branch Performance
SELECT b.branch_name, COUNT(s.sale_id) AS orders, SUM(s.total_amount) AS revenue
FROM branches b LEFT JOIN sales s ON b.branch_id = s.branch_id
GROUP BY b.branch_name;





--STEP 7: Final Testing & Usage
CALL record_sale(1, 5, 2, 'UPI', 
    '[{"item_id":1,"quantity":2},{"item_id":3,"quantity":1}]'::jsonb);


