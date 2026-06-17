-- ============================================
-- Indexes for Query Performance Optimization
-- ============================================

USE ecommerce_db;

-- Customer lookups by email (login/search)
CREATE INDEX idx_customers_email ON customers (email);

-- Product lookups by category (browsing/filtering)
CREATE INDEX idx_products_category ON products (category_id);

-- Order lookups by customer ID (order history)
CREATE INDEX idx_orders_customer ON orders (customer_id);

-- Order lookups by status (admin dashboards)
CREATE INDEX idx_orders_status ON orders (status_id);

-- Order items by order ID (fetching cart/order details)
CREATE INDEX idx_order_items_order ON order_items (order_id);

-- Order items by product ID (sales analytics)
CREATE INDEX idx_order_items_product ON order_items (product_id);

-- Payments by order ID
CREATE INDEX idx_payments_order ON payments (order_id);

-- Reviews by product ID (product rating lookups)
CREATE INDEX idx_reviews_product ON reviews (product_id);

-- Low inventory alerts by product and resolved status
CREATE INDEX idx_alerts_product_resolved ON low_inventory_alerts (product_id, resolved);

-- Discount codes by validity dates
CREATE INDEX idx_discounts_validity ON discount_codes (valid_from, valid_until);