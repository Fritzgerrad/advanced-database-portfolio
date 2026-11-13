-- Minimal seed data for the replication demonstration.
USE library_db;
INSERT INTO Categories (CategoryName, Description) VALUES
('Database Systems', 'Database design and administration'),
('Literature', 'Fiction and literary works');
INSERT INTO Authors (FirstName, LastName) VALUES
('Abraham', 'Silberschatz'),
('George', 'Orwell');
INSERT INTO Books (Title, ISBN, PublicationYear, CategoryID, StockQuantity) VALUES
('Database System Concepts', '9780078022159', 2019, 1, 5),
('Animal Farm', '9780451526342', 1945, 2, 3);
INSERT INTO BookAuthors (BookID, AuthorID) VALUES (1,1), (2,2);
INSERT INTO Borrowers (FirstName, LastName, Email, Phone) VALUES
('Ada', 'Okafor', 'ada.okafor@example.test', '08000000001');
