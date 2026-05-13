-- =============================================================
-- 20MCA134 ADVANCED DBMS LAB
-- MySQL Solutions - Run in Linux Terminal
-- HOW TO USE:
--   Method 1 (run whole file):  mysql -u root -p < ADBMS_Lab_MySQL.sql
--   Method 2 (interactive):     mysql -u root -p
--                                then copy-paste each block
-- =============================================================

-- Always start by selecting or creating your working database
CREATE DATABASE IF NOT EXISTS adbms_lab;
USE adbms_lab;


-- =============================================================
-- EXPERIMENT 1: Basic DDL + DML on Employee Table
-- =============================================================

-- Step 1: Create Employee table
CREATE TABLE Employee (
    SLNO        INT,
    NAME        VARCHAR(50),
    DESIGNATION VARCHAR(50),
    BRANCH      VARCHAR(50)
);

-- Step 2: Insert records
INSERT INTO Employee VALUES (1, 'KRISHNA', 'ASSISTANT', 'CHENNAI');
INSERT INTO Employee VALUES (2, 'RAM',     'MANAGER',   'HYDERABAD');
INSERT INTO Employee VALUES (3, 'ASWIN',   'SUPERVISOR', 'KERALA');
INSERT INTO Employee VALUES (4, 'SUMAYYA', 'SUPERVISOR', 'MANGALORE');

-- Step 3: ADD a new column SALARY
ALTER TABLE Employee ADD COLUMN SALARY DECIMAL(10,2);

-- Step 4: MODIFY a column (renaming not directly supported in old MySQL via ALTER COLUMN)
-- In MySQL 8.0+ use RENAME COLUMN; otherwise use CHANGE
-- Renaming NAME to EMP_NAME:
ALTER TABLE Employee RENAME COLUMN NAME TO EMP_NAME;
-- (For older MySQL: ALTER TABLE Employee CHANGE NAME EMP_NAME VARCHAR(50);)

-- Step 5: DROP the salary column
ALTER TABLE Employee DROP COLUMN SALARY;

-- Step 6: DELETE rows where branch is Chennai
DELETE FROM Employee WHERE BRANCH = 'CHENNAI';

-- View current state
SELECT * FROM Employee;

-- Clean up for next experiment
DROP TABLE IF EXISTS Employee;


-- =============================================================
-- EXPERIMENT 2: Constraints - PRIMARY KEY & FOREIGN KEY
-- =============================================================

-- Create Student table with PRIMARY KEY constraint
CREATE TABLE Student (
    Student_id   INT PRIMARY KEY,          -- Primary Key: unique + not null
    Student_name VARCHAR(100) NOT NULL
);

-- Create Department table with PRIMARY KEY and FOREIGN KEY
CREATE TABLE Department (
    Department_ID INT PRIMARY KEY,                            -- PK on this table
    Name          VARCHAR(100),
    Student_ID    INT,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_id)  -- FK references Student
);

-- Insert sample data
INSERT INTO Student VALUES (1, 'Alice');
INSERT INTO Student VALUES (2, 'Bob');

INSERT INTO Department VALUES (101, 'Computer Science', 1);
INSERT INTO Department VALUES (102, 'IT',               2);

SELECT * FROM Student;
SELECT * FROM Department;

DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Student;


-- =============================================================
-- EXPERIMENT 3: DDL Operations - ALTER, DESCRIBE, TRUNCATE, DROP
-- =============================================================

CREATE TABLE Employee (
    EMPNO       VARCHAR(10),
    NAME        VARCHAR(50),
    DESIGNATION VARCHAR(50),
    BRANCH      VARCHAR(50)
);

