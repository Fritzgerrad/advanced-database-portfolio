-- Portfolio 1: Library Management System - Constraint Verification Tests
-- This script tests database integrity enforcement. 
-- Expectation: Queries marked with "EXPECT ERROR" should fail execution.

USE library_db;

-- TEST 1: Unique Constraint Test on Borrower Email
-- EXPECT ERROR: Duplicate email violates UNIQUE constraint
INSERT INTO Borrowers (FirstName, LastName, Email, Phone) 
VALUES ('Test', 'User', 'alice.smith@university.edu', '+2348099999999');

-- TEST 2: Foreign Key Constraint Test on Loans
-- EXPECT ERROR: BorrowerID 999 does not exist in the Borrowers table
INSERT INTO Loans (BorrowerID, BookID, DueDate, Status) 
VALUES (999, 1, '2026-12-31', 'Borrowed');

-- TEST 3: Check Constraint Test on Stock Quantity
-- EXPECT ERROR: StockQuantity cannot be negative (-5)
INSERT INTO Books (Title, ISBN, PublicationYear, CategoryID, StockQuantity) 
VALUES ('Invalid Book Stock', '9789999999999', 2024, 1, -5);

-- TEST 4: Check Constraint Test on Fine Amount
-- EXPECT ERROR: Fine amount cannot be negative (-10.00)
INSERT INTO Fines (LoanID, Amount, IsPaid) 
VALUES (2, -10.00, FALSE);

-- TEST 5: Successful Valid Insertion
-- EXPECT SUCCESS: Valid data that complies with all relational rules
INSERT INTO Borrowers (FirstName, LastName, Email, Phone, MembershipStatus) 
VALUES ('Diana', 'Prince', 'diana.prince@university.edu', '+2348055555555', 'Active');
SELECT * FROM Borrowers WHERE Email = 'diana.prince@university.edu';