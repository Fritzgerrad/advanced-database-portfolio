-- Portfolio 2: Library Management System - Complex Reporting Queries

USE library_db;

-- 1. Active Borrowers Overdue Report: Finds all borrowers with currently overdue books, 
-- calculating days overdue and the associated fine.
SELECT 
    b.BorrowerID,
    CONCAT(b.FirstName, ' ', b.LastName) AS BorrowerName,
    bk.Title AS BookTitle,
    l.LoanDate,
    l.DueDate,
    DATEDIFF(CURRENT_DATE(), l.DueDate) AS DaysOverdue,
    f.Amount AS FineAmount,
    f.IsPaid
FROM Borrowers b
JOIN Loans l ON b.BorrowerID = l.BorrowerID
JOIN Books bk ON l.BookID = bk.BookID
JOIN Fines f ON l.LoanID = f.LoanID
WHERE l.Status = 'Overdue' AND f.IsPaid = FALSE
ORDER BY DaysOverdue DESC
LIMIT 50;

-- 2. Category Popularity and Circulation Aggregation: Counts total loans per book category.
SELECT
    c.CategoryName,
    COUNT(l.LoanID) AS TotalTimesBorrowed,
    (SELECT COALESCE(SUM(b2.StockQuantity), 0)
       FROM Books b2
      WHERE b2.CategoryID = c.CategoryID) AS CurrentStockLevel
FROM Categories c
LEFT JOIN Books bk ON c.CategoryID = bk.CategoryID
LEFT JOIN Loans l ON bk.BookID = l.BookID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY TotalTimesBorrowed DESC;

-- 3. Borrower Loan History Summary: Aggregates total lifetime loans and active loans per user.
SELECT
    b.BorrowerID,
    b.Email,
    COUNT(l.LoanID) AS LifetimeLoans,
    SUM(l.Status IN ('Borrowed', 'Overdue')) AS ActiveLoansCount
FROM Borrowers b
JOIN Loans l ON b.BorrowerID = l.BorrowerID
GROUP BY b.BorrowerID, b.Email
ORDER BY LifetimeLoans DESC
LIMIT 50;