INSERT INTO Employee VALUES ('E211', 'SANJAY',  'MANAGER',    'CHENNAI');
INSERT INTO Employee VALUES ('E364', 'RAM',     'SUPERVISOR',  'CHENNAI');
INSERT INTO Employee VALUES ('E453', 'ASWIN',   'ASSISTANT',   'TRICHY');
INSERT INTO Employee VALUES ('E896', 'SUMAYYA', 'ASSISTANT',   'MADURAI');
INSERT INTO Employee VALUES ('E231', 'LAKSHMI', 'MANAGER',     'MADURAI');

-- 1. Add column SALARY
ALTER TABLE Employee ADD COLUMN SALARY DECIMAL(10,2);

-- 2. Modify the NAME column to increase size
ALTER TABLE Employee MODIFY COLUMN NAME VARCHAR(100);

-- 3. DESCRIBE shows the structure (column names, types, constraints)
DESCRIBE Employee;

-- 4. TRUNCATE removes all rows but keeps table structure (faster than DELETE)
TRUNCATE TABLE Employee;

-- Re-insert to show DELETE single row
INSERT INTO Employee VALUES ('E211', 'SANJAY',  'MANAGER',   'CHENNAI', 60000);
INSERT INTO Employee VALUES ('E364', 'RAM',     'SUPERVISOR', 'CHENNAI', 45000);
INSERT INTO Employee VALUES ('E453', 'ASWIN',   'ASSISTANT',  'TRICHY',  30000);

-- 5. DELETE the second row (RAM)
DELETE FROM Employee WHERE EMPNO = 'E364';

SELECT * FROM Employee;

-- 6. DROP removes the table entirely
DROP TABLE IF EXISTS Employee;


-- =============================================================
-- EXPERIMENT 4: SELECT Queries on Employees Table
-- =============================================================

CREATE TABLE Employees (
    Employee_Id    INT PRIMARY KEY,
    First_Name     VARCHAR(50),
    Last_Name      VARCHAR(50),
    Email          VARCHAR(100),
    Phone_Number   VARCHAR(20),
    Hire_Date      DATE,
    Job_Id         VARCHAR(20),
    Salary         DECIMAL(10,2),
    Commission_Pct DECIMAL(4,2),
    Manager_Id     VARCHAR(10),
    Department_Id  VARCHAR(10)
);

-- Sample inserts
INSERT INTO Employees VALUES (1,'ALICE','SMITH','alice@mail.com','9000000001','2015-06-01','IT_PROG',  8000, 0.10,'M215','C21');
INSERT INTO Employees VALUES (2,'BOB','MICHAEL','bob@mail.com','9000000002','2018-03-15','HR_PROF',  6000, 0.05,'M215','F70');
INSERT INTO Employees VALUES (3,'CAROL','JONES','carol@mail.com','9000000003','2020-11-20','ANALYST', 9500, 0.12,'M310','H80');
INSERT INTO Employees VALUES (4,'DAN','LEE','dan@mail.com','9000000004','2021-01-10','ASSISTANT',4500, 0.00,'M215','C21');
INSERT INTO Employees VALUES (5,'EVE','MICHAEL','eve@mail.com','9000000005','2019-07-25','MANAGER', 12000,0.15,'M310','H80');

-- 1. Employee_id, names and salary of all employees
SELECT Employee_Id, First_Name, Last_Name, Salary FROM Employees;

-- 2. Employees under Manager M215
SELECT * FROM Employees WHERE Manager_Id = 'M215';

-- 3. Salary >= 7500
SELECT First_Name, Last_Name, Salary FROM Employees WHERE Salary >= 7500;

-- 4. Last name is 'MICHAEL'
SELECT * FROM Employees WHERE Last_Name = 'MICHAEL';

-- 5. Employees in departments C21, F70, H80
SELECT * FROM Employees WHERE Department_Id IN ('C21', 'F70', 'H80');

-- 6. Unique Manager IDs (DISTINCT removes duplicates)
SELECT DISTINCT Manager_Id FROM Employees;

DROP TABLE IF EXISTS Employees;


