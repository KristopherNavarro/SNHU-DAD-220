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

--	First, fix RMA.Status
--	Create backup Customers table, populated with data from Customers.csv
CREATE TABLE RMABackup (
	RmaID	INT UNSIGNED PRIMARY KEY,
	OrderID	INT	UNSIGNED,
	Step		VARCHAR(50),
	Status	VARCHAR(15),
	Reason	VARCHAR(15)
	);


LOAD DATA INFILE '/home/codio/workspace/rma.csv'
INTO TABLE RMABackup
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


UPDATE RMA
INNER JOIN RMABackup
	ON RMA.RmaID = RMABackup.RmaID
SET RMA.Status = RMABackup.Status;


SELECT 
	COUNT(Col.State),
	Col.State,
	RMA.Status
FROM Collaborators AS Col
INNER JOIN Orders AS Ord
	ON Col.CustomerID = Ord.CustomerID
		INNER JOIN RMA
			ON Ord.OrderID = RMA.OrderID
WHERE RMA.Status = 'Rejected'
ORDER BY Col.State DESC;