USE classicmodels;

-- In order to properly query the data in 'classicmodels', I first SHOW what tables are present,
-- then DESCRIBE the tables
SHOW TABLES;

DESCRIBE employees;

DESCRIBE offices;


-- 1. Retrieve employee tuples and identify the number of employees in San Francisco and New York
-- A. Query employees from San Francisco
SELECT firstName, lastName, jobTitle, offices.city
FROM employees
INNER JOIN offices
    ON employees.officeCode = offices.officeCode
WHERE state = 'CA';

-- B. Query employees from New York City
SELECT firstName, lastName, jobTitle, offices.city
FROM employees
INNER JOIN offices
    ON employees.officeCode = offices.officeCode
WHERE state = 'NY';

-- VARIATION: combines both query results instead of two statements.
SELECT firstName, lastName, jobTitle, offices.city
FROM employees
INNER JOIN offices
    ON employees.officeCode = offices.officeCode
WHERE (state = 'CA') OR (state = 'NY')
ORDER BY offices.city;


-- 2. Retrieve order details for orderNumber 10330, 10338, and 10194 and identify what type of cardinality this
-- represents in the entity relationship model.
-- A. Retrieve the order details by running SELECT queries with WHERE clauses against the orders table.
SELECT orders.orderNumber, od.orderLineNumber, od.productCode, od.quantityOrdered, od.priceEach
FROM orders
INNER JOIN orderdetails AS od
    ON orders.orderNumber = od.orderNumber
WHERE orders.orderNumber IN (10330, 10338, 10194)
ORDER BY orders.orderNumber, od.orderLineNumber;

-- B. Validate the completion of this step with a screenshot.
-- C. Then, reference the Module Four Lab ERD to assist in identifying relationships. A version with alternative
--    text is available: Module Four Lab ERD With Alternative Text.
-- D. Now, identify what type of cardinality this represents in the entity relationship model.
--    ANSWER:


-- 3. Delete records from the payments table where the customer number equals 103.
-- A. Run a DESCRIBE statement to identify fields in the payments table first.
DESCRIBE payments;

-- B. Select the records from the payments table for customer number 103 before deleting them.
--      i. Validate that the above instructions have worked with a screenshot.
SELECT *
FROM payments
WHERE customerNumber = 103;

-- C. Delete the records from the payments table for customer number 103.
DELETE FROM payments
WHERE customerNumber = 103;

-- D. Run a SELECT statement against the table to show that customer number 103 is no longer there.
--      i. Validate the completion of this step with a screenshot.
SELECT *
FROM payments
WHERE customerNumber = 103;


-- 4. Retrieve customer records for sales representative Barry Jones and identify if the relationships are one-to-one
--    or one-to-many.
--  A. Remember: SELECT, FROM, Inner Join, and WHERE.
SELECT customers.*
FROM customers
INNER JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber
WHERE employees.firstName = 'Barry' AND employees.lastName = 'Jones';

--  B. Use Barry’s employeeNumber, 1504, and perform a join between the customer salesRepEmployeeNumber to retrieve
--     these records.
--      i. Validate the completion of this step with a screenshot.
--      ii. Identify whether these entities demonstrate one-to-one or one-to-many relationships.
SELECT customers.*
FROM customers
INNER JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber
WHERE employees.employeeNumber = '1504';

-- 5. Retrieve records for customers who reside in Massachusetts and identify their sales rep and the relationship of
--    entities.
--  A. Remember: SELECT, FROM, Inner Join, and WHERE.
--  B. Use employee.firstName and employee.lastName in your command.
--  C. Identify whether these entities demonstrate one-to-one or many-to-many relationships.
SELECT c.customerNumber, c.customerName, c.state AS customerState, CONCAT(e.firstName,' ',e.lastName) AS repName
FROM customers AS c
INNER JOIN employees AS e
ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE c.state = 'MA';


-- 6. Add one customer record with your last name using an INSERT statement.
--  A. You may use the name of a celebrity or fictional character if you don’t use your own name. Think of this as
--     your signature.
--  B. Complete these actions to get to the right place to enter this information: (1) Show databases, (2) use
--     classicmodels, (3) show tables, (4) describe customers;
--      i. You should now be seeing all of the fields that you’ll need to fill in to complete this step.
--      ii. Reference your Module Two lab or resources on how to populate these fields if you need to.
--      iii. Fields you’ll need to populate: customerNumber, customerName, contactLastName, contactFirstName, phone,
--           addressLine1, addressLine2, city, state, postalCode, country, salesRepEmployeeNumber, and creditLimit.
--      iv. Run a SELECT statement on the customers table, capture it in a screenshot, and put it in your template.
SELECT MAX(customerNumber)
FROM customers;

INSERT INTO customers(customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1,
                      addressLine2, city, state,postalCode, country)
VALUES
    (497, 'Kristopher Navarro','Kristopher','Navarro','817-715-3563',
     '2032 Bear Creek Drive', 'Unit 2121', 'Dallas','TX','76039','United States');

SELECT *
FROM customers
WHERE customerName = 'Kristopher Navarro';