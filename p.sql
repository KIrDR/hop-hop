create tablespace VVS_QDATA_L5
  datafile 'VVS_QDATA_L5.dbf'
  size 10 m
  autoextend on next 5 m
  maxsize 30 m
  extent management local
  offline;

alter tablespace VVS_QDATA_L5 online;

ALTER SESSION SET "_ORACLE_SCRIPT"=true

---------------------== EASY ==---------------------------------
-- 1.	���������� ������� �������� ������ SGA. 
SELECT component, current_size
FROM v$sga_dynamic_components;
-- 2.	�������� ������ ���� ���������� ����������. 
show parameters;
SELECT name, value
FROM v$parameter;
-- 3.	�������� ������ ����������� ������.
select * from v$controlfile;
-- 4.	����������� PFILE.
create pfile = 'VVS_MyPFILE.ora' from spfile;
-- 5.	�������� ������� �� ���� ��������, ���� �� ������� ��������� ����. �������� �������� ���� ���������. �������� ������ � �������. ����������, ������� � �������� ������� ���������, �� ������ � ������ � ������. 
CREATE TABLE my_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100)
);
SELECT segment_name
FROM user_segments
WHERE segment_type = 'TABLE';
INSERT INTO my_table (id, name)
VALUES (1, 'John');
SELECT
    segment_name,
    extents,
    blocks,
    bytes
FROM
    user_segments
WHERE
    segment_name = 'MY_TABLE';

-- 6.	�������� �������� ���� ��������� ���� Oracle. ��� ��������� ��������� ������� ����� �����������. ��� ������� ������� ���������� � ��������� ������.
select * from v$process;
-- 7.	�������� �������� ���� ��������� ����������� � �� ������. 
SELECT
    tablespace_name,
    file_name
FROM
    dba_data_files;

-- 8.	�������� �������� ���� �����.
select * from dba_roles;
-- 9.	�������� �������� ���������� ��� ������������ ����. 
SELECT
    *
FROM
    dba_sys_privs
WHERE
    grantee = 'SYS';

-- 10.	�������� �������� ���� �������������.
SELECT
    username
FROM
    dba_users;

-- 11.	�������� ����.
CREATE ROLE my_role;
GRANT SELECT, INSERT, UPDATE ON my_table TO my_role;
alter session set "_ORACLE_SCRIPT" = true;

-- 12.	�������� ������������.
CREATE USER my_user IDENTIFIED BY 123;

-- 13.	�������� �������� ���� �������� ������������.
SELECT
    profile
FROM
    dba_profiles;

-- 14.	�������� �������� ���� ���������� ������� ������������.
SELECT
    profile,
    resource_name,
    limit
FROM
    dba_profiles;

-- 15.	�������� ������� ������������.
CREATE PROFILE my_profile LIMIT
    FAILED_LOGIN_ATTEMPTS 3
    PASSWORD_LOCK_TIME 1
    PASSWORD_LIFE_TIME 90;

-- 16.	�������� ������������������ S1, �� ���������� ����������������: ��������� �������� 1000; ���������� 10; ����������� �������� 0; ������������ �������� 10000; �����������; ���������� 30 �������� � ������; ������������� ���������� ��������. 
--�������� ������� T1 � ����� ��������� � ������� (INSERT) 10 �����, �� ���������� �� S1.
create sequence S1
  increment by 10
  start with 1000
  maxvalue 10000
  minvalue 10
  cycle
  cache 30   --cache 20
  order;  --order (the chronology of values is not guaranteed)
  
create table T1 
  (
   N1 NUMBER(20), 
   N2 NUMBER(20), 
   N3 NUMBER(20)
  );
  
insert into T1 values (s1.nextval, s1.nextval, s1.nextval);
select * from t1;
-- 17.	�������� ������� � ��������� ������� ��� ����� �� ������ � ����������������� ��� ������� ���������. ������� ��������� �������� � �������������� ������� Oracle.
create synonym SYN_T1 for T1;
create public synonym SYN_T1_2 for T1;
select * from syn_t1_2;

