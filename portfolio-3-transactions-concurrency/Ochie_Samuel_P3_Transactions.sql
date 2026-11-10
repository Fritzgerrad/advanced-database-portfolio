-- Portfolio 3: Library Management System - Transactions & Concurrency Control

USE library_db;

-- -------------------------------------------------------------------------
-- SCENARIO 1: ATOMICITY & ROLLBACK (Book Checkout Transaction)
-- When a borrower checks out a book, we must insert a loan record AND 
-- decrement the stock quantity atomically. If either fails, we rollback.
-- -------------------------------------------------------------------------

START TRANSACTION;

-- Step A: Insert the new loan record for BookID 2, BorrowerID 1
INSERT INTO Loans (BorrowerID, BookID, DueDate, Status) 
VALUES (1, 2, CURRENT_DATE() + INTERVAL 14 DAY, 'Borrowed');

-- Step B: Decrement the stock quantity of the borrowed book
UPDATE Books 
SET StockQuantity = StockQuantity - 1 
WHERE BookID = 2 AND StockQuantity > 0;

-- (Simulating an error check: If stock was 0, we would trigger a ROLLBACK. 
-- Here, everything is successful, so we COMMIT.)
COMMIT;


-- -------------------------------------------------------------------------
-- SCENARIO 2: HANDLING ERRORS WITH ROLLBACK
-- Demonstrating how a transaction aborts and rolls back changes upon error.
-- -------------------------------------------------------------------------

START TRANSACTION;

-- Attempting an invalid operation (e.g., assigning a fine with a negative amount or bad loan ID)
INSERT INTO Fines (LoanID, Amount, IsPaid) 
VALUES (99999, 15.00, FALSE); -- Fails due to non-existent Foreign Key (LoanID)

-- If an error is caught in your application logic, execute ROLLBACK:
ROLLBACK;

-- Verify that no partial changes or orphan records were written to the database.
SELECT * FROM Fines WHERE Amount = 15.00;


-- -------------------------------------------------------------------------
-- SCENARIO 3: CONCURRENCY & ROW-LEVEL LOCKING (Session Simulation)
-- To simulate multi-user concurrency:
-- 
-- In Session A (Run this block first, but DO NOT commit immediately):
-- -------------------------------------------------------------------------
START TRANSACTION;
SELECT StockQuantity FROM Books WHERE BookID = 1 FOR UPDATE; -- Acquires an exclusive row lock
UPDATE Books SET StockQuantity = StockQuantity - 1 WHERE BookID = 1;

-- While Session A is active (holding the lock), if Session B attempts to read 
-- or update BookID 1 with a shared/exclusive lock, Session B will block/wait 
-- until Session A releases the lock via COMMIT or ROLLBACK.

-- Once ready, release the lock:
COMMIT;