-- ============================================
-- Sample Data
-- ============================================

USE ecommerce_db;

-- Countries
INSERT INTO
    countries (country_name, country_code)
VALUES ('United States', 'US'),
    ('India', 'IN'),
    ('United Kingdom', 'GB');

-- States
INSERT INTO
    states (state_name, country_id)
VALUES ('Massachusetts', 1),
    ('California', 1),
    ('Karnataka', 2),
    ('Tamil Nadu', 2);

-- Addresses
INSERT INTO
    addresses (
        street,
        city,
        zip_code,
        state_id
    )
VALUES (
        '123 Main St',
        'Boston',
        '02101',
        1
    ),
    (
        '456 Oak Ave',
        'San Francisco',
        '94102',
        2
    ),
    (
        '789 MG Road',
        'Bangalore',
        '560001',
        3
    );

-- Customers
INSERT INTO
    customers (
        first_name,
        last_name,
        email,
        phone,
        address_id
    )
VALUES (
        'Alice',
        'Johnson',
        'alice@example.com',
        '617-111-2222',
        1
    ),
    (
        'Bob',
        'Smith',
        'bob@example.com',
        '415-333-4444',
        2
    ),
    (
        'Priya',
        'Kumar',
        'priya@example.com',
        '998-555-6666',
        3
    );

-- Categories
INSERT INTO
    categories (
        category_name,
        parent_category_id
    )
VALUES ('Electronics', NULL),
    ('Clothing', NULL),
    ('Books', NULL),
    ('Laptops', 1),
    ('Smartphones', 1),
    ('Men', 2),
    ('Women', 2);

-- Suppliers
INSERT INTO
    suppliers (
        supplier_name,
        contact_email,
        phone,
        address_id
    )
VALUES (
        'TechWorld Supplies',
        'supply@techworld.com',
        '800-000-1111',
        1
    ),
    (
        'FashionHub',
        'contact@fashionhub.com',
        '800-222-3333',
        2
    );

-- Products
INSERT INTO
    products (
        product_name,
        description,
        price,
        category_id,
        supplier_id
    )
VALUES (
        'Dell XPS 15',
        '15-inch laptop with Intel i7',
        1299.99,
        4,
        1
    ),
    (
        'Samsung Galaxy S24',
        'Latest Android flagship',
        999.99,
        5,
        1
    ),
    (
        'Men\'s Casual T-Shirt',
        '100% cotton, multiple colors',
        29.99,
        6,
        2
    ),
    (
        'Women\'s Running Shoes',
        'Lightweight and breathable',
        79.99,
        7,
        2
    ),
    (
        'Introduction to SQL',
        'Beginner SQL book',
        49.99,
        3,
        1
    );

-- Inventory
INSERT INTO
    inventory (
        product_id,
        quantity_in_stock,
        reorder_level
    )
VALUES (1, 50, 10),
    (2, 120, 20),
    (3, 300, 50),
    (4, 80, 15),
    (5, 60, 10);

-- Order Statuses
INSERT INTO
    order_statuses (status_name)
VALUES ('Pending'),
    ('Processing'),
    ('Shipped'),
    ('Delivered'),
    ('Cancelled');

-- Payment Methods
INSERT INTO
    payment_methods (method_name)
VALUES ('Credit Card'),
    ('Debit Card'),
    ('PayPal'),
    ('UPI');

-- Orders
INSERT INTO
    orders (
        customer_id,
        status_id,
        shipping_address_id,
        total_amount
    )
VALUES (1, 4, 1, 1299.99),
    (2, 3, 2, 999.99),
    (3, 2, 3, 109.98);

-- Order Items
INSERT INTO
    order_items (
        order_id,
        product_id,
        quantity,
        unit_price
    )
VALUES (1, 1, 1, 1299.99),
    (2, 2, 1, 999.99),
    (3, 3, 2, 29.99),
    (3, 4, 1, 79.99);

-- Payments
INSERT INTO
    payments (
        order_id,
        method_id,
        amount,
        payment_status
    )
VALUES (1, 1, 1299.99, 'completed'),
    (2, 3, 999.99, 'completed'),
    (3, 4, 109.98, 'completed');

-- Reviews
INSERT INTO
    reviews (
        product_id,
        customer_id,
        rating,
        review_text
    )
VALUES (
        1,
        1,
        5,
        'Excellent laptop, very fast and smooth!'
    ),
    (
        2,
        2,
        4,
        'Great phone but battery could be better.'
    ),
    (
        3,
        3,
        5,
        'Good quality cotton, fits perfectly.'
    );

-- Discount Codes
INSERT INTO
    discount_codes (
        code,
        discount_percent,
        valid_from,
        valid_until,
        max_uses
    )
VALUES (
        'SAVE10',
        10.00,
        '2024-01-01',
        '2024-12-31',
        500
    ),
    (
        'WELCOME20',
        20.00,
        '2024-01-01',
        '2024-06-30',
        100
    );