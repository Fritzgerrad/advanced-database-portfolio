-- Portfolio 1: Library Management System - Production Sample Data

USE library_db;

-- Insert Categories
INSERT INTO Categories (CategoryName, Description) VALUES 
('Computer Science', 'Books on algorithms, databases, and software engineering'),
('Mathematics', 'Books on calculus, linear algebra, and discrete math'),
('History', 'Books covering world history and civilizations');

-- Insert Authors
INSERT INTO Authors (FirstName, LastName, Bio) VALUES 
('Silberschatz', 'Abraham', 'Renowned database systems textbook author'),
('Elmasri', 'Ramez', 'Co-author of Fundamentals of Database Systems'),
('Stallings', 'William', 'Author of computer networking and architecture books');

-- Insert Books
INSERT INTO Books (Title, ISBN, PublicationYear, CategoryID, StockQuantity) VALUES 
('Database System Concepts', '9780078022159', 2019, 1, 5),
('Fundamentals of Database Systems', '9780133970777', 2015, 1, 3),
('Operating System Concepts', '9781118063330', 2018, 1, 4),
('Discrete Mathematics and Its Applications', '9780073383095', 2011, 2, 2);

-- Map Books to Authors (Junction Table)
INSERT INTO BookAuthors (BookID, AuthorID) VALUES 
(1, 1),
(2, 2),
(3, 1),
(4, 3);

-- Insert Borrowers
INSERT INTO Borrowers (FirstName, LastName, Email, Phone, MembershipStatus) VALUES 
('Alice', 'Smith', 'alice.smith@university.edu', '+2348012345678', 'Active'),
('Bob', 'Jones', 'bob.jones@university.edu', '+2348023456789', 'Active'),
('Charlie', 'Brown', 'charlie.brown@university.edu', '+2348034567890', 'Active');

-- Insert Loans
INSERT INTO Loans (BorrowerID, BookID, LoanDate, DueDate, Status) VALUES 
(1, 1, NOW() - INTERVAL 15 DAY, NOW() - INTERVAL 1 DAY, 'Overdue'),
(2, 2, NOW() - INTERVAL 5 DAY, NOW() + INTERVAL 9 DAY, 'Borrowed'),
(3, 3, NOW() - INTERVAL 20 DAY, NOW() - INTERVAL 6 DAY, 'Overdue');

-- Insert Fines for Overdue Loans
INSERT INTO Fines (LoanID, Amount, IsPaid) VALUES 
(1, 5.50, FALSE),
(3, 12.00, FALSE);