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


CREATE TRIGGER purchaseUpdateInventory
AFTER INSERT ON customer_purchases
FOR EACH ROW
	UPDATE inventory
		SET number_in_stock = number_in_stock - 1
     WHERE inventory_id =NEW.inventory_id;
  

CREATE TABLE purchase_summary(
	purchase_summary_id INT,
    customer_id INT,
    total_purchases INT,
    purchase_excluding_last INT
);
   
    
