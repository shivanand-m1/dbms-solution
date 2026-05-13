-- =============================================================
-- 20MCA134 ADVANCED DBMS LAB
-- PL/SQL Solutions - WITH TERMINAL INPUT PROMPTS
-- HOW TO USE (Linux Terminal):
--   Step 1 - Connect to Oracle:   sqlplus username/password
--   Step 2 - Run the file:        @ADBMS_Lab_PLSQL_INPUT.sql
--            OR paste any block directly into SQL*Plus prompt
-- NOTE: Each experiment is self-contained. Run one at a time.
--       &variable_name will PROMPT you to enter a value at terminal.
-- =============================================================

SET SERVEROUTPUT ON;
SET VERIFY OFF;


-- ============================================================
-- EXPERIMENT 1: Function - Check if a Number is PRIME
-- ============================================================

CREATE OR REPLACE FUNCTION is_prime(n IN NUMBER)
RETURN VARCHAR2
IS
    i    NUMBER := 2;
    is_p BOOLEAN := TRUE;
BEGIN
    IF n <= 1 THEN
        RETURN 'NOT PRIME';
    END IF;

    WHILE i < n LOOP
        IF MOD(n, i) = 0 THEN
            is_p := FALSE;
            EXIT;
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

-- Terminal will prompt: "Enter value for num: "
DECLARE
    v_num NUMBER := &num;   -- <-- user types the number here
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_num || ' is: ' || is_prime(v_num));
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
    IF n < 0 THEN
        RETURN -1;
    END IF;

    WHILE i <= n LOOP
        result := result * i;
        i := i + 1;
    END LOOP;

    RETURN result;
END;
/

DECLARE
    v_num NUMBER := &num;   -- prompt: "Enter value for num: "
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_num || '! = ' || factorial(v_num));
END;
/


-- ============================================================
-- EXPERIMENT 3: Function - Sum of Two Numbers
-- ============================================================