-- =============================================================
-- EXPERIMENT 5: GROUP BY, Aggregate Functions, Date Functions
-- =============================================================

CREATE TABLE Sales (
    SalesId      INT PRIMARY KEY,
    Salesmenname VARCHAR(50),
    Branch       VARCHAR(50),
    Salesamount  DECIMAL(10,2),
    DOB          DATE
);

INSERT INTO Sales VALUES (1, 'ARUN',   'CHENNAI',   50000, '1990-12-21');
INSERT INTO Sales VALUES (2, 'BEENA',  'KERALA',    72000, '1985-07-15');
INSERT INTO Sales VALUES (3, 'CAROL',  'CHENNAI',   61000, '1992-12-05');
INSERT INTO Sales VALUES (4, 'DINESH', 'HYDERABAD', 83000, '1988-09-30');
INSERT INTO Sales VALUES (5, 'EVA',    'KERALA',    47000, '1995-12-19');

-- 1. Total salesamount per branch
SELECT Branch, SUM(Salesamount) AS Total_Sales
FROM Sales
GROUP BY Branch;

-- 2. Average salesamount per branch
SELECT Branch, AVG(Salesamount) AS Avg_Sales
FROM Sales
GROUP BY Branch;

-- 3. Salesmen born in December, DOB in format 21-Dec-09
--    DATE_FORMAT: %d = day, %b = abbreviated month, %y = 2-digit year
SELECT Salesmenname, DATE_FORMAT(DOB, '%d-%b-%y') AS DOB_Formatted
FROM Sales
WHERE MONTH(DOB) = 12;

-- 4. Name and DOB sorted alphabetically by MONTH NAME
--    MONTHNAME() returns 'January', 'February', etc.
SELECT Salesmenname, DOB
FROM Sales
ORDER BY MONTHNAME(DOB);

DROP TABLE IF EXISTS Sales;


-- =============================================================
-- EXPERIMENT 6: Client_master - DML + Column Alias + RENAME
-- =============================================================

CREATE TABLE Client_master (
    ClientNO VARCHAR(10) PRIMARY KEY,
    Name     VARCHAR(50),
    Address  VARCHAR(100),
    City     VARCHAR(50),
    State    VARCHAR(50),
    Bal_due  DECIMAL(10,2)
);

INSERT INTO Client_master VALUES ('C001', 'ARUN',   '12 MG Road',  'Chennai',   'TN',  4500.00);
INSERT INTO Client_master VALUES ('C510', 'BEENA',  '45 Park Ave',  'Kochi',     'KL',  8200.00);
INSERT INTO Client_master VALUES ('C003', 'CAROL',  '78 Anna Nagar','Madurai',   'TN',  3100.00);
INSERT INTO Client_master VALUES ('C004', 'DINESH', '90 SV Road',   'Hyderabad', 'TS',  6750.00);
INSERT INTO Client_master VALUES ('C005', 'EVA',    '22 Brigade Rd','Bangalore',  'KA',  5600.00);

-- 1. Clients with bal_due > 5000
SELECT * FROM Client_master WHERE Bal_due > 5000;

-- 2. Update bal_due for C510 to 5100
UPDATE Client_master SET Bal_due = 5100 WHERE ClientNO = 'C510';

-- 3. Rename the table (MySQL syntax)
RENAME TABLE Client_master TO Clienttable;

-- 4. Display bal_due with alias "BALANCE"
SELECT Name, Bal_due AS BALANCE FROM Clienttable;

DROP TABLE IF EXISTS Clienttable;


-- =============================================================
-- EXPERIMENT 7: TCL - COMMIT and ROLLBACK
-- =============================================================

CREATE TABLE Teacher (
    Name          VARCHAR(50),
    DeptNo        INT,
    Date_of_joining DATE,
    DeptName      VARCHAR(50),
    Location      VARCHAR(50),
    Salary        DECIMAL(10,2)
);

