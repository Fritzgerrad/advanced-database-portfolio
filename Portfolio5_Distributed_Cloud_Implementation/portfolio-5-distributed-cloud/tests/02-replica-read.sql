-- Run on the REPLICA after the primary write has replicated.
USE library_db;
SELECT BorrowerID, FirstName, LastName, Email
FROM Borrowers WHERE Email = 'replication.check@example.test';
SELECT Title, StockQuantity FROM Books WHERE ISBN = '9780078022159';
SHOW REPLICA STATUS\G
