-- Portfolio 2: Library Management System - Optimisation & Indexing
--PREREQUISITE: Schema.sql, SampleData.sql and BulkData.sql have been run
-- (100,000 loans, 20,000 books), 

-- METHOD: for each query run EXPLAIN and ANALYZE BEFORE creating the index and again
-- AFTER. Record type / key / rows / actual time in the README results table.
-- EXPLAIN ANALYZE SELECT ...(shows actual time)
-- Run each query 3 times and record the median, the first run is often slower (cold cache).

USE library_db;

ANALYZE TABLE Loans, Books, Fines;

-- Show the indexes that ALREADY exist
SHOW INDEX FROM Loans;
SHOW INDEX FROM Books;
SHOW INDEX FROM Fines;

-- STEP 1: Analyze query performance before indexing

-- Q-A: overdue loans more than 30 days late (filter on Status + DueDate range).
ANALYZE SELECT COUNT(*) FROM Loans
WHERE Status = 'Overdue' AND DueDate < CURRENT_DATE - INTERVAL 30 DAY;

-- Q-B: catalogue search, title starts with a word.
ANALYZE SELECT BookID, Title FROM Books WHERE Title LIKE 'Database%';

-- Q-C: catalogue search with a LEADING wildcard (contains a word anywhere).
ANALYZE SELECT BookID, Title FROM Books WHERE Title LIKE '%Principles%';

-- Q-D: one member's open loans. fk_loan_borrower already indexes BorrowerID, so the baseline
-- is already `ref`, not a full scan. Included to measure how much a composite index adds on top.
ANALYZE SELECT * FROM Loans WHERE BorrowerID = 1234 AND Status = 'Borrowed';

-- Q-E: ISBN lookup. ISBN is UNIQUE, so an index ALREADY exists (access type const).
-- This is a control: no new index should be created for it.
ANALYZE SELECT * FROM Books WHERE ISBN = '9780001000100';

-- Q-F: total unpaid fines per borrower (join + filter on a low-selectivity boolean).
ANALYZE SELECT l.BorrowerID, SUM(f.Amount) AS UnpaidTotal FROM Fines f JOIN Loans l 
ON l.LoanID = f.LoanID WHERE f.IsPaid = FALSE GROUP BY l.BorrowerID;

-- STEP 2: Create strategic indexes to eliminate full table scans and speed up joins

-- Q-A: equality column first (Status), range column second (DueDate). T
CREATE INDEX idx_loans_status_due ON Loans (Status, DueDate);

-- Index on Books Title for rapid catalogue lookups
CREATE INDEX idx_books_title ON Books (Title);

-- Index on Loans foreign key and status column for fast filtering
CREATE INDEX idx_loans_borrower_status ON Loans (BorrowerID, Status);


ANALYZE TABLE Loans, Books, Fines;

-- STEP 3: AFTER (same queries, compare type / key / rows / time with the baseline)

ANALYZE SELECT COUNT(*) FROM Loans
WHERE Status = 'Overdue' AND DueDate < CURRENT_DATE - INTERVAL 30 DAY;

ANALYZE SELECT BookID, Title FROM Books WHERE Title LIKE 'Database%';

ANALYZE SELECT BookID, Title FROM Books WHERE Title LIKE '%Principles%';

ANALYZE SELECT * FROM Loans WHERE BorrowerID = 1234 AND Status = 'Borrowed';

ANALYZE SELECT * FROM Books WHERE ISBN = '9780001000100';

ANALYZE SELECT l.BorrowerID, SUM(f.Amount) AS UnpaidTotal
FROM Fines f JOIN Loans l ON l.LoanID = f.LoanID
WHERE f.IsPaid = FALSE
GROUP BY l.BorrowerID;


-- STEP 4: THE COST SIDE OF INDEXES (write overhead and size)

SELECT table_name,
       ROUND(data_length  / 1024 / 1024, 2) AS data_mb,
       ROUND(index_length / 1024 / 1024, 2) AS index_mb
FROM information_schema.tables
WHERE table_schema = 'library_db' AND table_name IN ('Loans', 'Books', 'Fines');
