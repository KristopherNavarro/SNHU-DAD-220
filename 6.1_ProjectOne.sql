-- noinspection SqlNoDataSourceInspectionForFile

--  STEP 1  --
--      1. (navigate to Codio)
--      2. Create 'QuantigrationUpdates' database
CREATE DATABASE QuantigrationUpdates;

            --  List the databases
SHOW DATABASES;


--      3. Using the Entity Relationship Diagram (ERD) create tables:
USE QuantigrationUpdates;

        --  a.  A table to store customer information with a primary key of Customer ID
CREATE TABLE Customers (
    CustomerID  INT UNSIGNED PRIMARY KEY,
    FirstName   VARCHAR(25),
    LastName    VARCHAR(25),
    Street      VARCHAR(50),
    City        VARCHAR(50),
    State       VARCHAR(25),
    ZipCode     VARCHAR(10),
    Telephone   VARCHAR(15)
    );

        --  b.  A table to store order information with a primary key of Order ID and a foreign key of Customer ID
CREATE TABLE Orders (
    OrderID     INT UNSIGNED PRIMARY KEY,
    CustomerID  INT UNSIGNED,
    Sku         VARCHAR(20),
    Description VARCHAR(50),
    FOREIGN KEY (CustomerID)
    REFERENCES  Customers(CustomerID)
    );
        --  c.  A table to store RMA information with a primary key of RMA ID and a foreign key of Order ID
CREATE TABLE RMA (
    RmaID   INT UNSIGNED PRIMARY KEY,
    OrderID INT UNSIGNED,
    Step    VARCHAR(50),
    Status  VARCHAR(15),
    Reason  VARCHAR(15),
    FOREIGN KEY (OrderID)
    REFERENCES Orders(OrderID)
    );
        --  ** VERIFY **
SHOW TABLES;


--  STEP 2: Scenario  --
--          The shipping and receiving team that you are working with has been keeping records of their RMAs in
--          spreadsheets, and your team has been creating its database in MySQL. The information that they have is
--          detailed and won’t need cleaning. The data in the tables can be exported to CSV files. The data should
--          also align with the columns and data types in your tables.
--              1.  Import data from the CSV data files into the tables
--              2.  Perform queries against those tables
--              3.  Create an output listing to the screen of the query results

    --  1.  Importing Data
        --  a.  customers.CSV
LOAD DATA INFILE '/home/codio/workspace/customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

        --  b.  orders.CSV
LOAD DATA INFILE '/home/codio/workspace/orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

        --  c.  rma.CSV
LOAD DATA INFILE '/home/codio/workspace/rma.csv'
INTO TABLE RMA
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


    --  2.  Queries
		--  a.	Write an SQL query that returns the count of orders for customers located only in the city of 
		--	    Framingham, Massachusetts.
SELECT COUNT(*) AS customers_from_Framingham
FROM Customers AS c
INNER JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE c.City = 'Framingham' AND c.State = 'MA';

		--	b.	Write an SQL query to select all of the customers located in the state of Massachusetts.
SELECT *
FROM Customers
WHERE State = 'Massachusetts';

		--	c.  Write an SQL query to insert four new records into the orders and customers tables using
		--	    the following data:
			--	i. 	    Insert into Customers
INSERT INTO Customers(CustomerID, FirstName, LastName, Street, City, State, ZipCode, Telephone)
VALUES
    (100004, 'Luke', 'Skywalker', '17 Maiden Lane', 'New York', 'NY', '10222','212-555-1234'),
    (100005, 'Winston','Smith','128 Sycamore Street','Greensboro','NC','27401','919-555-6623'),
    (100006, 'MaryAnne','Jenkins','2 Coconut Way','Jupiter','FL','33458','321-555-8907'),
    (100007, 'Janet','Williams','58 Redondo Beach BLVD','Torrence','CA','90501','310-555-5678');

			--	ii.     Insert into Orders
INSERT INTO Orders(OrderID, CustomerID, Sku, Description)
VALUES
    (1204305, 100004, 'ADV-24-10C','Advanced Switch 10GigE Copper 24 port'),
    (1204306, 100005, 'ADV-48-10F', 'Advanced Switch 10 GigE Copper/Fiber 44 port copper 4 port fiber'),
    (1204307, 100006, 'ENT-24-10F', 'Enterprise Switch 10GigE SFP+ 24 Port'),
    (1204308, 100007, 'ENT-48-10F', 'Enterprise Switch 10GigE SFP+ 48 port');

			--	iii.    In the Customers table, perform a query to count all records where the city is
			--	        Woonsocket, Rhode Island.
SELECT COUNT(*) AS customers_from_Woonsocket
FROM Customers
WHERE City = 'Woonsocket'
    AND State = 'Rhode Island';

			--	iv. In the RMA database, update a customer's records.
			-- 	    a.  Write an SQL statement to select the current fields of status and step for the record in the
			--	        RMA table with an OrderID value of "5175."
SELECT OrderID, Status, Step
FROM RMA
WHERE OrderID = 5175;

				    -- 	i.  What are the current status and step?

				    -- 	ii. Write an SQL statement to update the status and step for the OrderID, 5175 to
				    --	    status = "Complete" and step = "Credit Customer Account."
UPDATE RMA
SET Status = 'Complete',
    Step = 'Credit Customer Account.'
WHERE OrderID = 5175;

					-- 	iii.  What are the updated status and step values for this record? Provide a
					--	    screenshot of your work.

			--	v.	Delete RMA records.
			--	    a.  Write an SQL statement to delete all records with a reason of "Rejected".
SELECT COUNT(*)
FROM RMA
WHERE Reason = 'Rejected'; -- This returns 0 results.

SELECT DISTINCT(Reason)
FROM RMA;   --  This returns four values, but the values are distorted in the view.
            --  'Rejected' is shown as 'ejected'

SELECT COUNT(*)
FROM RMA
WHERE Reason LIKE '&ejected%';  -- This returns a value of 596

UPDATE RMA
SET Reason = 'Rejected'
WHERE Reason LIKE '%ejected%';  -- 596 rows changed

SELECT COUNT(Reason)
FROM RMA
WHERE Reason = 'Rejected';  --  Returns a value of 596

DELETE FROM RMA
WHERE Reason = 'Rejected';
			        --	i.  How many records were deleted? Provide a screenshot of your work.
SELECT ROW_COUNT(); --  Returns the Row Count of the previous query

    --  3.  Because of a new company branding initiative, you’ve been asked to change the name of the “Customer” to
    --      “Collaborator.” Update your existing table using SQL based on this change in requirements. Copy and paste
    --      the SQL you write to do the following:
        --  a.  Rename all instances of “Customer” to “Collaborator.”
RENAME TABLE Customers to Collaborators;

    --  4.  Create an output file of the required query results. Write an SQL statement to list the contents of the
    --      Orders table and send the output to a file that has a .csv extension.
SELECT *
INTO OUTFILE '/home/codio/workspace/m6_orders_Navarro.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
FROM Orders;



UPDATE RMA
SET Reason =
    CASE Reason
    WHEN Reason LIKE '%Defective%' THEN 'Defective'
    WHEN Reason LIKE '&Incorrect%' THEN 'Incorrect'
    WHEN Reason LIKE '%Other%' THEN 'Other'
    ELSE Reason
    END;
