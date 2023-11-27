USE QuantigrationRMA;

SHOW TABLES;

-- 1. Import the data from each file into tables.
--      - I had trouble pointing to the file customers.csv file. In Linux bash, ran "readlink -f customers.csv"
--      which produced '/home/codio/workspace/customers.csv'
LOAD DATA INFILE '/home/codio/workspace/customers.csv'
INTO TABLE Customers
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE '/home/codio/workspace/orders.csv'
INTO TABLE Orders
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE '/home/codio/workspace/rma.csv'
INTO TABLE RMA
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n';


-- 2. Write basic queries against imported tables to organize and analyze targeted data.
DESCRIBE Customers;

-- B.
SELECT COUNT(*)
FROM Customers
WHERE City = 'Framingham' AND ( State = 'Massachusetts' OR State = 'MA');

-- C.
SELECT COUNT(*)
FROM Customers
WHERE State = 'Massachusetts' OR State = 'MA';

-- D.
INSERT INTO Customers
VALUES
    (100004,'Luke','Skywalker','17 Maiden Lane','New York','NY','10222','212-555-1234'),
    (100005,'Winston','Smith','128 Sycamore Street','Greensboro','NC','27401','919-555-6623'),
    (100006,'MaryAnne','Jenkins','2 Coconut Way','Jupiter','FL','33458','321-555-8907'),
    (100007,'Janet','Williams','58 Redondo Beach Blvd','Torrence','CA','90501','310-555-5678');

INSERT INTO Orders
VALUES
    (1204305,100004,'ADV-24-10C','Advanced Switch 10GigE Copper 4 port'),
    (1204306,100005,'ADV-48-10F','Advanced Switch 10 GigE Copper/Fiber 44 port copper 4 port fiber'),
    (1204307,100006,'ENT-24-10F','Enterprise Switch 10GigE SFP+ 24 Port'),
    (1204308,100007,'ENT-48-10F','Enterprise Switch 10GigE SPF+ 48 port');

-- E.
SELECT COUNT(*)
FROM Customers
WHERE City = 'Woonsocket';

-- F.
--      i.
SELECT Status, Step
FROM RMA
WHERE OrderID = 5175;

--      ii.
UPDATE RMA
SET Status = 'Complete', Step = 'Credit Customer Account'
WHERE OrderID = 5175;

SELECT Status, Step
FROM RMA
WHERE OrderID = 5175;


-- G.
SELECT COUNT(*)
FROM RMA
WHERE Reason LIKE '%Rejected%';

DELETE FROM RMA
WHERE Reason LIKE '%Rejected%';


-- 3. Create an output file of the required query results.
SELECT *
FROM Orders
INTO OUTFILE '/home/codio/workspace/QuantigrationRMA_Orders.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
