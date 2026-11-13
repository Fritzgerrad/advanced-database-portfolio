-- ============================================================================
-- Portfolio 2: Bulk test data generator (Corrected)
-- This script adds realistic volume to test indexing more accurately: 
-- 5,000 borrowers, 12 extra categories, 20,000 books, 100,000 loans, ~50,000 fines

USE library_db;

DROP TABLE IF EXISTS _digits;
DROP TABLE IF EXISTS _nums;

CREATE TABLE _digits (d INT NOT NULL);
INSERT INTO _digits (d) VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

-- Fixed: Replaced incorrect minus signs with proper multiplication (*)
CREATE TABLE _nums AS
SELECT a.d + (b.d * 10) + (c.d * 100) + (e.d * 1000) + (f.d * 10000) + 1 AS n
FROM _digits a, _digits b, _digits c, _digits e, _digits f;

ALTER TABLE _nums ADD PRIMARY KEY (n);

-- Categories: ids 4..15
INSERT INTO Categories (CategoryName, Description)
SELECT CONCAT('Category ', n + 3), CONCAT('Generated category ', n + 3)
FROM _nums WHERE n <= 12;

-- Borrowers: ids 4..5003  (every 20th one is Suspended)
INSERT INTO Borrowers (FirstName, LastName, Email, Phone, MembershipStatus)
SELECT CONCAT('First', n),
       CONCAT('Last', n),
       CONCAT('user', n, '@university.edu'),
       CONCAT('+23480', LPAD(n, 8, '0')),
       IF(n MOD 20 = 0, 'Suspended', 'Active')
FROM _nums WHERE n <= 5000;

-- Books: ids 5..20004. Titles start with one of five words so prefix searches
-- ('Database%') match about 1/5 of the table.
INSERT INTO Books (Title, ISBN, PublicationYear, CategoryID, StockQuantity)
SELECT CONCAT(ELT(1 + (n MOD 5), 'Database', 'Network', 'Algorithm', 'Systems', 'Cloud'),
              ' Principles Vol ', n),
       CONCAT('978', LPAD(n + 1000000, 10, '0')),
       1990 + (n MOD 36),
       1 + (n MOD 15),
       1 + (n MOD 8)
FROM _nums WHERE n <= 20000;

-- Loans: 100,000 rows.
INSERT INTO Loans (BorrowerID, BookID, LoanDate, DueDate, ReturnDate, Status)
SELECT t.borrower,
       t.book,
       t.loan_ts,
       DATE_ADD(DATE(t.loan_ts), INTERVAL 14 DAY),
       CASE WHEN t.m IN (0, 1) THEN NULL
            ELSE DATE_ADD(DATE(t.loan_ts), INTERVAL 5 + (t.n MOD 20) DAY) END,
       CASE t.m WHEN 0 THEN 'Overdue' WHEN 1 THEN 'Borrowed' ELSE 'Returned' END
FROM (
    SELECT n,
           n MOD 10                        AS m,
           -- Fixed: Restored (*) for random pseudo-key generation
           1 + ((n * 7919)   MOD 5003)     AS borrower,
           1 + ((n * 104729) MOD 20004)    AS book,
           NOW() - INTERVAL (CASE n MOD 10
                                 WHEN 0 THEN 30 + (n MOD 690)
                                 WHEN 1 THEN (n DIV 10) MOD 10
                                 ELSE 15 + (n MOD 700)
                             END) DAY      AS loan_ts
    FROM _nums
) t;

-- Fines: one per overdue loan, and one per loan returned after its due date
INSERT INTO Fines (LoanID, Amount, IsPaid, PaidDate)
SELECT LoanID,
       -- Fixed: Restored multiplication (*) for fine amount calculation
       ROUND(0.50 * CASE WHEN Status = 'Overdue'
                         THEN DATEDIFF(CURRENT_DATE, DueDate)
                         ELSE DATEDIFF(ReturnDate, DueDate) END, 2),
       IF(Status = 'Returned', TRUE, FALSE),
       IF(Status = 'Returned', ReturnDate, NULL)
FROM Loans
WHERE LoanID > 3
  AND (Status = 'Overdue' OR (Status = 'Returned' AND ReturnDate > DueDate));

-- Clean up helpers and refresh optimiser statistics
DROP TABLE _nums;
DROP TABLE _digits;

ANALYZE TABLE Borrowers, Books, Loans, Fines;

-- Sanity check: expected roughly 5003 / 20004 / 100003 / 50000
SELECT (SELECT COUNT(*) FROM Borrowers) AS Borrowers,
       (SELECT COUNT(*) FROM Books)     AS Books,
       (SELECT COUNT(*) FROM Loans)     AS Loans,
       (SELECT COUNT(*) FROM Fines)     AS Fines;