SELECT *
FROM ALL_SYNONYMS
WHERE SYNONYM_NAME = 'SYN_T1' OR SYNONYM_NAME = 'SYN_T1_2';

-- 18.	������������ ��������� ����, ��������������� ������������� � ��������� ���������� WHEN TO_MANY_ROWS � NO_DATA_FOUND.
DECLARE
  v_value1 NUMBER;
  v_value2 NUMBER;
BEGIN
  -- ��������� ���������� TOO_MANY_ROWS
  BEGIN
    SELECT n1
    INTO v_value1
    FROM t1
    where n1 = 1000 or n1 = 1010;

    DBMS_OUTPUT.PUT_LINE('Value 1: ' || v_value1);
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE('Too many rows found.');
  END;

  -- ��������� ���������� NO_DATA_FOUND
  BEGIN
    SELECT n1
    INTO v_value2
    FROM t1
    where n1 = 1030;

    DBMS_OUTPUT.PUT_LINE('Value 2: ' || v_value2);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No data found.');
  END;
END;

-- 19.	�������� �������� ���� ������ ����� �������� �������. 
select * from v$logfile;
-- 20.	���������� ������� ������ �������� �������. 
select * from v$log where status = 'CURRENT';
-- 21.	�������� �������� ����������� ������.
SELECT * FROM V$controlfile;
-- 22.	�������� ������� � �������� � ��� 100 �������. ������� ������� � �� �������� � �������������� �������.
-- �������� �������
CREATE TABLE my_table2 (
  id NUMBER,
  name VARCHAR2(50),
  age NUMBER
);

-- ������� 100 �������
BEGIN
  FOR i IN 1..100 LOOP
    INSERT INTO my_table2 (id, name, age)
    VALUES (i, 'Name ' || i, i * 2);
  END LOOP;
  COMMIT;
END;

-- ����� ������� � � ������� � �������������� �������
SELECT table_name, num_rows, last_analyzed
FROM all_tables
WHERE table_name = 'MY_TABLE2';

-- 23.	�������� ������ ��������� ���������� ������������. 
SELECT segment_name, segment_type
FROM dba_segments
WHERE tablespace_name = 'VVS_QDATA_L5';

-- 24.	�������� ������ ���� ��������, ��������� ������������. 
SELECT object_name, object_type
FROM all_objects
WHERE owner = 'SYS';

-- 25.	��������� ���������� ������, ������� ��������.
SELECT blocks
FROM dba_tables
WHERE table_name = 'MY_TABLE2';

-- 26.	�������� ������ ������� ������. 
SELECT sid, serial#, username, status
FROM v$session;

-- 27.	��������, ������������ �� ������������� �������� �������.
SELECT log_mode
FROM v$database;

-- 28.	�������� ������������� � ������������� �����������.
CREATE VIEW my_view (param1, param2)
AS
SELECT name, age
FROM my_table2;
drop view my_view;
select * from my_view(1, 2);
-- 29.	�������� database link � ������������� �����������.
GRANT CREATE DATABASE LINK TO C##VVS;

CREATE DATABASE LINK DB13 
   CONNECT TO C##VVS
   IDENTIFIED BY PASSWORD
   USING 'db13';

-- 30.	����������������� ��������� ����������.
BEGIN
  -- ���� ����, � ������� ����� ���������� ����������
  DECLARE
    -- ���������� ����������������� ����������
    custom_exception EXCEPTION;
    PRAGMA EXCEPTION_INIT(custom_exception, -20001); -- ���������� ���� ����������

  BEGIN
    -- ��������� ����������
    RAISE custom_exception;
  EXCEPTION
    WHEN custom_exception THEN
      -- ��������� ���������� �� ������� ������
      -- ��������, ���������� �������������� ��������
      -- ...

      -- ��������� ���������� �� ����� ������� �������
      RAISE;
  END;
