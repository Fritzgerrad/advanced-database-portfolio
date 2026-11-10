-- Portfolio 2: Library Management System - Optimisation & Indexing

USE library_db;

-- STEP 1: Analyze query performance before indexing
-- Run EXPLAIN to check if the database engine performs a full table scan (type: ALL)
EXPLAIN SELECT * 
FROM Loans 
WHERE BorrowerID = 1 AND Status = 'Overdue';

EXPLAIN SELECT * 
FROM Books 
WHERE ISBN = '9780078022159';

-- STEP 2: Create strategic indexes to eliminate full table scans and speed up joins
-- Index on Loans foreign key and status column for fast filtering
CREATE INDEX idx_loans_borrower_status ON Loans(BorrowerID, Status);

-- Index on Books ISBN for rapid catalogue lookups
CREATE INDEX idx_books_isbn ON Books(ISBN);

-- Index on Fines payment status for quick financial reporting
CREATE INDEX idx_fines_ispaid ON Fines(IsPaid);

-- STEP 3: Re-evaluate execution plans after applying indexes
-- Check that 'type' changes from ALL to ref/range and 'key' shows the newly created index
EXPLAIN SELECT * 
FROM Loans 
WHERE BorrowerID = 1 AND Status = 'Overdue';

EXPLAIN SELECT * 
FROM Books 
WHERE ISBN = '9780078022159';