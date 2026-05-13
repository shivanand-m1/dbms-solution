-- =============================================================
-- 20MCA134 ADVANCED DBMS LAB
-- PL/SQL Solutions
-- HOW TO USE (Linux Terminal):
--   Step 1 - Open text editor:    nano plsql_lab.sql
--            (paste any block below, save with Ctrl+O, exit Ctrl+X)
--   Step 2 - Connect to Oracle:   sqlplus username/password
--   Step 3 - Run the file:        @plsql_lab.sql
--            OR paste block directly into SQL*Plus prompt
-- NOTE: Each experiment is a self-contained block. Run one at a time.
-- =============================================================

-- -------------------------------------------------------------
-- REQUIRED SQL*Plus SETTINGS (keep these at top of every file)
-- -------------------------------------------------------------

-- Enables DBMS_OUTPUT.PUT_LINE to print on terminal.
-- Without this, all PUT_LINE output is silently ignored.
SET SERVEROUTPUT ON;

-- Suppresses the "old value / new value" echo for substitution
-- variables (&var). Keeps terminal output clean.
SET VERIFY OFF;

-- OPTIONAL: To stop DBMS_OUTPUT printing (if needed):
-- SET SERVEROUTPUT OFF;

-- -------------------------------------------------------------


-- ============================================================
-- EXPERIMENT 1: Function - Check if a Number is PRIME
-- ============================================================
-- Save this in prime_check.sql, then run: @prime_check.sql

CREATE OR REPLACE FUNCTION is_prime(n IN NUMBER)
RETURN VARCHAR2  -- returns 'PRIME' or 'NOT PRIME'
IS
    i       NUMBER := 2;
    is_p    BOOLEAN := TRUE;
BEGIN
    -- Numbers <= 1 are not prime by definition
    IF n <= 1 THEN
        RETURN 'NOT PRIME';
    END IF;

    -- Check divisibility from 2 up to n-1
    WHILE i < n LOOP
        IF MOD(n, i) = 0 THEN  -- MOD gives remainder
            is_p := FALSE;
            EXIT;               -- break out of loop as soon as factor found
        END IF;
        i := i + 1;
    END LOOP;

    IF is_p THEN
        RETURN 'PRIME';
    ELSE
        RETURN 'NOT PRIME';
    END IF;
END;
/

-- Call the function using anonymous block
BEGIN
    DBMS_OUTPUT.PUT_LINE('17 is: ' || is_prime(17));
    DBMS_OUTPUT.PUT_LINE('18 is: ' || is_prime(18));
END;
/



-- ============================================================
-- EXPERIMENT 2: Function - Factorial of a Number
-- ============================================================

CREATE OR REPLACE FUNCTION factorial(n IN NUMBER)
RETURN NUMBER
IS
    result NUMBER := 1;
    i      NUMBER := 1;
BEGIN
    -- Factorial of 0 or 1 is 1
    IF n < 0 THEN
        RETURN -1;  -- invalid input
    END IF;

    -- Multiply: result = 1 * 2 * 3 * ... * n
    WHILE i <= n LOOP
        result := result * i;
        i := i + 1;
    END LOOP;

    RETURN result;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('5! = ' || factorial(5));
    DBMS_OUTPUT.PUT_LINE('0! = ' || factorial(0));
END;
/


-- ============================================================
-- EXPERIMENT 3: Function - Sum of Two Numbers
-- ============================================================

