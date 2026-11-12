-- ============================================================================
-- SESSION B SCRIPT (Tab 2)
-- Library Management System (LMS) Concurrency & Transaction Test
-- ============================================================================

USE library_db;

-- ----------------------------------------------------------------------------
-- SCENARIO 1: LOST UPDATE ANOMALY (Steps 2 & 4)
-- ----------------------------------------------------------------------------

-- [2.] Session B: also read 1 before A writes.
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
SELECT BookID, Title, StockQuantity FROM Books WHERE BookID = 1;


-- [4.] Session B: write its stale value. The final count is 9, so one decrement is lost.
UPDATE Books SET StockQuantity = 9 WHERE BookID = 1;
COMMIT;
SELECT BookID, Title, StockQuantity FROM Books WHERE BookID = 1;


-- ----------------------------------------------------------------------------
-- SCENARIO 2: PESSIMISTIC LOCKING / FOR UPDATE (Steps 7 & 9)
-- ----------------------------------------------------------------------------

-- [7.] Session B: request the same row lock. This statement waits.
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
SELECT BookID, Title, StockQuantity FROM Books WHERE BookID = 1 FOR UPDATE;


-- [9.] Session B: its SELECT now returns 9. Apply the second increment and commit.
UPDATE Books SET StockQuantity = StockQuantity - 1 WHERE BookID = 1;
COMMIT;
SELECT BookID, Title, StockQuantity FROM Books WHERE BookID = 1;