INSERT INTO Teacher VALUES ('ANITA',  10, '2010-06-01', 'Mathematics', 'Block A', 40000);
INSERT INTO Teacher VALUES ('BIJU',   20, '2015-08-15', 'Commerce',    'Block B', 35000);
INSERT INTO Teacher VALUES ('CAROL',  10, '2012-01-20', 'Mathematics', 'Block A', 42000);
INSERT INTO Teacher VALUES ('DAVID',  20, '2018-03-10', 'Commerce',    'Block B', 38000);
INSERT INTO Teacher VALUES ('ELSA',   30, '2020-09-05', 'Science',     'Block C', 33000);

-- NOTE: MySQL autocommit is ON by default. Use START TRANSACTION to control it.

-- Increase salary by 25% for Mathematics Dept
START TRANSACTION;
UPDATE Teacher SET Salary = Salary * 1.25 WHERE DeptName = 'Mathematics';

-- ROLLBACK undoes the above update (nothing is saved)
ROLLBACK;
SELECT Name, DeptName, Salary FROM Teacher;  -- Salary unchanged after ROLLBACK

-- Increase salary by 15% for Commerce Dept
START TRANSACTION;
UPDATE Teacher SET Salary = Salary * 1.15 WHERE DeptName = 'Commerce';

-- COMMIT permanently saves the change
COMMIT;
SELECT Name, DeptName, Salary FROM Teacher;  -- Commerce salary now updated

DROP TABLE IF EXISTS Teacher;


-- =============================================================
-- EXPERIMENT 8: Calculated Columns - GrossPay, NetPay
-- =============================================================

CREATE TABLE Emp (
    EmpNo    VARCHAR(10) PRIMARY KEY,
    EmpName  VARCHAR(50),
    Job      VARCHAR(50),
    Basic    DECIMAL(10,2),
    DA       DECIMAL(10,2),   -- 30% of Basic
    HRA      DECIMAL(10,2),   -- 40% of Basic
    PF       DECIMAL(10,2),
    GrossPay DECIMAL(10,2),   -- Basic + DA + HRA
    NetPay   DECIMAL(10,2)    -- GrossPay - PF
);

-- Insert with calculated values inline
INSERT INTO Emp VALUES
('E01','ARUN',  'MANAGER',  50000, 50000*0.30, 50000*0.40, 2000, 50000+15000+20000, 50000+15000+20000-2000);
INSERT INTO Emp VALUES
('E02','BEENA', 'ANALYST',  40000, 40000*0.30, 40000*0.40, 1800, 40000+12000+16000, 40000+12000+16000-1800);
INSERT INTO Emp VALUES
('E03','CAROL', 'CLERK',    20000, 20000*0.30, 20000*0.40, 1000, 20000+6000+8000,   20000+6000+8000-1000);
INSERT INTO Emp VALUES
('E04','DINESH','SUPERVISOR',30000,30000*0.30, 30000*0.40, 1500, 30000+9000+12000,  30000+9000+12000-1500);
INSERT INTO Emp VALUES
('E05','EVA',   'CLERK',    18000, 18000*0.30, 18000*0.40, 900,  18000+5400+7200,   18000+5400+7200-900);

-- 1. Employee with lowest Basic (MIN aggregate)
SELECT EmpName, MIN(Basic) AS Lowest_Basic FROM Emp;

-- 2. Add Rs.1200 special allowance if NetPay < 10000
UPDATE Emp SET NetPay = NetPay + 1200 WHERE NetPay < 10000;

-- 3. Employees with GrossPay between 10000 and 20000
SELECT EmpName, GrossPay FROM Emp WHERE GrossPay BETWEEN 10000 AND 20000;

-- 4. Employee(s) earning maximum salary
SELECT EmpName, GrossPay FROM Emp WHERE GrossPay = (SELECT MAX(GrossPay) FROM Emp);

DROP TABLE IF EXISTS Emp;


