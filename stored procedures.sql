-- ============================================
-- Stored Procedures
-- ============================================

USE ecommerce_db;

DELIMITER $$

-- 1. Place an Order
-- Inserts order + order items, deducts inventory, calculates total
CREATE PROCEDURE place_order(
    IN p_customer_id INT,
    IN p_shipping_address_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_method_id INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_order_id INT;
    DECLARE v_total DECIMAL(10,2);

    -- Get product price
    SELECT price INTO v_price FROM products WHERE product_id = p_product_id;

    -- Check stock
    SELECT quantity_in_stock INTO v_stock FROM inventory WHERE product_id = p_product_id;

    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for this product.';
    ELSE
        -- Calculate total
        SET v_total = v_price * p_quantity;

        -- Create order
        INSERT INTO orders (customer_id, status_id, shipping_address_id, total_amount)
        VALUES (p_customer_id, 1, p_shipping_address_id, v_total);

        SET v_order_id = LAST_INSERT_ID();

        -- Add order item
        INSERT INTO order_items (order_id, product_id, quantity, unit_price)
        VALUES (v_order_id, p_product_id, p_quantity, v_price);

        -- Deduct inventory
        UPDATE inventory
        SET quantity_in_stock = quantity_in_stock - p_quantity
        WHERE product_id = p_product_id;

        -- Create payment record
        INSERT INTO payments (order_id, method_id, amount, payment_status)
        VALUES (v_order_id, p_method_id, v_total, 'completed');

        SELECT v_order_id AS order_id, v_total AS total_amount;
    END IF;
END$$

-- 2. Update Inventory Stock
CREATE PROCEDURE restock_product(
    IN p_product_id INT,
    IN p_quantity_to_add INT
)
BEGIN
    UPDATE inventory
    SET quantity_in_stock = quantity_in_stock + p_quantity_to_add
    WHERE product_id = p_product_id;

    -- Resolve any open alerts for this product
    UPDATE low_inventory_alerts
    SET resolved = TRUE
    WHERE product_id = p_product_id AND resolved = FALSE;

    SELECT CONCAT('Stock updated for product ID: ', p_product_id) AS message;
END$$

-- 3. Cancel Order and Restore Inventory
CREATE PROCEDURE cancel_order(
    IN p_order_id INT
)
BEGIN
    DECLARE v_product_id INT;
    DECLARE v_quantity INT;

    -- Get order item details
    SELECT product_id, quantity INTO v_product_id, v_quantity
    FROM order_items WHERE order_id = p_order_id LIMIT 1;

    -- Update order status to cancelled (assuming status_id 5 = Cancelled)
    UPDATE orders SET status_id = 5 WHERE order_id = p_order_id;

    -- Restore inventory
    UPDATE inventory
    SET quantity_in_stock = quantity_in_stock + v_quantity
    WHERE product_id = v_product_id;

    -- Update payment status to refunded
    UPDATE payments SET payment_status = 'refunded' WHERE order_id = p_order_id;

    SELECT CONCAT('Order ', p_order_id, ' cancelled and inventory restored.') AS message;
END$$

DELIMITER;