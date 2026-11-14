# Advanced Database Systems Portfolio (MIT 8103)

**Student Name:** Samuel Ochie  
**Student ID:** 301930377  
**Institution:** MIVA Open University  
**Course:** MIT 8103 Advanced Database Systems (2026/2027 Academic Session)  

---

## Case Study Overview: Library Management System

To maintain consistency across all portfolio activities, this repository models a comprehensive **Library Management System**. 

- **Nature of the Business/System:** A digital management platform designed for a public or university library to handle physical book inventory, member accounts, circulation tracking, and financial penalties.
- **Database Users:**
  - **Borrowers (Students/Members):** Search catalogues, view borrowing history, and check active loans/fines.
  - **Librarians / Staff:** Process check-outs and check-ins, register new members, and manage book inventories.
  - **System Administrators:** Oversee database performance, run reports, and manage staff roles.
- **Major Data Stored:**
  - **Books:** ISBN, title, author, publication year, category, and available stock.
  - **Borrowers:** Member ID, full name, email, membership status, and registration date.
  - **Loans:** Transaction records linking borrowers to checked-out books, due dates, and return statuses.
  - **Fines:** Financial penalties calculated for overdue book returns.
- **Key Operations Supported:**
  - Searching the book catalogue by title, author, or category.
  - Registering and managing borrower accounts.
  - Executing book borrowing (check-out) and returning (check-in) transactions.
  - Automatically computing and tracking overdue fines.

---

## Repository Structure



This portfolio is organized into five core modules as required by the course guidelines:

```
├── Ochie_Samuel_README.md
├── portfolio-1-database-design
│   ├── Ochie_Samuel_Full_ER_Diagram.erd
│   ├── Ochie_Samuel_P1_Case_Study_Description.md
│   ├── Ochie_Samuel_P1_ConstraintTests.sql
│   ├── Ochie_Samuel_P1_Design.md
│   ├── Ochie_Samuel_P1_ERDiagram.md
│   ├── Ochie_Samuel_P1_Normalisation.md
│   ├── Ochie_Samuel_P1_SampleData.sql
│   ├── Ochie_Samuel_P1_Schema.sql
│   └── screenshots
│       ├── Ochie_Samuel_Constraint_Proof_1.png
│       ├── Ochie_Samuel_Constraint_Proof_2.png
│       ├── Ochie_Samuel_Constraint_Proof_3.png
│       ├── Ochie_Samuel_Constraint_Proof_4.png
│       ├── Ochie_Samuel_ER_DIagram.png
│       └── Ochie_Samuel_Full_ER_Diagram.png
├── portfolio-2-query-optimisation
│   ├── Ochie_Samuel_BulkData.sql
│   ├── Ochie_Samuel_P2_Optimisation.sql
│   ├── Ochie_Samuel_P2_Queries.sql
│   ├── Ochie_Samuel_P2_README.md
│   └── screenshots
│       ├── Ochie_Samuel_Active_Borrowers_P2.png
│       ├── Ochie_Samuel_Borrowers_Loan_HIstory.png
│       ├── Ochie_Samuel_Bulk_Data_Result.png
│       ├── Ochie_Samuel_Category_Popularity_and_Circulation_Aggregation_P2.png
│       ├── Ochie_Samuel_Final_Books_Index.png
│       ├── Ochie_Samuel_Final_Fine_Index.png
│       ├── Ochie_Samuel_Final_Loans_Index.png
│       ├── Ochie_Samuel_Initial_Book_Index.png
│       ├── Ochie_Samuel_Initial_Fines_Index.png
│       ├── Ochie_Samuel_Initial_Loans_Index.png
│       ├── Ochie_Samuel_QA_after_indexing.png
│       ├── Ochie_Samuel_QA_before_indexing.png
│       ├── Ochie_Samuel_QB_after_indexing.png
│       ├── Ochie_Samuel_QB_before_indexing.png
│       ├── Ochie_Samuel_QC_after_indexing.png
│       ├── Ochie_Samuel_QC_before_indexing.png
│       ├── Ochie_Samuel_QD_after_indexing.png
│       ├── Ochie_Samuel_QD_before_indexing.png
│       ├── Ochie_Samuel_QE_after_indexing.png
│       ├── Ochie_Samuel_QE_before_indexing.png
│       ├── Ochie_Samuel_QF_after_indexing.png
│       ├── Ochie_Samuel_QF_before_indexing.png
│       └── Ochie_Samuel_Size_of_Indexes.png
├── portfolio-3-transactions-concurrency
│   ├── Ochie_Samuel_P3_Concurency_Demonstration_SessionA.sql
│   ├── Ochie_Samuel_P3_Concurency_Demonstration_SessionB.sql
│   ├── Ochie_Samuel_P3_README.md
│   ├── Ochie_Samuel_P3_Transaction_Commit_and _Rollback.sql
│   └── screenshots
│       ├── Ochie_Samuel_SC1.png
│       ├── Ochie_Samuel_SC2.png
│       └── Ochie_Samuel_SC3.png
├── portfolio-4-nosql
│   ├── Ochie_Samuel_P4_MongoDB.js
│   ├── Ochie_Samuel_P4_README.md
│   └── screenshots
│       ├── Ochie_Samuel_Books.png
│       ├── Ochie_Samuel_Borrowers.png
│       ├── Ochie_Samuel_Create Data Result.png
│       ├── Ochie_Samuel_Query_A.png
│       ├── Ochie_Samuel_Query_B.png
│       ├── Ochie_Samuel_Query_C.png
│       ├── Ochie_Samuel_Query_D.png
│       └── Ochie_Samuel_Query_E.png
└── portfolio-5-distributed-cloud
    ├── config
    │   ├── primary.cnf
    │   └── replica.cnf
    ├── docker-compose.yml
    ├── init
    │   ├──  Ochie_Samuel_01-schema.sql
    │   ├──  Ochie_Samuel_02-sample-data.sql
    │   └──  Ochie_Samuel_03-replication-user.sql
    ├── library_seed.sql
    ├── Ochie_Samuel_P5_README.md
    ├── screenshots
    │   ├── Ochie_Samuel_01_containers_healthy.png
    │   ├── Ochie_Samuel_02_primary_master_status.png
    │   ├── Ochie_Samuel_03_replica_slave_status.png
    │   ├── Ochie_Samuel_04_primary_write_test.png
    │   ├── Ochie_Samuel_05_replica_read_test.png
    │   ├── Ochie_Samuel_06_stopped_container.png
    │   ├── Ochie_Samuel_07_read_availability.png
    │   ├── Ochie_Samuel_08_replica_manual_promotion.png
    │   └── Ochie_Samuel_09_write_availability_proof.png
    └── scripts
        ├── Ochie_Samuel_primary_write.sql
        ├── Ochie_Samuel_replica_read.sql
        ├── Ochie_Samuel_sql_commands.sql
        └── Ochie_Samuel_terminal_commands.sh

```