-- =============================================================
-- EXPERIMENT 9: DDL - RENAME TABLE, ADD/RENAME/MODIFY/DROP Column
-- =============================================================

CREATE TABLE Department (
    Department INT,
    Dname      VARCHAR(50),
    Location   VARCHAR(50)
);

-- 1. Rename table
RENAME TABLE Department TO dept_table;

-- 2. Add PINCODE column with NOT NULL + DEFAULT (NOT NULL needs a default or value)
ALTER TABLE dept_table ADD COLUMN PINCODE INT NOT NULL DEFAULT 0;

-- 3. Rename column DNAME to DEPT_NAME (MySQL 8.0+)
ALTER TABLE dept_table RENAME COLUMN Dname TO DEPT_NAME;

-- 4. Change data type of Location to CHAR(10)
ALTER TABLE dept_table MODIFY COLUMN Location CHAR(10);

-- 5. Drop the table
DROP TABLE IF EXISTS dept_table;


-- =============================================================
-- EXPERIMENT 10: Advanced SELECT Queries on Employee Table
-- =============================================================

CREATE TABLE Employee (
    EMPNO       VARCHAR(10),
    NAME        VARCHAR(50),
    DEPT        VARCHAR(20),
    SALARY      DECIMAL(10,2),
    DATOFJOINED DATE,
    DESIG       VARCHAR(50),
    BRANCH      VARCHAR(50)
);

INSERT INTO Employee VALUES ('E211','KRISHNA','MEDIA',  25000,'2024-01-19','ASSISTANT','CHENNAI');
INSERT INTO Employee VALUES ('E364','RAM',    'IT',     50000,'2020-11-25','MANAGER',  'HYDERABAD');
INSERT INTO Employee VALUES ('E453','ASWIN',  'CIVIL',  65000,'2010-05-04','SUPERVISOR','KERALA');
INSERT INTO Employee VALUES ('E896','SUMAYYA','HR',     62000,'2018-10-05','SUPERVISOR','MANGALORE');
INSERT INTO Employee VALUES ('E125','ASWIN',  'FINANCE',180000,'2012-09-09','MANAGER', 'KERALA');
INSERT INTO Employee VALUES ('E467','SUMAYYA','IT',     150000,'2005-07-15','MANAGER', 'MANGALORE');

-- 1. All fields
SELECT * FROM Employee;

-- 2. EMPNO and SALARY only
SELECT EMPNO, SALARY FROM Employee;

-- 3. Average salary
SELECT AVG(SALARY) AS Avg_Salary FROM Employee;

-- 4. Count of all employees
SELECT COUNT(*) AS Total_Employees FROM Employee;

-- 5. Distinct employee count (no duplicate names)
SELECT COUNT(DISTINCT NAME) AS Distinct_Names FROM Employee;

-- 6. Total salary per employee name + count of same names
SELECT NAME, SUM(SALARY) AS Total_Salary, COUNT(*) AS Count
FROM Employee
GROUP BY NAME;

-- 7. Total salary > 120000 (using HAVING with GROUP BY)
SELECT NAME, SUM(SALARY) AS Total_Salary
FROM Employee
GROUP BY NAME
HAVING SUM(SALARY) > 120000;

-- 8. Names in descending order
SELECT NAME FROM Employee ORDER BY NAME DESC;

-- 9. ASWIN with salary > 150000
SELECT * FROM Employee WHERE NAME = 'ASWIN' AND SALARY > 150000;

DROP TABLE IF EXISTS Employee;


-- =============================================================
-- EXPERIMENT 11: Subqueries on Employee Table
-- =============================================================

CREATE TABLE EMPLOYEE (
    Emp_no      VARCHAR(10) PRIMARY KEY,
    E_name      VARCHAR(50),
    E_address   VARCHAR(100),
    E_ph_no     VARCHAR(20),
    Email_id    VARCHAR(100),
    Dept_no     VARCHAR(10),
    Dept_name   VARCHAR(50),
    Job_id      VARCHAR(20),
    Designation VARCHAR(50),
    Salary      DECIMAL(10,2),
    Date_of_join DATE
);

