-- Portfolio 5: Distributed & Cloud Database Architecture
-- SQL command log for the MariaDB primary-replica exercise.
-- Run each section on the server indicated in its heading.

-- STEP 1: PRIMARY — Verify database initialization
SHOW DATABASES;
USE library_db;
SHOW TABLES;

-- STEP 2: PRIMARY — Verify binary logging configuration
SHOW VARIABLES LIKE 'server_id';
SHOW VARIABLES LIKE 'log_bin';
SHOW MASTER STATUS;

-- STEP 3: REPLICA — Configure the primary connection
STOP SLAVE;

CHANGE MASTER TO
  MASTER_HOST='library-primary',
  MASTER_PORT=3306,
  MASTER_USER='replicator',
  MASTER_PASSWORD='Replica_ChangeMe!',
  MASTER_LOG_FILE='mariadb-bin.000002',
  MASTER_LOG_POS=344;

-- STEP 4: REPLICA — Start and verify replication
START SLAVE;
SHOW SLAVE STATUS\G

-- STEP 5: REPLICA — Verify synchronized test data
USE library_db;

SELECT *
FROM Borrowers
WHERE Email = 'replication.check@example.test';

-- STEP 6: REPLICA — Verify the replicated book stock value
SELECT Title, StockQuantity
FROM Books
WHERE ISBN = '9780078022159';

-- STEP 7: REPLICA — Inspect read-only status during failure
USE library_db;

SELECT *
FROM Borrowers
WHERE Email = 'replication.check@example.test';

SELECT @@global.read_only;

-- STEP 8: REPLICA — Inspect table structure before promotion
USE library_db;
SHOW CREATE TABLE Borrowers\G

-- STEP 9: REPLICA — Manually promote the replica
STOP SLAVE;
RESET SLAVE ALL;
SET GLOBAL read_only = OFF;
SELECT @@global.read_only;

-- STEP 10: REPLICA — Test write capability after promotion
INSERT INTO Borrowers (FirstName, LastName, Email, Phone) 
VALUES ('Sam', 'Gerard', 'sam.gerard.@example.com', '08000000003');

SELECT * FROM Borrowers WHERE FirstName = 'Sam';
