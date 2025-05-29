
----- Task 3 Project: Online Store Order Management System 

CREATE DATABASE online_store;
USE online_store;

CREATE TABLE Customers (
  CUSTOMER_ID INT AUTO_INCREMENT PRIMARY KEY,
  NAME        VARCHAR(100),
  EMAIL       VARCHAR(100),
  PHONE       VARCHAR(15),
  ADDRESS     VARCHAR(255)
)

CREATE TABLE Products (
  PRODUCT_ID   INT AUTO_INCREMENT PRIMARY KEY,
  PRODUCT_NAME VARCHAR(100),
  CATEGORY     VARCHAR(50),
  PRICE        DECIMAL(10,2),
  STOCK        INT
) 

CREATE TABLE Orders (
  ORDER_ID    INT AUTO_INCREMENT PRIMARY KEY,
  CUSTOMER_ID INT,
  PRODUCT_ID  INT,
  QUANTITY    INT,
  ORDER_DATE  DATE,
  CONSTRAINT fk_cust FOREIGN KEY (CUSTOMER_ID) REFERENCES Customers (CUSTOMER_ID),
  CONSTRAINT fk_prod FOREIGN KEY (PRODUCT_ID)  REFERENCES Products  (PRODUCT_ID)
) 

--- Customers

INSERT INTO Customers (NAME, EMAIL, PHONE, ADDRESS) VALUES
  ('Ganesh Chennai',  'ganesh.c@buy.in',    '9200000001', 'Guindy, Chennai'),
  ('Janani Ravi',     'janani.r@buy.in',    '9200000002', 'Nungambakkam, Chennai'),
  ('Sathish Kumar',   'sathish.k@buy.in',   '9200000003', 'Tambaram, Chennai'),
  ('Aishwarya',       'aishwarya.m@buy.in', '9200000004', 'Adyar, Chennai'),
  ('Rajeshwari',      'rajeshwari@buy.in',  '9200000005', 'Kodambakkam, Chennai');
  
  -- Products
INSERT INTO Products (PRODUCT_NAME, CATEGORY, PRICE, STOCK) VALUES
  ('Wireless Mouse', 'Electronics', 499.00, 50),
  ('USB-C Cable',    'Electronics', 199.00,  0),
  ('Plain T-Shirt',  'Clothing',    299.00, 30),
  ('SQL Handbook',   'Books',       399.00, 15),
  ('Coffee Mug',     'Home',        149.00, 25);
  
  -- Orders
INSERT INTO Orders (CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE) VALUES
  (1, 1, 2, '2024-11-01'),
  (2, 4, 1, '2024-11-02'),
  (3, 5, 4, '2024-12-15'),
  (1, 3, 3, '2025-01-04'),
  (4, 1, 1, '2025-02-20'),
  (5, 2, 1, '2025-03-10'),
  (2, 3, 2, '2025-03-12'),
  (3, 1, 1, '2025-04-18');
  
  Select * from customers
  Select * from products
  Select * from orders
  
  ---- a) Retrieve all orders placed by a specific customer.
  SELECT * FROM Orders WHERE CUSTOMER_ID = 1;

--- b) Find products that are out of stock.

SELECT * FROM Products WHERE STOCK = 0;

----- c) Calculate the total revenue generated per product.

SELECT p.PRODUCT_NAME,
       SUM(o.QUANTITY * p.PRICE) AS revenue
FROM   Products p
JOIN   Orders   o USING (PRODUCT_ID)
GROUP  BY p.PRODUCT_ID
ORDER  BY revenue DESC;

------ d) Retrieve the top 5 customers by total purchase amount.
SELECT c.NAME,
       SUM(o.QUANTITY * p.PRICE) AS total_spent
FROM   Customers c
JOIN   Orders    o USING (CUSTOMER_ID)
JOIN   Products  p USING (PRODUCT_ID)
GROUP  BY c.CUSTOMER_ID
ORDER  BY total_spent DESC
LIMIT 5;

-----e) Find customers who placed orders in at least two different product categories.

SELECT c.NAME
FROM   Customers c
JOIN   Orders    o USING (CUSTOMER_ID)
JOIN   Products  p USING (PRODUCT_ID)
GROUP  BY c.CUSTOMER_ID
HAVING COUNT(DISTINCT p.CATEGORY) >= 2;


----- a) Find the month with the highest total sales.
SELECT DATE_FORMAT(ORDER_DATE, '%Y-%m') AS month,
       SUM(o.QUANTITY * p.PRICE)        AS total_sales
FROM   Orders o
JOIN   Products p USING (PRODUCT_ID)
GROUP  BY month
ORDER  BY total_sales DESC
LIMIT 1;

----- b) Identify products with no orders in the last 6 months.

SELECT p.*
FROM   Products p
LEFT  JOIN Orders o
       ON  p.PRODUCT_ID = o.PRODUCT_ID
       AND o.ORDER_DATE >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
WHERE  o.ORDER_ID IS NULL;

------ c) Retrieve customers who have never placed an order.
SELECT c.*
FROM   Customers c
LEFT  JOIN Orders o USING (CUSTOMER_ID)
WHERE  o.ORDER_ID IS NULL;

------- d) Calculate the average order value across all orders.

SELECT AVG(order_total) AS average_order_value
FROM (
  SELECT SUM(p.PRICE * o.QUANTITY) AS order_total
  FROM   Orders   o
  JOIN   Products p USING (PRODUCT_ID)
  GROUP  BY o.ORDER_ID
) x;
