-- Run on the PRIMARY after replication has been configured.
USE library_db;
INSERT INTO Borrowers (FirstName, LastName, Email, Phone)
VALUES ('Replication', 'Test', 'replication.check@example.test', '08000000002');
UPDATE Books SET StockQuantity = StockQuantity - 1 WHERE ISBN = '9780078022159';
SELECT BorrowerID, FirstName, LastName, Email
FROM Borrowers WHERE Email = 'replication.check@example.test';
SELECT Title, StockQuantity FROM Books WHERE ISBN = '9780078022159';
