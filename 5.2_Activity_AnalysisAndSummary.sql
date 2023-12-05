-- Select the 'navarro' database
USE navarro;

-- Create a table named 'parts_maintenance'
CREATE TABLE parts_maintenance (
    Vehicle_ID  BIGINT UNSIGNED PRIMARY KEY,
    State       CHAR(2),
    Repair      VARCHAR(50),
    Reason      VARCHAR(50),
    Year        SMALLINT UNSIGNED,
    Make        VARCHAR(50),
    body_type   VARCHAR(50)
);

-- Load the data into the 'parts_maintenance' table
LOAD DATA INFILE '/home/codio/workspace/FleetMaintenanceRecords.csv'
INTO TABLE parts_maintenance
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Check data was loaded ok
SELECT *
FROM parts_maintenance
LIMIT 5;