INSERT INTO EMPLOYEE VALUES ('E01','ALICE','Chennai','9001','alice@x.com','D54','HR','J01','MANAGER',     90000,'2012-05-01');
INSERT INTO EMPLOYEE VALUES ('E02','BOB',  'Mumbai', '9002','bob@x.com',  'D80','IT','J02','ANALYST',     75000,'2016-03-15');
INSERT INTO EMPLOYEE VALUES ('E03','CAROL','Delhi',  '9003','carol@x.com','D54','HR','J03','HR PROFESSIONAL',50000,'2020-09-10');
INSERT INTO EMPLOYEE VALUES ('E04','DAN',  'Pune',   '9004','dan@x.com',  'D80','IT','J04','ASSISTANT',   30000,'2015-07-22');
INSERT INTO EMPLOYEE VALUES ('E05','EVE',  'Kochi',  '9005','eve@x.com',  'D54','HR','J05','HR PROFESSIONAL',55000,'2019-01-30');
INSERT INTO EMPLOYEE VALUES ('E06','SARA', 'Chennai','9006','sara@x.com', 'D90','FIN','J01','MANAGER',    95000,'2010-11-05');
INSERT INTO EMPLOYEE VALUES ('E07','ARUN', 'Trichy', '9007','arun@x.com', 'D80','IT','J06','ANALYST',     80000,'2021-06-18');
INSERT INTO EMPLOYEE VALUES ('E08','SONA', 'Kochi',  '9008','sona@x.com', 'D54','HR','J07','ASSISTANT',   28000,'2022-03-12');

-- 1. Emp_no, E_name, Salary of all MANAGERs
SELECT Emp_no, E_name, Salary FROM EMPLOYEE WHERE Designation = 'MANAGER';

-- 2. Employees whose salary > salary of ANY HR PROFESSIONAL (subquery)
SELECT * FROM EMPLOYEE
WHERE Salary > ANY (
    SELECT Salary FROM EMPLOYEE WHERE Designation = 'HR PROFESSIONAL'
);

-- 3. Ascending order of Designation for those who joined after 2014
SELECT * FROM EMPLOYEE
WHERE YEAR(Date_of_join) > 2014
ORDER BY Designation ASC;

-- 4. Employees with Experience (years since joining) and Salary
--    TIMESTAMPDIFF calculates difference in specified unit
SELECT E_name, Salary,
       TIMESTAMPDIFF(YEAR, Date_of_join, CURDATE()) AS Experience_Years
FROM EMPLOYEE;

-- 5. ASSISTANT or ANALYST
SELECT * FROM EMPLOYEE WHERE Designation IN ('ASSISTANT', 'ANALYST');

-- 6. Joined on specific dates
SELECT * FROM EMPLOYEE
WHERE Date_of_join IN ('2020-05-01','1999-12-03','2000-12-17','1980-01-19');

-- 7. Working in Deptno D54 or D80
SELECT * FROM EMPLOYEE WHERE Dept_no IN ('D54', 'D80');

-- 8. Names starting with 'A'
SELECT E_name FROM EMPLOYEE WHERE E_name LIKE 'A%';

-- 9. First 5 characters of names starting with 'S'
--    SUBSTRING(string, start, length)
SELECT E_name, SUBSTRING(E_name, 1, 5) AS First5Chars
FROM EMPLOYEE WHERE E_name LIKE 'S%';

-- 10. All except PRESIDENT and MANAGER, sorted by salary ASC
SELECT * FROM EMPLOYEE
WHERE Designation NOT IN ('PRESIDENT', 'MANAGER')
ORDER BY Salary ASC;