## Module Breakdown & Execution Guide

### 1.  Relational Database Design (portfolio-1-database-design/) 
**Objective**: Design and implement a normalized relational schema (3NF) enforcing entity and referential integrity.  
**Execution**: Run *`Ochie_Samuel_P1_Schema.sql`* to build the tables, populate data via *`Ochie_Samuel_P1_SampleData.sql`*, and verify foreign key/check constraints using *`Ochie_Samuel_P1_ConstraintTests.sql`*.  
**Documentation & Evidence:** Detailed normalization steps *`Ochie_Samuel_P1_Normalisation.md`*, ER diagrams, and constraint violation proof screenshots.

### 2. Query Optimization & Indexing (portfolio-2-query-optimisation/)
**Objective**: Identify query performance bottlenecks and optimize execution plans using strategic indexing.  
**Execution**: Execute *`Ochie_Samuel_P2_Queries.sql`* to run baseline analytical queries, then apply indexes and compare EXPLAIN outputs via *`Ochie_Samuel_P2_Optimisation.sql`*.  
**Documentation & Evidence:** Optimization analysis report *`Ochie_Samuel_P2_README.md`*  and pre/post-indexing execution plan screenshots.

### 3. ACID Transactions & Concurrency Control (portfolio-3-transactions-concurrency/)  
**Objective**: Demonstrate transaction atomicity, rollback recovery, and concurrency anomaly prevention.  
**Execution:** Run *`Ochie_Samuel_P3_Transaction_Commit_and _Rollback.sql`* to observe COMMIT persistence and ROLLBACK recovery on constraint errors. Open two simultaneous database tabs and execute *`SessionA.sql`* and *`SessionB.sql`* step-by-step to reproduce a Lost Update anomaly under READ COMMITTED, then prevent it using pessimistic row-level locking (FOR UPDATE).  
**Documentation & Evidence:** Walkthrough guide *`Ochie_Samuel_P3_README.md`*.

### 4. NoSQL Document Modeling (portfolio-4-nosql/)  
**Objective:** Transition the library data model into a document-oriented MongoDB database to eliminate multi-table join overhead.  
**Execution:** Run *`Ochie_Samuel_P4_MongoDB.js`* in MongoDB Compass or mongosh to seed the borrowers and books collections with embedded arrays, filter overdue loans, perform positional updates (.$), and run $unwind/$group aggregation pipelines.  
**Documentation & Evidence:** Paradigm suitability comparison and MongoDB GUI result screenshots in *`Ochie_Samuel_P4_README.md`*.

### 5. Distributed & Cloud Database Architecture (`portfolio-5-distributed-cloud/`)

**Objective:** Implement a distributed MariaDB primary–replica architecture to demonstrate database replication, data synchronization, read availability, and manual failover during primary-server failure.

**Execution:** Deploy the MariaDB 10.11 primary and replica containers using Docker Compose. Configure binary logging and asynchronous replication, initialize the replica using a consistent database snapshot, execute write operations on the primary, and verify automatic synchronization on the replica. Simulate primary-server failure, confirm continued read availability on the replica, and manually promote the replica to accept write operations.

**Documentation & Evidence:** Architecture, configuration, replication procedures, availability and failure-behaviour analysis documented in *`Ochie_Samuel_P5_README.md`*, supported by Docker container status, primary binary log status, replica synchronization status, primary write-test, replica read-test, and manual failover screenshots.

## Technologies & Tools Used
**Relational DBMS:** MariaDB / MySQL 

**NoSQL DBMS:** MongoDB (v8.0.37)

**Database Clients:** DBeaver, MongoDB Compass

**Cloud & Distributed Architecture:** Docker, Linux, MongoDB Atlas Global Clusters

