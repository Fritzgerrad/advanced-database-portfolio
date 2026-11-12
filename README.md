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

```text
advanced-database-portfolio/
├── portfolio-1-database-design/
│   ├── Full ER Diagram.erd
│   ├── Ochie_Samuel_P1_Case_Study_Description.md
│   ├── Ochie_Samuel_P1_ConstraintTests.sql
│   ├── Ochie_Samuel_P1_Design.md
│   ├── Ochie_Samuel_P1_ERDiagram.md
│   ├── Ochie_Samuel_P1_Normalisation.md
│   ├── Ochie_Samuel_P1_SampleData.sql
│   ├── Ochie_Samuel_P1_Schema.sql
│   └── screenshots/
│       ├── Constraint Proof 1.png
│       ├── Constraint Proof 2.png
│       ├── Constraint Proof 3.png
│       ├── Constraint Proof 4.png
│       ├── ER_DIagram.png
│       └── Full ER Diagram.png
├── portfolio-2-query-optimisation/
│   ├── Ochie_Samuel_P2_Optimisation.sql
│   ├── Ochie_Samuel_P2_Queries.sql
│   ├── Ochie_Samuel_P2_README.md
│   └── screenshots/
│       ├── Ochie_Samuel_P2_Optimization_Result.png
│       ├── Ochie_Samuel_P2_Query_Result.png
│       └── Ochie_Samuel_P2_Result_Comparison.png
├── portfolio-3-transactions-concurrency/
│   ├── Ochie_Samuel_P3_Concurency_Demonstration_SessionA.sql
│   ├── Ochie_Samuel_P3_Concurency_Demonstration_SessionB.sql
│   ├── Ochie_Samuel_P3_README.md
│   ├── Ochie_Samuel_P3_Transaction_Commit_and _Rollback.sql
│   └── screenshots/
│       ├── SC1.png
│       ├── SC2.png
│       └── SC3.png
├── portfolio-4-nosql/
│   ├── Ochie_Samuel_P4_MongoDB.js
│   ├── Ochie_Samuel_P4_README.md
│   └── screenshots/
│       ├── Books.png
│       ├── Borrowers.png
│       ├── Query_A.png
│       ├── Query_B.png
│       └── Query_C.png
├── portfolio-5-distributed-cloud/
│   └── Ochie_Samuel_P5_README.md
└── README.md
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
**Execution:** Run `*Ochie_Samuel_P4_MongoDB.js*` in MongoDB Compass or mongosh to seed the borrowers and books collections with embedded arrays, filter overdue loans, perform positional updates (.$), and run $unwind/$group aggregation pipelines.  
**Documentation & Evidence:** Paradigm suitability comparison and MongoDB GUI result screenshots in *`Ochie_Samuel_P4_README.md`*.

### 5. Distributed & Cloud Database Architecture (portfolio-5-distributed-cloud/)  
**Objective:** Architect a fault-tolerant, multi-region cloud deployment capable of high availability and horizontal scaling.  
Documentation in *`Ochie_Samuel_P5_README.md`*: Covers multi-tier AWS cloud topology (Route 53, ALB, Auto-Scaling, Redis caching), Primary-Replica read scaling, horizontal sharding on BorrowerID, and CAP theorem consistency trade-offs (CP for inventory/fines vs. AP for catalogue browsing).

## Technologies & Tools Used
**Relational DBMS:** MariaDB / MySQL 

**NoSQL DBMS:** MongoDB (v8.0.37)

**Database Clients:** DBeaver, MongoDB Compass

**Cloud & Distributed Architecture:** AWS (Route 53, CloudFront, ALB, ASG, ElastiCache Redis), MongoDB Atlas Global Clusters