DROP TABLE IF EXISTS EMPLOYEE;


-- =============================================================
-- EXPERIMENT 12: Multi-table JOIN Queries
-- =============================================================

CREATE TABLE Student (
    Sid  INT PRIMARY KEY,
    sname VARCHAR(50),
    sex   CHAR(1),
    dob   DATE,
    dno   INT
);

CREATE TABLE Dept (
    dno   INT PRIMARY KEY,
    dname VARCHAR(50)
);

CREATE TABLE Faculty (
    F_id        INT PRIMARY KEY,
    fname       VARCHAR(50),
    designation VARCHAR(50),
    salary      DECIMAL(10,2),
    dno         INT
);

INSERT INTO Dept VALUES (1,'Computer'),(2,'Mathematics'),(3,'Physics');
INSERT INTO Student VALUES
(1,'Alice','F','2002-03-10',1),
(2,'Bob',  'M','2001-07-22',2),
(3,'Carol','F','2003-01-15',1),
(4,'Dan',  'M','2002-11-08',3),
(5,'Eve',  'F','2001-05-30',1);
INSERT INTO Faculty VALUES
(1,'Dr. Anita','Professor',   80000,1),
(2,'Mr. Biju', 'Asst Prof',   45000,2),
(3,'Dr. Carol','Professor',   90000,1),
(4,'Mr. David','Lecturer',    30000,3),
(5,'Dr. Elsa', 'Assoc Prof',  60000,2);

-- 1. Students in ascending DOB
SELECT * FROM Student ORDER BY dob ASC;

-- 2. Students from Computer department (JOIN with Dept)
SELECT s.* FROM Student s
JOIN Dept d ON s.dno = d.dno
WHERE d.dname = 'Computer';

-- 3. Faculty in descending salary
SELECT * FROM Faculty ORDER BY salary DESC;

-- 4. Total students per department
SELECT d.dname, COUNT(s.Sid) AS Total_Students
FROM Dept d
LEFT JOIN Student s ON d.dno = s.dno
GROUP BY d.dname;

-- 5. Faculties per department with salary > 25000
SELECT d.dname, COUNT(f.F_id) AS Faculty_Count
FROM Dept d
JOIN Faculty f ON d.dno = f.dno
WHERE f.salary > 25000
GROUP BY d.dname;

DROP TABLE IF EXISTS Faculty;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Dept;


-- =============================================================
-- EXPERIMENT 13: Salesmen Table - BETWEEN, IN, LIKE
-- =============================================================

CREATE TABLE Salesmen (
    Salesman_id   INT PRIMARY KEY,
    Name          VARCHAR(50),
    City          VARCHAR(50),
    Commission    DECIMAL(5,4)
);

INSERT INTO Salesmen VALUES (1, 'ANIKET',  'Paris',  0.11);
INSERT INTO Salesmen VALUES (2, 'BRUNO',   'Rome',   0.13);
INSERT INTO Salesmen VALUES (3, 'CAROL',   'London', 0.09);
INSERT INTO Salesmen VALUES (4, 'DMITRI',  'Paris',  0.115);
INSERT INTO Salesmen VALUES (5, 'ELENA',   'Berlin', 0.10);

-- 1. Commission between 0.10% and 0.12% (exclusive)
SELECT Salesman_id, Name, City, Commission
FROM Salesmen
WHERE Commission > 0.10 AND Commission < 0.12;

-- 2. From Paris OR Rome
SELECT * FROM Salesmen WHERE City IN ('Paris', 'Rome');

-- 3. Name starts with a letter between A and K
--    REGEXP: ^ anchors start, [A-Ka-k] matches A-K case-insensitively
SELECT * FROM Salesmen WHERE Name REGEXP '^[A-Ka-k]';

DROP TABLE IF EXISTS Salesmen;


-- =============================================================
-- EXPERIMENT 14: Sailors, Boats, Reserves - JOIN & Subqueries
-- =============================================================