CREATE OR REPLACE FUNCTION sum_two(a IN NUMBER, b IN NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN a + b;
END;
/

DECLARE
    v_a NUMBER := &first_number;    -- prompt: "Enter value for first_number: "
    v_b NUMBER := &second_number;   -- prompt: "Enter value for second_number: "
BEGIN
    DBMS_OUTPUT.PUT_LINE('Sum of ' || v_a || ' and ' || v_b || ' = ' || sum_two(v_a, v_b));
END;
/


-- ============================================================
-- EXPERIMENT 4: Function - Print Weekday in Letters
-- ============================================================

CREATE OR REPLACE FUNCTION get_weekday(day_num IN NUMBER)
RETURN VARCHAR2
IS
    day_name VARCHAR2(20);
BEGIN
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

DECLARE
    v_day NUMBER := &day_number;    -- prompt: "Enter value for day_number: " (1-7)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Day ' || v_day || ' is: ' || get_weekday(v_day));
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
    reversed_str := REVERSE(str);

    IF UPPER(str) = UPPER(reversed_str) THEN
        RETURN str || ' is a PALINDROME';
    ELSE
        RETURN str || ' is NOT a PALINDROME';
    END IF;
END;
/

DECLARE
    v_str VARCHAR2(200) := '&input_string';   -- prompt: "Enter value for input_string: "
BEGIN
    DBMS_OUTPUT.PUT_LINE(is_palindrome(v_str));
END;
/


-- ============================================================
-- EXPERIMENT 6: Function - Maximum of Two Values
-- ============================================================

CREATE OR REPLACE FUNCTION max_of_two(a IN NUMBER, b IN NUMBER)
RETURN NUMBER
IS
BEGIN
    IF a >= b THEN
        RETURN a;
    ELSE
        RETURN b;
    END IF;
END;
/

DECLARE
    v_a NUMBER := &first_number;    -- prompt: "Enter value for first_number: "
    v_b NUMBER := &second_number;   -- prompt: "Enter value for second_number: "
BEGIN
    DBMS_OUTPUT.PUT_LINE('Max of ' || v_a || ' and ' || v_b || ' = ' || max_of_two(v_a, v_b));
END;
/


-- ============================================================
-- EXPERIMENT 7: PROCEDURE - Sum of Two Numbers
-- ============================================================

CREATE OR REPLACE PROCEDURE sum_proc(
    a   IN  NUMBER,
    b   IN  NUMBER,
    res OUT NUMBER
)
IS
BEGIN
    res := a + b;
END;
/

DECLARE
    v_a    NUMBER := &first_number;     -- prompt: "Enter value for first_number: "
    v_b    NUMBER := &second_number;    -- prompt: "Enter value for second_number: "
    result NUMBER;
BEGIN
    sum_proc(v_a, v_b, result);
    DBMS_OUTPUT.PUT_LINE('Sum of ' || v_a || ' and ' || v_b || ' = ' || result);
END;
/


-- ============================================================
-- EXPERIMENT 8: PROCEDURE - Count Instructors in a Department
-- ============================================================
-- Prerequisite:
--   CREATE TABLE FACULTY (F_id INT, fname VARCHAR2(50), dept_name VARCHAR2(50), salary NUMBER);
--   INSERT INTO FACULTY VALUES (1,'Alice','CS',60000);
--   INSERT INTO FACULTY VALUES (2,'Bob','CS',55000);
--   INSERT INTO FACULTY VALUES (3,'Carol','Math',70000);
--   COMMIT;

CREATE OR REPLACE PROCEDURE count_instructors(
    dept_name_in IN  VARCHAR2,
    cnt          OUT NUMBER
)
IS
BEGIN
    SELECT COUNT(*) INTO cnt
    FROM FACULTY
    WHERE UPPER(dept_name) = UPPER(dept_name_in);
END;
/

DECLARE
    v_dept VARCHAR2(50) := '&department_name';   -- prompt: "Enter value for department_name: "
    total  NUMBER;
BEGIN
    count_instructors(v_dept, total);
    DBMS_OUTPUT.PUT_LINE('Instructors in ' || v_dept || ' dept: ' || total);
END;
/


-- ============================================================
-- EXPERIMENT 9: CURSOR - Display SID and RATING of Sailors
-- ============================================================
-- Option A: Show ALL sailors (no input needed)
-- Option B: Filter by rating entered at terminal  <-- shown below
--
-- Prerequisite:
--   CREATE TABLE Sailors (sid INT, sname VARCHAR2(50), rating INT, age NUMBER);
--   INSERT INTO Sailors VALUES (22,'DUSTIN',7,45.0);
--   INSERT INTO Sailors VALUES (31,'LUBBER',8,55.5);
--   INSERT INTO Sailors VALUES (64,'HORATIO',7,35.0);
--   COMMIT;

-- Option A - Display ALL sailors (no filter)
DECLARE
    CURSOR sailor_cur IS
        SELECT sid, rating FROM Sailors;

    v_sid    Sailors.sid%TYPE;
    v_rating Sailors.rating%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- All Sailors ---');
    OPEN sailor_cur;
    LOOP
        FETCH sailor_cur INTO v_sid, v_rating;
        EXIT WHEN sailor_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('SID: ' || v_sid || '  Rating: ' || v_rating);
    END LOOP;
    CLOSE sailor_cur;
END;
/

-- Option B - Filter sailors by minimum rating entered at terminal
DECLARE
    v_min_rating NUMBER := &minimum_rating;   -- prompt: "Enter value for minimum_rating: "

    CURSOR sailor_cur IS
        SELECT sid, rating FROM Sailors WHERE rating >= v_min_rating;

    v_sid    Sailors.sid%TYPE;
    v_rating Sailors.rating%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Sailors with rating >= ' || v_min_rating || ' ---');
    OPEN sailor_cur;
    LOOP
        FETCH sailor_cur INTO v_sid, v_rating;
        EXIT WHEN sailor_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('SID: ' || v_sid || '  Rating: ' || v_rating);
    END LOOP;
    CLOSE sailor_cur;
END;
/


-- ============================================================
-- EXPERIMENT 10: CURSOR - Display Details of Employees
-- ============================================================
-- Option A: Show ALL employees (no input needed)
-- Option B: Filter by department entered at terminal  <-- shown below
--
-- Prerequisite:
--   CREATE TABLE Employee (EMPNO VARCHAR2(10), NAME VARCHAR2(50), DEPT VARCHAR2(20),
--                          SALARY NUMBER, DESIG VARCHAR2(50), BRANCH VARCHAR2(50));
--   INSERT... COMMIT;

-- Option A - Display ALL employees
DECLARE
    CURSOR emp_cur IS
        SELECT * FROM Employee;

    emp_rec Employee%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- All Employees ---');
    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO emp_rec;
        EXIT WHEN emp_cur%NOTFOUND;
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

-- Option B - Filter employees by department entered at terminal
DECLARE
    v_dept VARCHAR2(20) := '&department_name';   -- prompt: "Enter value for department_name: "

    CURSOR emp_cur IS
        SELECT * FROM Employee WHERE UPPER(DEPT) = UPPER(v_dept);

    emp_rec Employee%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Employees in ' || v_dept || ' ---');
    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO emp_rec;
        EXIT WHEN emp_cur%NOTFOUND;
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
