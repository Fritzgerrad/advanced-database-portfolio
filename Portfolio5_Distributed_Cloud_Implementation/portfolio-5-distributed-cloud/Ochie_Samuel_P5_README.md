# Portfolio 5: Distributed and Cloud Database Exercise

**Course:** MIT 8103 – Advanced Database Systems  
**Case study:** Library Management System  
**Implementation:** MariaDB 10.11 primary–replica replication using Docker Compose  

## 1. Aim and scope

This exercise extends the relational Library Management System from Portfolio 1 into a two-node database topology. The primary node accepts application writes and records changes in its binary log. A separate replica reads that log and replays the changes. The replica is configured as read-only for ordinary application connections and can serve suitable read/reporting workloads.

The exercise demonstrates database deployment, asynchronous replication, read scaling, replication monitoring, consistency behaviour and a controlled manual promotion procedure. It is a local proof of concept, not a production cloud deployment. No AWS resources, multi-region failover, 99.99% availability, sub-50 ms latency or zero-data-loss guarantee are claimed by this implementation.

## 2. Architecture

```text
                    Application / SQL client
                       /              \
              WRITE /                  \ READ (after replication)
                    v                    v
          +----------------+    +----------------+
          | library-primary|    | library-replica|
          | MariaDB 10.11  |    | MariaDB 10.11  |
          | server_id=101  |    | server_id=102  |
          | Binary log     |    | Relay log      |
          | Read + write   |    | read_only=ON   |
          +-------+--------+    +--------^-------+
                  |                      |
                  +-- binlog stream -----+
                     asynchronous
                     replication
```

Both containers use separate persistent Docker volumes. Host ports are 3307 (primary) and 3308 (replica). Inside the Compose network, the replica reaches the primary using the service name `library-primary` and port 3306.

## 3. Files

- `docker-compose.yml` – defines the two MariaDB services, persistent volumes, health checks and port mappings.
- `config/primary.cnf` – enables the primary server ID and row-based binary logging.
- `config/replica.cnf` – assigns a different server ID, relay log and read-only setting.
- `init/01-schema.sql` – creates the seven-table relational schema from Portfolio 1.
- `init/02-sample-data.sql` – inserts a small dataset for testing.
- `init/03-replication-user.sql` – creates a dedicated replication account.
- `tests/` – contains SQL used to verify writes on the primary and reads on the replica.
- `.env.example` – example environment file for the local root password.

## 4. Deployment and configuration

### Prerequisites

Install Docker Engine and the Docker Compose plugin. Confirm they are available:

```bash
docker --version
docker compose version
```

### Start the two database nodes

From this directory:

```bash
cp .env.example .env
# Edit .env and set a strong local password.
docker compose up -d
docker compose ps
```

Wait until both services report healthy. The schema and sample data are loaded automatically on the primary's first initialisation. The init scripts run only when the database volume is empty; changing an init script later does not automatically re-run it against an existing volume.

### Create a consistent seed copy for the replica

The replica must start with a copy of the primary database and the matching binary-log coordinates. Load a consistent dump with the binary-log position recorded:

```bash
source .env
docker exec library-primary sh -c 'mariadb-dump -uroot -p"$MARIADB_ROOT_PASSWORD" --single-transaction --master-data=2 --databases library_db' > library_seed.sql
```

Inspect the dump and locate the commented `CHANGE MASTER TO` line:

```bash
grep -m1 'CHANGE MASTER TO' library_seed.sql
```

It contains the actual `MASTER_LOG_FILE` and `MASTER_LOG_POS` values for this running primary. Keep those values; do not copy example coordinates from another machine.

Import the seed into the replica:

```bash
docker exec -i library-replica sh -c 'mariadb -uroot -p"$MARIADB_ROOT_PASSWORD"' < library_seed.sql
```

Configure replication on the replica, replacing the file name and position with the values obtained from the dump:

```bash
docker exec -it library-replica mariadb -uroot -p
```

At the MariaDB prompt:

```sql
STOP SLAVE;
CHANGE MASTER TO
  MASTER_HOST='library-primary',
  MASTER_PORT=3306,
  MASTER_USER='replicator',
  MASTER_PASSWORD='Replica_ChangeMe!',
  MASTER_LOG_FILE='mariadb-bin.000001',
  MASTER_LOG_POS=1234;
START SLAVE;
SHOW SLAVE STATUS\G
```

