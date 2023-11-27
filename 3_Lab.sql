-- 1. Update the name of the Branches table that you created in the previous lab to say "Department".
--      Use an ALTER statement to successfully RENAME the "Branches" table to "Department".
--      Capture these outputs in a screenshot to validate that you’ve successfully completed this step.

ALTER TABLE Branches 
RENAME TO Department;


----------------------------------------------------------------------------------------------
-- 2. Insert fields to the Department table so that you’ll be able to perform joins on them.
--    - INSERT INTO Department VALUES
--      (1, 'Accounting'),
--      (2, 'Human Resources'),
--      (3, 'Information Systems'),
--      (4, 'Marketing');
--    - Write a SELECT statement for this table to prove this step, and validate that it ran correctly with a screenshot.

INSERT INTO Department
VALUES 
    (1, 'Accounting'),
    (2, 'Human Resources'),
    (3, 'Information Systems'),
    (4, 'Marketing');

SELECT *
FROM Department;


------------------------------------------------------------------------------------------
-- 3. Now, perform joins between the Department and Employee tables and show results for how many employees work in each one of the four departments. This will only provide information on the records that are already there.
--    - Department 1 = Accounting
--          Command: SELECT First_Name, Last_Name, Department.Department_Name FROM Employee INNER JOIN Department ON
--          Employee.Department_ID = Department.Department_ID WHERE Employee.Department_ID = 1;
--    - Using SELECT statements similar to the one above, perform joins to produce results for the following tables:
--          Department 2 = Human Resources
--          Department 3 = Information Systems
--          Department 4 = Marketing
--    - Capture the results of these joins and validate your work by providing a screenshot. You should have the same number of records as you do employees.

SELECT First_Name, Last_Name, Department.Department_Name
FROM Employee
INNER JOIN Department 
    ON Employee.Department_ID = Department.Department_ID
WHERE Employee.Department_ID = 1;

SELECT Department.Department_ID, Department.Department_Name, COUNT(Employee.Employee_ID) AS Employee_Count
FROM Department
INNER JOIN Employee
    ON Department.Department_ID = Employee.Department_ID
GROUP BY Department.Department_ID, Department.Department_Name;


------------------------------------------------------------------------------------------
-- 4. Populate the Employee table with information for ten new employees.
--     Give them unique names and include attributes for all necessary fields. (Note: Please reference attributes from the lab in Module Two. Department ID values must be between 1 and 4.)
--
--  ** Set the Employee.Employee_ID to auto_increment

ALTER TABLE Employee
MODIFY COLUMN Employee_ID SMALLINT PRIMARY KEY auto_increment;

INSERT INTO Employee(First_Name,Last_Name,Department_ID,Classification,Status,Salary)
VALUES
    ('Adrian','Turner',1,'Exempt','Full-Time',68000),
    ('Jasmine','Patel',3,'Non-Exempt','Part-Time',32000),
    ('Nolan','Gallagher',2,'Exempt','Full-Time',71000),
    ('Aisha','Khan',4,'Non-Exempt','Full-Time',65000),
    ('Cameron','Reynolds',1,'Exempt','Part-Time',27000),
    ('Zoe','Henderson',4,'Exempt','Part-Time',34000),
    ('Leo','Ramirez',2,'Non-Exempt','Full-Time',82000),
    ('Maya','Thompson',3,'Non-Exempt','Part-Time',32000),
    ('Owen','Martinez',1,'Exempt','Full-Time',83000),
    ('Grace','Lewis',4,'Non-Exempt','Part-Time',28000);


------------------------------------------------------------------------------------------
-- 5. Perform a join across the Employee and Department Tables for each of the four departments. New and existing records should be displayed in the results.
--     Take a screenshot to capture the updated results that the Employee and Department joins show to validate that they have run correctly. You should have the same number of records as you do employees.

SELECT Employee.First_Name, Employee.Last_Name, Department.Department_Name
FROM Department
INNER JOIN Employee
    ON Department.Department_ID = Employee.Department_ID
ORDER BY Department.Department_Name, Employee.Last_Name;


-------------------------------------------------------------------------------------------
-- 6. Identify the resultant outputs of the commands that you’ve written:
--      How many records are returned for employees in each department?

SELECT Department.Department_ID, Department.Department_Name, COUNT(Employee.Employee_ID) AS Employee_Count
FROM Department
INNER JOIN Employee
    ON Department.Department_ID = Employee.Department_ID
GROUP BY Department.Department_ID, Department.Department_Name;


-------------------------------------------------------------------------------------------
-- 7. Create a CSV file that contains only the records of employees in Human Resources and Information Systems. If you run this query multiple times, be sure to use a different file name each time. MySQL will not overwrite an existing file.
--    - Enter the command listed below.
--          Command: select First_Name, Last_Name, Department.Department_Name from Employee inner join Department on Employee.Department_ID = Department.Department_ID where Employee.Department_ID = 3 OR Employee.Department_ID = 2 into outfile'/home/codio/workspace/HRandIS-Employees.csv' FIELDS TERMINATED BY',' LINES TERMINATED BY '\r\n';
--    - Print the file output to the screen.
--        - You’ll need to type the word quit after your MySQL prompt and then press Enter to exit to the Linux shell. Do not exit the virtual lab environment itself.
--        - Next, print the output of your file to the screen by following these steps:
--           1. Type pwd and press Enter, then type ls and press Enter again. This will list your files.
--           2. Now, type cat HRandIS-Employees.csv and press Enter.
--           3. Capture these outputs in a screenshot to validate that you’ve successfully completed this step.

SELECT First_Name, Last_Name, Department.Department_Name
FROM Employee
INNER JOIN Department
    ON Employee.Department_ID = Department.Department_ID
WHERE Employee.Department_ID = 2 OR Employee.Department_ID = 3
ORDER BY Department.Department_Name, Employee
into outfile'/home/codio/workspace/HRandIS-Employees_ordered.csv' FIELDS TERMINATED BY',' LINES TERMINATED BY '\r\n';


---------------------------------------------------------------------------------------------
-- 8. Reflection: Provide detailed insight on the prompts below by explaining your process along with how and why it ultimately worked.
--    - Process
--          - Explain how the joins you used in this assignment worked.
--          - Describe why the commands you used were able to retrieve the Department table when you selected the Department name.
--    - File creation and extraction
--          - Identify how many records are in the file when you write the records of your query to a CSV file.
--          - Explain, in detail, the process of extracting data to a flat file.

