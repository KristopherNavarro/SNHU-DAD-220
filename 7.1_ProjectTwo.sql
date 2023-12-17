# noinspection SqlNoDataSourceInspectionForFile

-- Scenario
-- The product manager of Quantigration has asked your data analytics team for a report summarizing your analysis of 
-- the return merchandise authorizations (RMAs) that have been received. These are the same data sets that you’ve 
-- already been working with. Your report should focus on summarizing the analysis and presenting your findings to the 
-- product manager.

-- Directions
-- RMA Report
-- In your report, respond to the manager’s requests: to summarize the data you’ve been working with and to identify 
-- key information that will help the company streamline operations. Remember, not everyone who reviews this report 
-- will have a technical background.

-- 1. Begin by writing SQL commands to capture usable data (which you’ve preloaded into Codio) for your analysis.
-- 2. Specifically, the product manager wants you to analyze the following:
	-- Analyze the number of returns by state and describe your findings in your report.
	-- Analyze the percentage of returns by product type and describe your findings in your report.
-- 3. In your report, clearly summarize your analysis of the data for stakeholders. Include screenshots of the results 
--    of each query. When summarizing results, you may want to consider the following questions:
	-- How does the data provide the product manager with usable information?
	-- What are the potential flaws in the data that has been presented?
	-- Are there any limitations on your conclusions, or any other ways of looking at it that you haven’t considered? 
		-- Clearly communicate your findings to stakeholders.

USE QuantigrationUpdates;

--  Before analyzing the tables, I need to first fix RMA.Reason
--  Create RMABackup table
CREATE TABLE RMABackup (
	RmaID	INT UNSIGNED	 PRIMARY KEY,
	OrderID	INT UNSIGNED,
	Step	VARCHAR(50),
	Status	VARCHAR(15),
	Reason	VARCHAR(15)
	);

--  Load the source data, rma.csv, into the RMABackup table
LOAD DATA INFILE '/home/codio/workspace/rma.csv'
INTO TABLE RMABackup
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--  Update RMABackup.Reason, correct the issues with each data string:
--  'ejected' = 'Rejected',
--  'efective' = 'Defective',
--  'ncorrect' = 'Incorrect',
--  'ther' = 'Other'

UPDATE RMABackup
SET Reason = 'Rejected'
WHERE Reason LIKE '%ejected%';

UPDATE RMABackup
SET Reason = 'Defective'
WHERE Reason LIKE '%efective%';

UPDATE RMABackup
SET Reason = 'Incorrect'
WHERE Reason LIKE '%ncorrect%';

UPDATE RMABackup
SET Reason = 'Other'
WHERE Reason LIKE '%ther%';

-- Update the RMA.reason field, using the data from RMABackup
UPDATE RMA
JOIN RMABackup AS backup
    ON RMA.RmaID = backup.RmaID
SET RMA.Reason = backup.reason;

-- Update the State field of Collaborators for only the 4 abbreviated states: CA, FL, NC, and NY
UPDATE Collaborators
SET State = CASE
                WHEN State = 'CA' THEN 'California'
                WHEN State = 'FL' THEN 'Florida'
                WHEN State = 'NC' THEN 'North Carolina'
                WHEN State = 'NY' THEN 'New York'
                ELSE State
    END
WHERE LENGTH(State) <= 2;

-- ---------------------------------------------------------------------------------------------
-- Now, on to the main analysis:
--  1. Analyze the number of returns by state
SELECT
    Col.State,
    COUNT(RMA.RmaID) AS RMA_Totals
FROM Collaborators AS Col
         INNER JOIN Orders AS Ord
                    ON Col.CustomerID = Ord.CustomerID
         INNER JOIN RMA
                    ON Ord.OrderID = RMA.OrderID
WHERE RMA.Reason != 'Rejected'
GROUP BY Col.State
ORDER BY RMA_Totals DESC;


--  2. Analyze the percentage of returns by product type
SELECT
    Ord.Sku,
    COUNT(RMA.*)
    ((SELECT COUNT(RMA.OrderID)
      FROM Collaborators AS Col3
               INNER JOIN Orders AS Ord3
                          ON Col.CustomerID = Ord.CustomerID
               INNER JOIN RMA
                           ON Ord.OrderID = RMA.OrderID
      WHERE Col3.State = Col.State AND RMA3.Reason <> 'Rejected') / (SELECT COUNT(RMA.RmaID FROM RMA))
FROM Orders AS Ord
    INNER JOIN RMA
        ON Ord.OrderID = RMA.OrderID
GROUP BY Ord.Sku;



-- ----------------------------------------------------------------
-- Misc. query
-- This query did not produce the results I expected, the resulting table was not easily readable.
SELECT
	Col.State,
	COUNT(RMABackup.Reason) AS RMA_Reason_Counts,
	RMABackup.Reason,
	COUNT(Ord.OrderID) AS Total_Orders
FROM Collaborators AS Col
INNER JOIN Orders AS Ord
	ON Col.CustomerID = Ord.CustomerID
	INNER JOIN RMABackup
	ON Ord.OrderID = RMABackup.OrderID
GROUP BY Col.State, RMABackup.Reason
ORDER BY Col.State, RMABackup.Reason;

-- This is the corrected query
SELECT
    Col.State,
    COUNT(DISTINCT(Ord.OrderID)) AS Order_Counts,
    (SELECT COUNT(RMA2.RmaID)
     FROM Collaborators AS Col2
              INNER JOIN Orders AS Ord2
                         ON Col2.CustomerID = Ord2.CustomerID
              INNER JOIN RMA AS RMA2
                         ON Ord2.OrderID = RMA2.OrderID
     WHERE Col2.State = Col.State) AS RMA_Counts,
    ((SELECT COUNT(RMA3.OrderID)
      FROM Collaborators AS Col3
               INNER JOIN Orders AS Ord3
                          ON Col3.CustomerID = Ord3.CustomerID
               INNER JOIN RMA AS RMA3
                          ON Ord3.OrderID = RMA3.OrderID
      WHERE Col3.State = Col.State AND RMA3.Reason <> 'Rejected') / COUNT(Ord.OrderID) * 100) AS RMA_Percentage_by_state_orders
FROM Collaborators AS Col
         INNER JOIN Orders AS Ord
                    ON Col.CustomerID = Ord.CustomerID
GROUP BY Col.State
ORDER BY Order_Counts DESC;