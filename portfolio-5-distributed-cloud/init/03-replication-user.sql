-- Dedicated account used by the replica to read the primary binary log.
CREATE USER IF NOT EXISTS 'replicator'@'%' IDENTIFIED BY 'Replica_ChangeMe!';
GRANT REPLICATION SLAVE ON *.* TO 'replicator'@'%';
FLUSH PRIVILEGES;
