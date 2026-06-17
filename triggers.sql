-- ============================================
-- Triggers
-- ============================================

USE ecommerce_db;

DELIMITER $$

-- 1. After an order item is inserted, deduct inventory
--    and flag low stock if below reorder level
CREATE TRIGGER after_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE v_current_stock INT;
    DECLARE v_reorder_level INT;

    -- Deduct stock
    UPDATE inventory
    SET quantity_in_stock = quantity_in_stock - NEW.quantity
    WHERE product_id = NEW.product_id;

    -- Get updated stock and reorder level
    SELECT quantity_in_stock, reorder_level
    INTO v_current_stock, v_reorder_level
    FROM inventory WHERE product_id = NEW.product_id;

    -- Flag low inventory alert if below reorder level
    IF v_current_stock <= v_reorder_level THEN
        INSERT INTO low_inventory_alerts (product_id, quantity_at_alert)
        VALUES (NEW.product_id, v_current_stock);
    END IF;
END$$

-- 2. After inventory is updated (restock), auto-resolve alerts
CREATE TRIGGER after_inventory_update
AFTER UPDATE ON inventory
FOR EACH ROW
BEGIN
    IF NEW.quantity_in_stock > NEW.reorder_level THEN
        UPDATE low_inventory_alerts
        SET resolved = TRUE
        WHERE product_id = NEW.product_id AND resolved = FALSE;
    END IF;
END$$

-- 3. Before deleting a customer, ensure no active orders exist
CREATE TRIGGER before_customer_delete
BEFORE DELETE ON customers
FOR EACH ROW
BEGIN
    DECLARE v_active_orders INT;

    SELECT COUNT(*) INTO v_active_orders
    FROM orders
    WHERE customer_id = OLD.customer_id
      AND status_id NOT IN (4, 5); -- 4 = Delivered, 5 = Cancelled

    IF v_active_orders > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete customer with active orders.';
    END IF;
END$$

-- 4. Auto-update order total when an order item is added
CREATE TRIGGER update_order_total
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET total_amount = (
        SELECT SUM(quantity * unit_price)
        FROM order_items
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END$$

DELIMITER;