CREATE OR REPLACE FUNCTION sum_two(a IN NUMBER, b IN NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN a + b;  -- simply return the sum
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Sum of 10 and 25 = ' || sum_two(10, 25));
END;
/


-- ============================================================
-- EXPERIMENT 4: Function - Print Weekday in Letters
-- ============================================================
-- Given a number 1-7, return the day name

CREATE OR REPLACE FUNCTION get_weekday(day_num IN NUMBER)
RETURN VARCHAR2
IS
    day_name VARCHAR2(20);
BEGIN
    -- CASE expression works like switch-case
    CASE day_num
        WHEN 1 THEN day_name := 'Monday';
        WHEN 2 THEN day_name := 'Tuesday';
        WHEN 3 THEN day_name := 'Wednesday';
        WHEN 4 THEN day_name := 'Thursday';
        WHEN 5 THEN day_name := 'Friday';
        WHEN 6 THEN day_name := 'Saturday';
        WHEN 7 THEN day_name := 'Sunday';
        ELSE        day_name := 'Invalid day number';
    END CASE;

    RETURN day_name;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Day 1: ' || get_weekday(1));
    DBMS_OUTPUT.PUT_LINE('Day 5: ' || get_weekday(5));
END;
/


-- ============================================================
-- EXPERIMENT 5: Function - Check if String is a PALINDROME
-- ============================================================

CREATE OR REPLACE FUNCTION is_palindrome(str IN VARCHAR2)
RETURN VARCHAR2
IS
    reversed_str VARCHAR2(200);
BEGIN
    -- REVERSE() reverses the string
    reversed_str := REVERSE(str);

    -- Compare original with reversed (case-insensitive using UPPER)
    IF UPPER(str) = UPPER(reversed_str) THEN
        RETURN str || ' is a PALINDROME';
    ELSE
        RETURN str || ' is NOT a PALINDROME';
    END IF;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(is_palindrome('MADAM'));
    DBMS_OUTPUT.PUT_LINE(is_palindrome('HELLO'));
    DBMS_OUTPUT.PUT_LINE(is_palindrome('RACECAR'));
END;
/


-- ============================================================
-- EXPERIMENT 6: Function - Maximum of Two Values
-- ============================================================

CREATE OR REPLACE FUNCTION max_of_two(a IN NUMBER, b IN NUMBER)
RETURN NUMBER
IS
BEGIN
    -- Simple IF-THEN-ELSE to compare two numbers
    IF a >= b THEN
        RETURN a;
    ELSE
        RETURN b;
    END IF;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Max of 45 and 72 = ' || max_of_two(45, 72));
    DBMS_OUTPUT.PUT_LINE('Max of 100 and 50 = ' || max_of_two(100, 50));
END;
/


-- ============================================================
-- EXPERIMENT 7: PROCEDURE - Sum of Two Numbers
-- ============================================================
-- Procedures use OUT parameters to return values (unlike functions)

CREATE OR REPLACE PROCEDURE sum_proc(
    a   IN  NUMBER,    -- IN parameter: input value
    b   IN  NUMBER,    -- IN parameter: input value
    res OUT NUMBER     -- OUT parameter: result is sent back
)
IS
BEGIN
    res := a + b;  -- assign sum to OUT parameter
END;
/

-- Call the procedure using an anonymous block
DECLARE
    result NUMBER;   -- local variable to hold the OUT value
BEGIN
    sum_proc(30, 50, result);  -- call procedure; result is filled by OUT param
    DBMS_OUTPUT.PUT_LINE('Sum = ' || result);
END;
/


-- ============================================================
-- EXPERIMENT 8: PROCEDURE - Count of Instructors in a Department
-- ============================================================
-- Prerequisite: assumes a table called FACULTY(F_id, fname, dno, dept_name, salary)
-- Create it if needed:
--   CREATE TABLE FACULTY (F_id INT, fname VARCHAR2(50), dept_name VARCHAR2(50), salary NUMBER);
--   INSERT INTO FACULTY VALUES (1,'Alice','CS',60000);
--   INSERT INTO FACULTY VALUES (2,'Bob','CS',55000);
--   INSERT INTO FACULTY VALUES (3,'Carol','Math',70000);
--   COMMIT;

CREATE OR REPLACE PROCEDURE count_instructors(
    dept_name_in IN  VARCHAR2,  -- name of department to search
    cnt          OUT NUMBER     -- how many instructors found
)
IS
BEGIN
    -- COUNT(*) with WHERE condition counts matching rows
    SELECT COUNT(*) INTO cnt
    FROM FACULTY
    WHERE UPPER(dept_name) = UPPER(dept_name_in);  -- case-insensitive compare
END;
/

DECLARE
    total NUMBER;
BEGIN
    count_instructors('CS', total);
    DBMS_OUTPUT.PUT_LINE('Instructors in CS dept: ' || total);
END;
/


-- ============================================================
-- EXPERIMENT 9: CURSOR - Display SID and RATING of all Sailors
-- ============================================================
-- Prerequisite: Sailors table must exist
-- CREATE TABLE Sailors (sid INT, sname VARCHAR2(50), rating INT, age NUMBER);
-- INSERT INTO Sailors VALUES (22,'DUSTIN',7,45.0);
-- INSERT INTO Sailors VALUES (31,'LUBBER',8,55.5);
-- INSERT INTO Sailors VALUES (64,'HORATIO',7,35.0);
-- COMMIT;

DECLARE
    -- Declare an explicit cursor for the query
    CURSOR sailor_cur IS
        SELECT sid, rating FROM Sailors;

    -- Variables to hold each row's values (same types as the columns)
    v_sid    Sailors.sid%TYPE;
    v_rating Sailors.rating%TYPE;
BEGIN
    OPEN sailor_cur;   -- open the cursor (execute the query)

    LOOP
        FETCH sailor_cur INTO v_sid, v_rating;  -- fetch one row at a time
        EXIT WHEN sailor_cur%NOTFOUND;           -- exit when no more rows

        DBMS_OUTPUT.PUT_LINE('SID: ' || v_sid || '  Rating: ' || v_rating);
    END LOOP;

    CLOSE sailor_cur;  -- always close cursor after use
END;
/


-- ============================================================
-- EXPERIMENT 10: CURSOR - Display Details of Employees
-- ============================================================
-- Prerequisite: Employee table (EMPNO, NAME, DEPT, SALARY, DESIG, BRANCH)
-- CREATE TABLE Employee (EMPNO VARCHAR2(10), NAME VARCHAR2(50), DEPT VARCHAR2(20),
--                        SALARY NUMBER, DESIG VARCHAR2(50), BRANCH VARCHAR2(50));
-- INSERT... COMMIT;

DECLARE
    -- %ROWTYPE creates a record variable matching all columns of the table
    CURSOR emp_cur IS
        SELECT * FROM Employee;

    emp_rec Employee%ROWTYPE;  -- one variable holds an entire row
BEGIN
    OPEN emp_cur;

    LOOP
        FETCH emp_cur INTO emp_rec;
        EXIT WHEN emp_cur%NOTFOUND;

        -- Access individual fields using dot notation
        DBMS_OUTPUT.PUT_LINE(
            'EMPNO: ' || emp_rec.EMPNO ||
            '  Name: ' || emp_rec.NAME ||
            '  Dept: ' || emp_rec.DEPT ||
            '  Salary: ' || emp_rec.SALARY
        );
    END LOOP;

    CLOSE emp_cur;
END;
/

