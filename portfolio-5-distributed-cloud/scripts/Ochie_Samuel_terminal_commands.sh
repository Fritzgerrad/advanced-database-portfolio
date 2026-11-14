#!/usr/bin/env bash
# Portfolio 5: Distributed & Cloud Database Architecture
# Terminal command log for the MariaDB primary-replica exercise.
#
# Commands run as part of the setup to inspect local environment/configuration.

sudo systemctl is-active docker
sudo docker run hello-world
sudo dnf install docker-compose

# - Run each command at the appropriate step.

# STEP 1: Start the Docker Compose database environment
sudo docker compose up -d

# STEP 2: Check container status
sudo docker compose ps
sudo docker compose ps -a

# STEP 3: Diagnose the primary container (during initial setup)
sudo docker logs library-primary
sudo docker inspect library-primary --format='{{json .State.Health}}'

# STEP 4: Verify the primary database interactively
sudo docker exec -it library-primary mariadb -uroot -p

# STEP 5: Create a consistent seed dump from the primary
sudo docker exec library-primary sh -c 'mariadb-dump -uroot -p"$MARIADB_ROOT_PASSWORD" --single-transaction --master-data=2 --databases library_db' > library_seed.sql

# STEP 6: Inspect the seed dump
ls -lh library_seed.sql
grep -m1 'CHANGE MASTER TO' library_seed.sql

# STEP 7: Import the seed dump into the replica
sudo docker exec -i library-replica sh -c 'mariadb -uroot -p"$MARIADB_ROOT_PASSWORD"' < library_seed.sql

# STEP 8: Connect to the replica for replication configuration
sudo docker exec -it library-replica mariadb -uroot -p

# STEP 9: Run the primary write test
sudo docker exec -i library-primary sh -c 'mariadb -uroot -p"$MARIADB_ROOT_PASSWORD"' < scripts/Ochie_Samuel_primary_write.sql

# STEP 10: Run the replica read test
sudo docker exec -i library-replica sh -c 'mariadb -uroot -p"$MARIADB_ROOT_PASSWORD"' < scripts/Ochie_Samuel_replica_read.sql

# STEP 11: Simulate primary failure
sudo docker stop library-primary

# STEP 12: Check failure state
sudo docker compose ps -a

# STEP 13: Connect to the replica during the outage
sudo docker exec -it library-replica mariadb -uroot -p

# STEP 14: Manually promote the replica
sudo docker exec -it library-replica mariadb -uroot -p

