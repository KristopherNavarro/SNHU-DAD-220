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
