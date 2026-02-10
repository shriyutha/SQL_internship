/* 	A transaction is a group of SQL statments that must execute a single unit of work / single logical unit, mean either all executed or never.
All the transactions weill follow the ACID properties:
1. Atomicity		All or nothing	
2. Consistency		Valid state before & after	
3. Isolation		Concurrent transactions don’t interfere	
4. Durability		Committed data is permanent 

Isolation level: Isolation controls how transactions interact. 
3 main isolation levels: READ COMMITTED 
						 REPEATABLE READ	
						 SERIALIZABLE  
						 
Dirty read = reading uncommitted data, PostgreSQL does NOT allow dirty reads even at lowest level.				*/

----------------------------------------------------------------------------------------------------------------------------
-- Bank Accounts Table:
CREATE TABLE bank_accounts (
account_id INT PRIMARY KEY,
customer_name TEXT,
balance NUMERIC CHECK (balance >= 0));


-- Insert sample data:
INSERT INTO bank_accounts 
VALUES
(1, 'A', 1000),
(2, 'B', 5000),
(3, 'C', 1500),
(4, 'D', 2500),
(5, 'E', 3500);

-----------------------------------------------------

--Successful Transaction:
---- Transfer $200 from A → B
SELECT *
FROM bank_accounts;

START TRANSACTION;

UPDATE bank_accounts
SET balance = balance - 200
WHERE customer_name ='A';

UPDATE bank_accounts
SET balance = balance + 200
WHERE customer_name ='B';

COMMIT;

-- VALIDATION:
SELECT *
FROM bank_accounts;

-----------------------------------------------------

-- Simulate Failure + ROLLBACK:
START TRANSACTION;

UPDATE bank_accounts
SET balance = balance - 200
WHERE account_id = 1;

-- ERROR: Z account doesn't exist
UPDATE bank_accounts
SET balance = balance + 200
WHERE account_id = 999;

ROLLBACK;

-- VALIDATION:
SELECT *
FROM bank_accounts;

-----------------------------------------------------

-- Set Isolation Level:
START TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT balance 
FROM bank_accounts 
WHERE account_id = 1;

COMMIT;

--------------------------------------------------------------

-- Concurrent Update Problem: TO PREVENT DITRY READ -- Row is locked until commit.
START TRANSACTION;

SELECT balance FROM bank_accounts
WHERE account_id = 1
FOR UPDATE;

UPDATE bank_accounts
SET balance = balance - 200
WHERE account_id = 1;

COMMIT;

-----------------------------------------------------

