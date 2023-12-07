--
USE QuantigrationRMA;

--
SHOW TABLES;

-- A. Sales by region:
--  i. Analyze sales data by state to determine where the company has the largest customer base.
SELECT c.State, COUNT(DISTINCT(o.CustomerID)) AS total_unique_customers
FROM Orders AS o
INNER JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
GROUP BY c.State
ORDER BY c.State;

-- -- -- this query exposed a data cleaning issue, there are a few states listed as their abbreviations
UPDATE Customers SET State = CASE
    WHEN State = 'CA' THEN 'California'
    WHEN State = 'FL' THEN 'Florida'
    WHEN State = 'NC' THEN 'North Carolina'
    WHEN State = 'NY' THEN 'New York'
    ELSE State  -- ELSE was added after this statement deleted the states for all customers except the few I was
                -- attempting to correct
    END;
-- -- -- -- -- -- --
CREATE TABLE customers_backup (
    CustomerID  INT,
    FirstName   VARCHAR(25),
    LastName    VARCHAR(25),
    Street      VARCHAR(50),
    City        VARCHAR(50),
    State       VARCHAR(25),
    ZipCode     VARCHAR(10),
    Telephone   VARCHAR(15)
);

LOAD DATA INFILE '/home/codio/workspace/customers.csv'
INTO TABLE customers_backup
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

UPDATE Customers AS c
JOIN customers_backup AS b
ON c.CustomerID = b.CustomerID
SET c.State = CASE
    WHEN c.State IS NULL THEN b.State
    ELSE c.State
    END;
-- This worked! All customer records with a NULL State attribute have been updated.
-- Running the query for 'total_unique_customers' returns 48 states with customers.
-- Alaska and Virginia are missing, query the customers_backup table to ensure my State fix didn't miss these states.
SELECT COUNT(*)
FROM customers_backup
WHERE State IN ('Alaska','Virginia')
GROUP BY State;     -- This query returns an empty set, confirming there are no customers from Alaska or Virgina.
-- -- -- -- -- -- -- -- --

-- Rerun the query for 'total_unique_customers' by state and rank each state, ordering by 'total_unique_customers'
SELECT
    @row_num := @row_num + 1 AS state_rank,
    State,
    total_unique_customers
FROM (
    SELECT
        c.State,
        COUNT(DISTINCT o.CustomerID) AS total_unique_customers
    FROM Orders AS o
    INNER JOIN Customers AS c ON o.CustomerID = c.CustomerID
    GROUP BY c.State
        ) AS subquery, (SELECT @row_num := 0) AS t
ORDER BY total_unique_customers DESC;

--  ii. Analyze the data to determine the top three products sold in the United States.


--  iii. Analyze the data to determine the top three products sold in the southeastern region of the United States.
--       - Southeastern states to include in your analysis: Virginia, North Carolina, South Carolina, and Georgia


-- B. Returns by region:
--  i. Analyze the data to determine the top three products returned in the United States.


--  ii. Analyze the data to determine the top three products returned in the northwestern region of the United States.
--      - Northwestern states to include in your analysis: Washington, Oregon, Idaho, and Montana