The file name and position above are placeholders. Use the real values from `grep`; the replication password must match `init/03-replication-user.sql`. For a successful setup, verify `Slave_IO_Running: Yes`, `Slave_SQL_Running: Yes` and, after the initial catch-up, `Seconds_Behind_Master: 0`.

## 5. Replication test

Run the write script against the primary:

```bash
source .env
docker exec -i library-primary sh -c 'mariadb -uroot -p"$MARIADB_ROOT_PASSWORD"' < tests/01-primary-write.sql
```

Then run the read/verification script against the replica:

```bash
docker exec -i library-replica sh -c 'mariadb -uroot -p"$MARIADB_ROOT_PASSWORD"' < tests/02-replica-read.sql
```

The borrower with email `replication.check@example.test` and the reduced stock quantity for ISBN `9780078022159` should be visible on the replica. Record screenshots of the primary write result, replica query result and `SHOW SLAVE STATUS\G` output. The replica may lag briefly because replication is asynchronous; wait for the SQL thread to apply the event before concluding that replication has failed.

## 6. Availability and failure behaviour

This topology removes the replica as a single point of read availability, but it does not provide automatic failover. If the replica stops, the primary can continue accepting writes; replica reads are unavailable until it returns and catches up. If the primary fails, writes are unavailable until an administrator promotes a sufficiently up-to-date replica and redirects clients.

For a controlled local demonstration only, after confirming the replica has caught up, stop the primary:

```bash
docker stop library-primary
```

Promote the replica manually:

```bash
docker exec -it library-replica mariadb -uroot -p
```

```sql
STOP SLAVE;
RESET SLAVE ALL;
SET GLOBAL read_only=OFF;
SELECT @@read_only;
```

The result should be `0`. A test insert can now be performed on the promoted node. Do not restart the old primary and allow it to accept writes without a planned re-synchronisation procedure: doing so can create divergent histories or split-brain. This is a demonstration of manual promotion, not automatic high availability.

## 7. Sharding and partitioning design

The current executable deployment uses replication, not sharding. For a larger multi-campus library, a possible horizontal sharding key is `CampusID` (if added to the schema) or a stable hash of `BorrowerID`. Each shard would hold the borrower, loan and fine records assigned to its campus/hash range. A request routed by the shard key can be directed to one shard; global reports may need fan-out queries and aggregation across shards. Referential integrity across shards and rebalancing are additional operational challenges. The current seven-table schema has no `CampusID`, so this remains a proposed extension rather than an implemented feature.

## 8. Consistency and CAP considerations

MariaDB primary–replica replication here is asynchronous. A successful commit on the primary may not yet be present on the replica. A read routed immediately to the replica can therefore return stale data. Checkout, return and fine-payment transactions should read and write through the primary when read-after-write consistency is required. Catalogue and historical reporting queries can use the replica when a small replication delay is acceptable.

During a network partition, this design does not make both nodes independent writable primaries. The primary remains the write authority; the replica is not automatically promoted. This avoids routine multi-primary write conflicts but means writes may be unavailable during primary failure. The CAP discussion should therefore be tied to the actual deployment behaviour, not described as a simple switch that makes individual tables CP or AP.

## 9. Security and production limitations

The included credentials are for a disposable local demonstration only. Change them before running, do not commit `.env`, and do not expose database ports to the public internet. A production design would additionally require TLS, secret management, least-privilege application accounts, backups and restore tests, monitoring/alerting, automated failover with split-brain protection, replication-lag handling, capacity planning and a documented recovery procedure.

## 10. Evidence to capture for submission

1. `docker compose ps` showing both database containers healthy.
2. Primary `SHOW MASTER STATUS\G` output.
3. Replica `SHOW SLAVE STATUS\G` showing both replication threads running.
4. Primary write script result.
5. Replica query showing the replicated borrower and stock value.
6. Optional controlled manual-promotion screenshot showing `@@read_only = 0` after the primary has been stopped.

Save the screenshots in `screenshots/` and refer to them in this report. Do not claim a test passed until it has been executed and the output captured.

## 11. Conclusion

The exercise deploys a two-node MariaDB primary–replica topology for the Library Management System. It demonstrates binary-log-based asynchronous replication, separate database instances, read-only replica configuration, replication monitoring and a manual failover procedure. It also identifies the consistency lag and operational trade-offs of this architecture. Sharding and multi-region cloud deployment are discussed as future extensions rather than presented as completed implementation.
