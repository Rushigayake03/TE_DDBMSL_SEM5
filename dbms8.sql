-- Scenario: 
-- You are maintaining the database for a bank. The database has a table named ACCOUNTS(acc_no, 
-- cust_name, balance). 
-- Tasks: 
-- 1. Insert 5 records into the ACCOUNTS table.  
-- 2. Start a transaction to perform the following operations:  
--  Deduct ₹5,000 from account number 1001.  
--  Add ₹5,000 to account number 1002.  
-- 3. Display the updated balances but rollback the transaction to undo the changes.  
-- 4. Repeat the same transfer and commit it permanently.  
-- 5. Demonstrate the use of SAVEPOINT and ROLLBACK TO SAVEPOINT by performing 
-- multiple deposits and reverting partially. 

-- (Optional) Create the table if it doesn't exist
CREATE TABLE IF NOT EXISTS ACCOUNTS (
    acc_no     INT PRIMARY KEY,
    cust_name  VARCHAR(50),
    balance    DECIMAL(12,2)
);

-- Insert 5 sample accounts
INSERT INTO ACCOUNTS (acc_no, cust_name, balance) VALUES
(1001, 'Amit',   55000.00),
(1002, 'Riya',   32000.00),
(1003, 'Karan',  41000.00),
(1004, 'Sneha',  27500.00),
(1005, 'Neha',   62000.00);

-- Check starting state
SELECT * FROM ACCOUNTS ORDER BY acc_no;





-- Start a new transaction
START TRANSACTION;

-- Deduct ₹5,000 from 1001
UPDATE ACCOUNTS
SET balance = balance - 5000
WHERE acc_no = 1001;

-- Add ₹5,000 to 1002
UPDATE ACCOUNTS
SET balance = balance + 5000
WHERE acc_no = 1002;

-- Show the temporary (uncommitted) state
SELECT * FROM ACCOUNTS WHERE acc_no IN (1001, 1002) ORDER BY acc_no;

-- Undo everything in this transaction
ROLLBACK;

-- Prove that balances are back to original
SELECT * FROM ACCOUNTS WHERE acc_no IN (1001, 1002) ORDER BY acc_no;






-- Start again
START TRANSACTION;

-- Repeat the transfer: 1001 -> 1002
UPDATE ACCOUNTS
SET balance = balance - 5000
WHERE acc_no = 1001;

UPDATE ACCOUNTS
SET balance = balance + 5000
WHERE acc_no = 1002;

-- Make the changes permanent
COMMIT;

-- Verify persistence after commit
SELECT * FROM ACCOUNTS WHERE acc_no IN (1001, 1002) ORDER BY acc_no;





-- Begin a fresh transaction
START TRANSACTION;

-- Mark a baseline point in the transaction
SAVEPOINT sp_start;

-- 1st deposit: add ₹2,000 to 1003
UPDATE ACCOUNTS
SET balance = balance + 2000
WHERE acc_no = 1003;

-- Mark a point after the first deposit
SAVEPOINT sp_after_first;

-- 2nd deposit: add ₹3,000 to 1004
UPDATE ACCOUNTS
SET balance = balance + 3000
WHERE acc_no = 1004;

-- Show both changes before partial rollback
SELECT * FROM ACCOUNTS WHERE acc_no IN (1003, 1004) ORDER BY acc_no;

-- Partially undo: revert to just after the first deposit (undo second)
ROLLBACK TO SAVEPOINT sp_after_first;

-- Show that 1003 kept +₹2,000, but 1004’s +₹3,000 was undone
SELECT * FROM ACCOUNTS WHERE acc_no IN (1003, 1004) ORDER BY acc_no;

-- Optionally release the savepoints (tidy up)
RELEASE SAVEPOINT sp_after_first;
RELEASE SAVEPOINT sp_start;

-- Keep the partial changes
COMMIT;

-- Final verification
SELECT * FROM ACCOUNTS WHERE acc_no IN (1003, 1004) ORDER BY acc_no;