EXCEPTION
  WHEN OTHERS THEN
    -- ��������� ���������� �� ����� ������� ������
    -- ��������, ���������� �������������� ��������
    -- ...
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
END;


---------------------== MEDIUM ==---------------------------------

-- 1.	�������� ���������, ������� ������� ������ ������� � �� �������� ��������� ��� ������������� ����������. �������� � ������������ ����������. ����������� ��������� ������.
CREATE OR REPLACE PROCEDURE GET_CUSTOMER_ORDERS_TOTAL(
    p_customer_name VARCHAR
)
IS
    v_customer_id CUSTOMERS.CUST_NUM%TYPE;
    v_total_amount number := 0;
BEGIN
    -- �������� ������������� ���������� �� ��� �����
    SELECT CUST_NUM INTO v_customer_id
    FROM CUSTOMERS
    WHERE COMPANY = p_customer_name;

    -- ������� ������ ������� � �� �������� ��������� ��� ���������� ����������
    FOR order_row IN (
        SELECT ord.ORDER_NUM, pr.DESCRIPTION, pr.PRICE
        FROM ORDERS ord
        inner join PRODUCTS pr on ord.PRODUCT = pr.PRODUCT_ID
        WHERE ord.CUST = v_customer_id
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Order Number: ' || order_row.ORDER_NUM || ', Product: ' || order_row.DESCRIPTION || ', Price: ' || order_row.PRICE);
        v_total_amount := v_total_amount + order_row.PRICE;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total Price for Customer ' || p_customer_name || ': ' || v_total_amount);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Customer not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

exec GET_CUSTOMER_ORDERS_TOTAL('JCP Inc.');


-- 2.	�������� �������, ������� ������������ ���������� ������� ���������� �� ������������ ������. ��������� � ����������, ���� ������ �������, ���� ��������� �������.
CREATE OR REPLACE FUNCTION COUNT_CUSTOMER_ORDERS(
    p_customer_name VARCHAR,
    p_start_date DATE,
    p_end_date DATE
)
RETURN INTEGER
IS
    v_customer_id CUSTOMERS.CUST_NUM%TYPE;
    v_order_count INTEGER := 0;
BEGIN
    -- �������� ������������� ���������� �� ��� �����
    SELECT CUST_NUM INTO v_customer_id
    FROM CUSTOMERS
    WHERE COMPANY = p_customer_name;

    -- ������������ ���������� ������� ��� ���������� ���������� � �������� �������
    SELECT COUNT(*) INTO v_order_count
    FROM ORDERS
    WHERE CUST = v_customer_id
    AND ORDER_DATE BETWEEN p_start_date AND p_end_date;

    RETURN v_order_count;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RETURN -1;
END;
/

DECLARE
    v_order_count INTEGER;
BEGIN
    v_order_count := COUNT_CUSTOMER_ORDERS('JCP Inc.', DATE '2007-01-01', DATE '2023-12-31');
    DBMS_OUTPUT.PUT_LINE('Number of orders: ' || v_order_count);
END;
/

-- 3.	�������� ���������, ������� ������� ������ ���� �������, ������������� �����������, � ��������� ����� ������ �� �����������. �������� � ������������ ����������. ����������� ��������� ������.
CREATE OR REPLACE PROCEDURE GET_CUSTOMER_PURCHASES(
    p_customer_name VARCHAR
)
IS
    v_customer_id CUSTOMERS.CUST_NUM%TYPE;
BEGIN
    -- �������� ������������� ���������� �� ��� �����
    SELECT CUST_NUM INTO v_customer_id
    FROM CUSTOMERS
    WHERE COMPANY = p_customer_name;

    -- ������� ������ �������, ������������� ��������� �����������, � ������ ������ �� �����������
    FOR purchase_row IN (
        SELECT P.DESCRIPTION, O.AMOUNT
        FROM ORDERS O
        JOIN PRODUCTS P ON O.MFR = P.MFR_ID AND O.PRODUCT = P.PRODUCT_ID
        WHERE O.CUST = v_customer_id
        ORDER BY O.AMOUNT ASC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Product: ' || purchase_row.DESCRIPTION || ', Sales Amount: ' || purchase_row.AMOUNT);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Customer not found or no purchases found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

BEGIN
    GET_CUSTOMER_PURCHASES('JCP Inc.');
END;
/

-- 4.	�������� �������, ������� ��������� ���������� � ������� Customers, � ���������� ��� ������������ ���������� ��� -1 � ������ ������. ��������� ������������� �������� �������, ����� ���� ����������, ������� �������� ��� ������ ������������������.
CREATE SEQUENCE SEQ_CUSTOMERS
    START WITH 3000
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

select SEQ_CUSTOMERS.nextval from dual;

CREATE OR REPLACE FUNCTION ADD_CUSTOMER(
    p_company VARCHAR,
    p_cust_rep INTEGER,
    p_credit_limit CUSTOMERS.CREDIT_LIMIT%type
)
RETURN INTEGER
IS
    v_customer_id CUSTOMERS.CUST_NUM%TYPE;
BEGIN
    -- ���������� ��� ���������� ��� ������ ������������������
    SELECT SEQ_CUSTOMERS.NEXTVAL INTO v_customer_id FROM DUAL;

    -- ��������� ������ ���������� � ������� Customers
    INSERT INTO CUSTOMERS (CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT)
    VALUES (v_customer_id, p_company, p_cust_rep, p_credit_limit);

    RETURN v_customer_id;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
/

DECLARE
    v_customer_id INTEGER;
BEGIN
    v_customer_id := ADD_CUSTOMER('123', 103, 1000);
    DBMS_OUTPUT.PUT_LINE('Customer ID: ' || v_customer_id);
END;
/
select * from customers;

-- 5.	�������� ���������, ������� ������� ������ �����������, � ������� �������� ����� ��������� �������. ��������� � ���� ������ �������, ���� ��������� �������. ����������� ��������� ������.
CREATE OR REPLACE PROCEDURE GET_CUSTOMERS_BY_TOTAL_SALES(
    p_start_date DATE,
    p_end_date DATE
)
IS
BEGIN
    -- ������� ������ ����������� � ������� �������� ����� ��������� ������� �� ��������� ������
    FOR customer_row IN (
        SELECT C.COMPANY, SUM(O.AMOUNT) AS TOTAL_SALES
        FROM CUSTOMERS C
        JOIN ORDERS O ON C.CUST_NUM = O.CUST
        WHERE O.ORDER_DATE BETWEEN p_start_date AND p_end_date
        GROUP BY C.COMPANY
        ORDER BY TOTAL_SALES DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Customer: ' || customer_row.COMPANY || ', Total Sales: ' || customer_row.TOTAL_SALES);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No customers found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

BEGIN
    GET_CUSTOMERS_BY_TOTAL_SALES(DATE '2007-01-01', DATE '2023-12-31');
END;
/

-- 6.	�������� �������, ������� ������������ ���������� ���������� ������� �� ������������ ������. ��������� � ���� ������ �������, ���� ��������� �������.
CREATE OR REPLACE FUNCTION COUNT_ORDERED_PRODUCTS(
    p_start_date DATE,
    p_end_date DATE
)
RETURN INTEGER
IS
    v_total_count INTEGER;
BEGIN
    -- ������������ ���������� ���������� ������� �� ��������� ������
    SELECT COUNT(*) INTO v_total_count
    FROM ORDERS
    WHERE ORDER_DATE BETWEEN p_start_date AND p_end_date;

    RETURN v_total_count;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
/
DECLARE
    v_count INTEGER;
BEGIN
    v_count := COUNT_ORDERED_PRODUCTS(DATE '2007-01-01', DATE '2023-12-31');
    DBMS_OUTPUT.PUT_LINE('Total Ordered Products: ' || v_count);
END;
/

-- 7.	�������� ���������, ������� ������� ������ �����������, � ������� ���� ������ � ���� ��������� �������. ��������� � ���� ������ �������, ���� ��������� �������. ����������� ��������� ������
CREATE OR REPLACE PROCEDURE GET_CUSTOMERS_WITH_ORDERS(
    p_start_date DATE,
    p_end_date DATE
)
IS
BEGIN
    -- ������� ������ �����������, � ������� ���� ������ � ��������� ��������� �������
    FOR customer_row IN (
        SELECT DISTINCT C.CUST_NUM, C.COMPANY
        FROM CUSTOMERS C
        JOIN ORDERS O ON C.CUST_NUM = O.CUST
        WHERE O.ORDER_DATE BETWEEN p_start_date AND p_end_date
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Customer ID: ' || customer_row.CUST_NUM || ', Company: ' || customer_row.COMPANY);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No customers found with orders in the specified period.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
BEGIN
    GET_CUSTOMERS_WITH_ORDERS(DATE '2007-01-01', DATE '2023-12-31');
END;
/

-- 8.	�������� �������, ������� ������������ ���������� ����������� ������������� ������. ��������� � ������������ ������.
CREATE OR REPLACE FUNCTION COUNT_CUSTOMERS_OF_PRODUCT(
    p_product_name VARCHAR2
)
RETURN INTEGER
IS
    v_total_count INTEGER;
BEGIN
    -- ������������ ���������� ����������� ������������� ������
    SELECT COUNT(DISTINCT CUST) INTO v_total_count
    FROM ORDERS
    WHERE PRODUCT = p_product_name;

    RETURN v_total_count;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
/
DECLARE
    v_count INTEGER;
BEGIN
    v_count := COUNT_CUSTOMERS_OF_PRODUCT('2A45C');
    DBMS_OUTPUT.PUT_LINE('Total Customers of Product: ' || v_count);
END;
/

-- 9.	�������� ���������, ������� ����������� �� 10% ��������� ������������� ������. �������� � ������������ ������. ����������� ��������� ������
CREATE OR REPLACE PROCEDURE INCREASE_PRODUCT_PRICE(
    p_product_name VARCHAR2
)
IS
BEGIN
    -- ����������� �� 10% ��������� ������������� ������
    UPDATE PRODUCTS
    SET PRICE = PRICE * 1.1
    WHERE DESCRIPTION = p_product_name;
    
    -- ���������, ���� �� ���������
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Product not found or no changes made.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Product price increased by 10%.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Product not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
BEGIN
    INCREASE_PRODUCT_PRICE('Ratchet Link');
END;
/

-- 10.	�������� �������, ������� ��������� ���������� �������, ����������� � ������������ ���� ��� ������������� ����������. ��������� � ����������, ���. ������.
CREATE OR REPLACE FUNCTION COUNT_ORDERS_BY_CUSTOMER_YEAR(
    p_customer VARCHAR2,
    p_year NUMBER
)
RETURN INTEGER
IS
    v_total_count INTEGER;
BEGIN
    -- ������������ ���������� �������, ����������� � ������������ ���� ��� ������������� ����������
    SELECT COUNT(*) INTO v_total_count
    FROM ORDERS O
    JOIN CUSTOMERS C ON O.CUST = C.CUST_NUM
    WHERE C.COMPANY = p_customer
      AND EXTRACT(YEAR FROM O.ORDER_DATE) = p_year;

    RETURN v_total_count;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
/
DECLARE
    v_count INTEGER;
BEGIN
    v_count := COUNT_ORDERS_BY_CUSTOMER_YEAR('JCP Inc.', 2008);
    DBMS_OUTPUT.PUT_LINE('Total Orders for Customer in Year: ' || v_count);
END;
/

---------------------== HARD ==---------------------------------

-- 1.	�������� ���������, ������� ��������� �����. ����������� ��������� ������. �������� �������, ������� ������������ ����������� ������ ��� ���������� ������.
CREATE OR REPLACE PROCEDURE ADD_ORDER(
    p_order_num INTEGER,
    p_order_date DATE,
    p_cust INTEGER,
    p_rep INTEGER,
    p_mfr CHAR,
    p_product CHAR,
    p_qty INTEGER,
    p_amount DECIMAL
)
IS
BEGIN
    -- ��������� ����� � ������� ORDERS
    INSERT INTO ORDERS (ORDER_NUM, ORDER_DATE, CUST, REP, MFR, PRODUCT, QTY, AMOUNT)
    VALUES (p_order_num, p_order_date, p_cust, p_rep, p_mfr, p_product, p_qty, p_amount);

    -- ������������ ���������
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- ���������� ���������� � ������ ������
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
BEGIN
    ADD_ORDER(1, DATE '2023-01-01', 1, 303030, 'MFR', 'PRODUCT', 10, 100.00);
END;
/
CREATE OR REPLACE TRIGGER ORDER_INTEGRITY_TRIGGER
BEFORE INSERT ON ORDERS
FOR EACH ROW
DECLARE
    v_product_qty INTEGER;
BEGIN
    -- ��������� ������� ������ � ��������� ����������
    SELECT QTY_ON_HAND INTO v_product_qty
    FROM PRODUCTS
    WHERE MFR_ID = :NEW.MFR
      AND PRODUCT_ID = :NEW.PRODUCT;

    IF v_product_qty IS NULL OR v_product_qty < :NEW.QTY THEN
        -- ����������� ����������, ���� ����� �� ������ ��� ���������� ������������
        RAISE_APPLICATION_ERROR(-20001, 'Invalid product or insufficient quantity.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- ����������� ����������, ���� ����� �� ������
        RAISE_APPLICATION_ERROR(-20002, 'Invalid product.');
    WHEN OTHERS THEN
        -- ����������� ���������� ��� ����� ������ ������
        RAISE_APPLICATION_ERROR(-20003, 'An error occurred: ' || SQLERRM);
END;
/

-- 2.	�������� �������, ������� ���������� ���������� ������� ���������� ��������� �� ������������ ������. ��������� � ����������, ���� ������ �������, ���� ��������� �������. ����������� ��������� ������.
CREATE OR REPLACE FUNCTION COUNT_ORDERS_BY_CUSTOMER_MONTHLY(
    p_customer VARCHAR2,
    p_start_date DATE,
    p_end_date DATE
)
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    -- ��������� ������ ��� ����������� ����������
    OPEN v_cursor FOR
        SELECT TO_CHAR(O.ORDER_DATE, 'YYYY-MM') AS MONTH,
               COUNT(*) AS ORDER_COUNT
        FROM ORDERS O
        JOIN CUSTOMERS C ON O.CUST = C.CUST_NUM
        WHERE C.COMPANY = p_customer
          AND O.ORDER_DATE >= p_start_date
          AND O.ORDER_DATE <= p_end_date
        GROUP BY TO_CHAR(O.ORDER_DATE, 'YYYY-MM')
        ORDER BY TO_CHAR(O.ORDER_DATE, 'YYYY-MM');

    RETURN v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        -- � ������ ������, ��������� ������ � ����������� ����������
        IF v_cursor IS NOT NULL THEN
            CLOSE v_cursor;
        END IF;
        RAISE;
END;
/

DECLARE
    v_result SYS_REFCURSOR;
    v_month VARCHAR2(7);
    v_order_count NUMBER;
BEGIN
    v_result := COUNT_ORDERS_BY_CUSTOMER_MONTHLY('JCP Inc.', DATE '2007-01-01', DATE '2023-12-31');

    -- ��������� ������ �� ������� � ������� ���������
    LOOP
        FETCH v_result INTO v_month, v_order_count;
        EXIT WHEN v_result%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Month: ' || v_month || ', Order Count: ' || v_order_count);
    END LOOP;

    -- ��������� ������
    CLOSE v_result;
END;
/


-- 3.	�������� ���������, ������� ������� � ������� ������ ���� �������, �� ������������� �� ����� ����������� � ������������ ���� �� �������� ���������� �� ������. �������� � ���. ����������� ��������� ������.
CREATE OR REPLACE PROCEDURE LIST_UNUSED_PRODUCTS(
    p_year NUMBER
)
IS
BEGIN
    FOR prod IN (
        SELECT P.MFR_ID, P.PRODUCT_ID, P.DESCRIPTION, P.QTY_ON_HAND
        FROM PRODUCTS P
        WHERE NOT EXISTS (
            SELECT 1
            FROM ORDERS O
            WHERE O.MFR = P.MFR_ID AND O.PRODUCT = P.PRODUCT_ID AND EXTRACT(YEAR FROM O.ORDER_DATE) = p_year
        )
        ORDER BY P.QTY_ON_HAND DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('MFR_ID: ' || prod.MFR_ID || ', PRODUCT_ID: ' || prod.PRODUCT_ID || ', DESCRIPTION: ' || prod.DESCRIPTION || ', QTY_ON_HAND: ' || prod.QTY_ON_HAND);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- ��������� ������
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
BEGIN
    LIST_UNUSED_PRODUCTS(2023);
END;
/

-- 4.	�������� �������, ������� ������������ ���������� ������� ���������� �� ������������ ���. ��������� � ���, ����� ����� ���������� ��� ���.
CREATE OR REPLACE FUNCTION COUNT_ORDERS_BY_CUSTOMER_YEAR(
    p_year NUMBER,
    p_customer_name VARCHAR2
)
RETURN NUMBER
IS
    v_order_count NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_order_count
    FROM ORDERS O
    JOIN CUSTOMERS C ON O.CUST = C.CUST_NUM
    WHERE (TO_CHAR(O.ORDER_DATE, 'YYYY') = TO_CHAR(p_year) OR p_year IS NULL)
      AND (C.COMPANY LIKE '%' || p_customer_name || '%' OR C.CUST_NUM LIKE '%' || p_customer_name || '%');

    RETURN v_order_count;
EXCEPTION
    WHEN OTHERS THEN
        -- � ������ ������, ����������� ����������
        RAISE;
END;
/
DECLARE
    v_order_count NUMBER;
BEGIN
    v_order_count := COUNT_ORDERS_BY_CUSTOMER_YEAR(2007, 'JCP Inc.');

    DBMS_OUTPUT.PUT_LINE('Order Count: ' || v_order_count);
EXCEPTION
    WHEN OTHERS THEN
        -- � ������ ������, ������� ��������� �� ������
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- 5.	�������� ���������, ������� ��������� ������� �� ������������� ������� ��������� � �������� �������, ������� ���������� (ASC, DESC). ����������� ��������� ������.
CREATE OR REPLACE PROCEDURE SORT_TABLE(
    p_column_name VARCHAR2,
    p_sort_order VARCHAR2
)
IS
    v_sort_query VARCHAR2(200);
    v_result_string VARCHAR2(200);
    CURSOR c_orders IS
        SELECT * FROM ORDERS ORDER BY p_column_name || ' ' || p_sort_order;
BEGIN
    FOR rec IN c_orders
    LOOP
        -- �������������� � ����� �����������
        v_result_string := rec.ORDER_NUM || ' ' || rec.ORDER_DATE || ' ' || rec.PRODUCT; 
        DBMS_OUTPUT.PUT_LINE(v_result_string);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- ��������� ������
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


BEGIN
    SORT_TABLE('ORDER_DATE', 'ASC');
END;
/
SELECT * FROM ORDERS ORDER BY ORDER_DATE ASC;