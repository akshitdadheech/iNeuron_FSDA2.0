USE DATABASE DEMO_DATABASE;

--1. Load the given dataset into snowflake with a primary key to Order Date column.

CREATE OR REPLACE TABLE AD_SALES_DATA (
order_id VARCHAR(50),
order_date VARCHAR(20) PRIMARY KEY,
ship_date VARCHAR(20),
ship_mode VARCHAR(15),
customer_name VARCHAR(50),
segment CHAR(15),
state VARCHAR(100),
country VARCHAR(100),
market CHAR(10),
region CHAR(20),
product_id VARCHAR(50),
category VARCHAR(30),
sub_category VARCHAR(30),
product_name VARCHAR2(200),
sales NUMBER(10,0),
quantity NUMBER(10,0),
discount FLOAT,
profit FLOAT,
shipping_cost FLOAT,
order_priority VARCHAR(20),
years NUMBER(10,0)
);


--2. Change the Primary key to Order Id Column

ALTER TABLE AD_SALES_DATA    --Dropping the primary key in order to assign it to the Order Id column
DROP PRIMARY KEY;

ALTER TABLE AD_SALES_DATA    
ADD PRIMARY KEY (ORDER_ID);

DESCRIBE TABLE AD_SALES_DATA; -- Primary key assigned to the Order Id column


--3. Check the data type for Order date and Ship date and mention in what data type it should be?

DESCRIBE TABLE AD_SALES_DATA; -- The data type was VARCHAR but it should be DATE

SELECT TO_DATE(ORDER_DATE,'YYYY-MM-DD') AS ORDER_DATE_NEW FROM AD_SALES_DATA LIMIT 10; --Changed the data type to date

SELECT TO_DATE(SHIP_DATE,'YYYY-MM-DD') AS SHIP_DATE_NEW FROM AD_SALES_DATA LIMIT 10; --Changed the data type to date


--4. Create a new column called order_extract and extract the number after the last ‘–‘from Order ID column.

ALTER TABLE AD_SALES_DATA                --Adding new column by the name of ORDER_EXTRACT
ADD COLUMN ORDER_EXTRACT NUMBER(20,0);

UPDATE AD_SALES_DATA                --Updating the column with numbers after the last '-' the ORDER_ID.
SET ORDER_EXTRACT = SPLIT_PART(ORDER_ID,'-',-1);


--5. Create a new column called Discount Flag and categorize it based on discount. Use ‘Yes’ if the discount is greater than zero else ‘No’.

ALTER TABLE AD_SALES_DATA        --Creating a new column by the name of DISCOUNT_FLAG
ADD COLUMN DISCOUNT_FLAG CHAR(5);

UPDATE AD_SALES_DATA             --Updating the column to 'Yes' if the disount is above 0 else 'No'.
SET DISCOUNT_FLAG = CASE WHEN DISCOUNT > 0 THEN 'Yes'
                    ELSE 'No' END;


--6. Create a new column called process days and calculate how many days it takes for each order id to process from the order to its shipment.

ALTER TABLE AD_SALES_DATA        --Adding a new column PROCESS_DAYS
ADD COLUMN PROCESS_DAYS NUMBER(20,0);

UPDATE AD_SALES_DATA             --Updating the data in the PROCESS_DAYS 
SET PROCESS_DAYS = TO_DATE(SHIP_DATE) - TO_DATE(ORDER_DATE);


--7. Create a new column called Rating and then based on the Process dates give rating like given below.
        --a. If process days less than or equal to 3days then rating should be 5
        --b. If process days are greater than 3 and less than or equal to 6 then rating should be 4
        --c. If process days are greater than 6 and less than or equal to 10 then rating should be 3
        --d. If process days are greater than 10 then the rating should be 2.

ALTER TABLE AD_SALES_DATA    --Creating new column RATING
ADD COLUMN RATING INT;

UPDATE AD_SALES_DATA       --Updating the RATING by PROCESS_DAYS depending upon how good or bad it was.
SET RATING = CASE WHEN PROCESS_DAYS <= 3 THEN 5
                  WHEN PROCESS_DAYS > 3 AND PROCESS_DAYS <= 6 THEN 4
                  WHEN PROCESS_DAYS > 6 AND PROCESS_DAYS <= 10 THEN 3
                  ELSE 2 END;

        
SELECT * FROM AD_SALES_DATA; --Check how the data looks.

----------THE END, THANK YOU // ASSIGNMENT COMPLETED :D----------