CREATE TABLE Sailors (
    sid    INT PRIMARY KEY,
    sname  VARCHAR(50),
    rating INT,
    age    DECIMAL(4,1)
);

CREATE TABLE Boats (
    bid   INT PRIMARY KEY,
    bname VARCHAR(50),
    color VARCHAR(20)
);

CREATE TABLE Reserves (
    sid  INT,
    bid  INT,
    day  DATE,
    FOREIGN KEY (sid) REFERENCES Sailors(sid),
    FOREIGN KEY (bid) REFERENCES Boats(bid)
);

INSERT INTO Sailors VALUES
(22,'DUSTIN',7,45.0),(29,'BRUTUS',1,33.0),(31,'LUBBER',8,55.5),
(32,'ANDY',8,25.5),(58,'RUSTY',10,35.0),(64,'HORATIO',7,35.0),
(71,'ZORBA',10,16.0),(74,'HORATIO',9,35.0),(85,'ART',3,25.5),(95,'BOB',3,63.5);

INSERT INTO Boats VALUES
(101,'Interlake','blue'),(102,'Interlake','red'),(103,'Clipper','green'),
(104,'Marine','red');

INSERT INTO Reserves VALUES
(22,101,'1998-10-10'),(22,102,'1998-10-10'),(22,103,'1998-10-08'),
(22,104,'1998-10-07'),(31,102,'1998-11-10'),(31,103,'1998-11-06'),
(31,104,'1998-11-12'),(64,101,'1998-09-05'),(64,102,'1998-09-08'),
(74,103,'1998-09-08'),(95,103,'1998-10-08'),(85,101,'1999-10-06');

-- 1. All info of sailors who reserved boat 101
SELECT s.* FROM Sailors s
JOIN Reserves r ON s.sid = r.sid
WHERE r.bid = 101;

-- 2. Boat name reserved by Bob
SELECT b.bname FROM Boats b
JOIN Reserves r ON b.bid = r.bid
JOIN Sailors s ON s.sid = r.sid
WHERE s.sname = 'BOB';

-- 3. Names of sailors who reserved a RED boat, ordered by age
SELECT DISTINCT s.sname, s.age FROM Sailors s
JOIN Reserves r ON s.sid = r.sid
JOIN Boats b ON b.bid = r.bid
WHERE b.color = 'red'
ORDER BY s.age;

-- 4. Sailors who reserved at least one boat
SELECT DISTINCT s.sname FROM Sailors s
WHERE s.sid IN (SELECT sid FROM Reserves);

-- 5. Sailors who reserved TWO DIFFERENT boats on the SAME day
SELECT DISTINCT r1.sid FROM Reserves r1
JOIN Reserves r2 ON r1.sid = r2.sid
    AND r1.day = r2.day       -- same day
    AND r1.bid <> r2.bid;     -- different boat

-- 6. Sailor IDs who reserved RED or GREEN boat
SELECT DISTINCT s.sid FROM Sailors s
JOIN Reserves r ON s.sid = r.sid
JOIN Boats b ON b.bid = r.bid
WHERE b.color IN ('red', 'green');

-- 7. Name and age of the YOUNGEST sailor
SELECT sname, age FROM Sailors WHERE age = (SELECT MIN(age) FROM Sailors);

-- 8. Count of different sailor names
SELECT COUNT(DISTINCT sname) AS Distinct_Names FROM Sailors;

-- 9. Average age per rating level
SELECT rating, AVG(age) AS Avg_Age FROM Sailors GROUP BY rating;

-- 10. Average age per rating level with at least 2 sailors
SELECT rating, AVG(age) AS Avg_Age FROM Sailors
GROUP BY rating
HAVING COUNT(*) >= 2;

DROP TABLE IF EXISTS Reserves;
DROP TABLE IF EXISTS Boats;
DROP TABLE IF EXISTS Sailors;
