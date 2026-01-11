CREATE DATABASE testDb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE testDb;

CREATE TABLE item (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price INT NOT NULL
);

CREATE TABLE orders (
    order_no VARCHAR(10) PRIMARY KEY,
    item_id INT NOT NULL,
    qty INT NOT NULL,
    price INT NOT NULL,
    CONSTRAINT fk_orders_item
        FOREIGN KEY (item_id)
        REFERENCES item(id)
        ON DELETE CASCADE
);

CREATE TABLE inventory (
    id INT PRIMARY KEY,
    item_id INT NOT NULL,
    qty INT NOT NULL,
    type CHAR(1) NOT NULL CHECK (type IN ('T', 'W')),
    CONSTRAINT fk_inventory_item
        FOREIGN KEY (item_id)
        REFERENCES item(id)
        ON DELETE CASCADE
);

INSERT INTO item (id, name, price) VALUES
(1, 'Pen', 5),
(2, 'Book', 10),
(3, 'Bag', 30),
(4, 'Pencil', 3),
(5, 'Shoe', 45),
(6, 'Box', 5),
(7, 'Cap', 25);

INSERT INTO orders (order_no, item_id, qty, price) VALUES
('O1', 1, 2, 5),
('O2', 2, 3, 10),
('O3', 5, 4, 45),
('O4', 4, 1, 2),
('O5', 5, 2, 45),
('O6', 6, 3, 5),
('O7', 1, 5, 5),
('O8', 2, 4, 10),
('O9', 3, 2, 30),
('O10', 4, 3, 3);

INSERT INTO inventory (id, item_id, qty, type) VALUES
(1, 1, 5, 'T'),
(2, 2, 10, 'T'),
(3, 3, 30, 'T'),
(4, 4, 3, 'T'),
(5, 5, 45, 'T'),
(6, 6, 5, 'T'),
(7, 7, 25, 'T'),
(8, 4, 7, 'T');

INSERT INTO inventory (id, item_id, qty, type) VALUES
(9, 5, 10, 'W');

ALTER TABLE orders DROP FOREIGN KEY fk_orders_item;
ALTER TABLE inventory DROP FOREIGN KEY fk_inventory_item;

ALTER TABLE item MODIFY id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE inventory MODIFY id INT NOT NULL AUTO_INCREMENT;

ALTER TABLE orders ADD CONSTRAINT fk_orders_item FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE;
ALTER TABLE inventory ADD CONSTRAINT fk_inventory_item FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE;

SELECT * FROM item;
SELECT * FROM orders;
SELECT * FROM inventory;

SELECT
    item_id,
    SUM(
        CASE
            WHEN type = 'T' THEN qty
            WHEN type = 'W' THEN -qty
            ELSE 0
        END
    ) AS remaining_stock
FROM inventory
GROUP BY item_id;

SELECT * FROM orders ORDER BY created_at DESC;


