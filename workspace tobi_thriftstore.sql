CREATE SCHEMA tobi_thriftstore;
USE tobi_thriftstore;

CREATE TABLE customers(
	customer_id INT  NOT NULL PRIMARY KEY,
    first_name VARCHAR(25),
    last_name VARCHAR(25)
);
CREATE TABLE inventory(
	inventory_id INT NOT NULL PRIMARY KEY,
    item_name VARCHAR(50),
    number_in_stock INT
);
CREATE TABLE customer_purchases(
	customer_purchases_id INT NOT NULL PRIMARY KEY,
    purchase_amount DECIMAL(10,2),
    customer_id INT,
    inventory_id INT
);
ALTER TABLE customer_purchases
ADD FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE CASCADE;

ALTER TABLE customer_purchases
ADD FOREIGN KEY (inventory_id)
REFERENCES inventory(inventory_id)
ON DELETE CASCADE;

INSERT INTO customers VALUES (01, 'Oba', 'Jude');
INSERT INTO customers VALUES (02, 'Aree', 'Amina');
INSERT INTO customers VALUES (03, 'Hakeem', 'Mustapha');
INSERT INTO customers VALUES (04, 'Oriade', 'Jake');
INSERT INTO customers VALUES (05, 'Daniel', 'Ross');

INSERT INTO inventory VALUES (100, 'Leather Jacket', 5);
INSERT INTO inventory VALUES (101, 'Blue Jean', 7);
INSERT INTO inventory VALUES (102, 'Swim Suit', 7);
INSERT INTO inventory VALUES (103, 'Head-tie', 4);

INSERT INTO customer_purchases VALUES (20, 6000, 02, 101);
INSERT INTO customer_purchases VALUES (21, 4500, 01, 102);
INSERT INTO customer_purchases VALUES (22, 6700, 03, 101);
INSERT INTO customer_purchases VALUES (23, 10000, 02, 100);

SELECT * FROM customer_purchases;
SELECT * FROM inventory;

CREATE TRIGGER purchaseUpdateInventory
AFTER INSERT ON customer_purchases
FOR EACH ROW
	UPDATE inventory
		SET number_in_stock = number_in_stock - 1
     WHERE inventory_id =NEW.inventory_id;
     
INSERT INTO customer_purchases VALUES (24, 9000, 04, 103);
INSERT INTO customer_purchases VALUES (25, 10000, 04, 100);

INSERT INTO inventory VALUES
(105, 'Aphrodite Jean', 15),
(106, 'Night-Wear', 10),
(107, 'Bra', 25),
(108, 'Jean Jacket', 10),
(109, 'Pallazo', 5),
(110, 'Mama-Jean', 20);

INSERT INTO customer_purchases VALUES (26, 900, 02, 107);     
INSERT INTO customer_purchases VALUES (27, 3000, 03, 110);

CREATE TABLE purchase_summary(
	purchase_summary_id INT,
    customer_id INT,
    total_purchases INT,
    purchase_excluding_last INT
);
    INSERT INTO purchase_summary VALUES
    (1, 1, 1, 0),
    (2, 2, 3, 2),
    (3, 3, 2, 1),
    (4, 4, 2, 1);
    
CREATE TRIGGER purchaseUpdatePurchaseSumary_after
AFTER INSERT
ON customer_purchases
FOR EACH ROW
PRECEDES purchaseUpdateInventory
UPDATE purchase_summary
	SET total_purchases = (
	SELECT COUNT(customer_purchases_id)
	FROM customer_purchases
	WHERE customer_purchases.customer_id = purchase_summary.customer_id)
WHERE customer_id = NEW.customer_id
AND purchase_summary_id > 0;

DROP TRIGGER purchaseUpdatePurchaseSummary_after;

CREATE TRIGGER purchaseUpdatePurchaseSumary_before
BEFORE INSERT
ON customer_purchases
FOR EACH ROW
UPDATE purchase_summary
	SET purchase_excluding_last = (
	SELECT COUNT(customer_purchases_id)
	FROM customer_purchases
	WHERE customer_purchases.customer_id = purchase_summary.customer_id)
WHERE customer_id = NEW.customer_id
AND purchase_summary_id > 0;


select * from customer_purchases;
select * from inventory;
select * from purchase_summary;

INSERT INTO customer_purchases VALUES (26, 900, 02, 107);

INSERT INTO customer_purchases VALUES (28, 900, 03, 107);
INSERT INTO customer_purchases VALUES (30, 900, 05, 107);
INSERT INTO customer_purchases VALUES (31, 3000, 04, 110);
INSERT INTO customer_purchases VALUES (32, 3000, 02, 110);
INSERT INTO customer_purchases VALUES (33, 900, 01, 107);