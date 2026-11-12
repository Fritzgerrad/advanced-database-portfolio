-- ============================================================================
-- SESSION A SCRIPT (Tab 1)
-- Library Management System (LMS) Concurrency & Transaction Test
-- ============================================================================

USE library_db;

-- ----------------------------------------------------------------------------
-- SETUP (Run once outside transactions to reset stock to 10)
-- ----------------------------------------------------------------------------
UPDATE Books SET StockQuantity = 10 WHERE BookID = 1;
SELECT BookID, Title, StockQuantity FROM Books WHERE BookID = 1;


-- ----------------------------------------------------------------------------
-- SCENARIO 1: LOST UPDATE ANOMALY (Steps 1 & 3)
-- ----------------------------------------------------------------------------

-- [1.] Session A: read 1.
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
SELECT BookID, Title, StockQuantity FROM Books WHERE BookID = 1;


-- [3.] Session A: write the value calculated from its earlier read.
UPDATE Books SET StockQuantity = 9 WHERE BookID = 1;
COMMIT;


-- ----------------------------------------------------------------------------
-- RESET FOR SCENARIO 2 (Run outside transaction)
-- ----------------------------------------------------------------------------
UPDATE Books SET StockQuantity = 10 WHERE BookID = 1;
SELECT BookID, Title, StockQuantity FROM Books WHERE BookID = 1;


-- ----------------------------------------------------------------------------
-- SCENARIO 2: PESSIMISTIC LOCKING / FOR UPDATE (Steps 6 & 8)
-- ----------------------------------------------------------------------------

-- [6.] Session A: lock the row before reading.
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
SELECT BookID, Title, StockQuantity FROM Books WHERE BookID = 1 FOR UPDATE;


-- [8.] Session A: update and release the lock by committing.
UPDATE Books SET StockQuantity = 9 WHERE BookID = 1;
COMMIT;


