# advanced-database-portfolio
# Advanced Database Systems Portfolio (MIT 8103)

**Student Name:** Samuel Ochie  
**Student ID:** 301930377  
**Institution:** MIVA Open University  
**Course:** MIT 8103 Advanced Database Systems (2026/2027 Academic Session)  

---

## 📖 Case Study Overview: Library Management System

To maintain consistency across all portfolio activities[cite: 4], this repository models a comprehensive **Library Management System**. 

* **Nature of the Business/System:** A digital management platform designed for a public or university library to handle physical book inventory, member accounts, circulation tracking, and financial penalties.
* **Database Users:**
  * **Borrowers (Students/Members):** Search catalogues, view borrowing history, and check active loans/fines.
  * **Librarians / Staff:** Process check-outs and check-ins, register new members, and manage book inventories.
  * **System Administrators:** Oversee database performance, run reports, and manage staff roles.
* **Major Data Stored:**
  * **Books:** ISBN, title, author, publication year, category, and available stock.
  * **Borrowers:** Member ID, full name, email, membership status, and registration date.
  * **Loans:** Transaction records linking borrowers to checked-out books, due dates, and return statuses.
  * **Fines:** Financial penalties calculated for overdue book returns.
  * **Staff:** Employee records and administrative access levels.
* **Key Operations Supported:**
  * Searching the book catalogue by title, author, or category.
  * Registering and managing borrower accounts.
  * Executing book borrowing (check-out) and returning (check-in) transactions.
  * Automatically computing and tracking overdue fines.

---

## 🗂️ Repository Structure

This portfolio is organized into five core modules as required by the course guidelines[cite: 6]:

```text
advanced-database-portfolio/
│
├── portfolio-1-database-design/
│   ├── Ochie_Samuel_P1_Schema.sql
│   ├── Ochie_Samuel_P1_SampleData.sql
│   ├── Ochie_Samuel_P1_ConstraintTests.sql
│   └── screenshots/
│
├── portfolio-2-query-optimisation/
│   ├── Ochie_Samuel_P2_Queries.sql
│   ├── Ochie_Samuel_P2_Optimisation.sql
│   └── screenshots/
│
├── portfolio-3-transactions-concurrency/
│   ├── Ochie_Samuel_P3_Transactions.sql
│   └── screenshots/
│
├── portfolio-4-nosql/
│   ├── Ochie_Samuel_P4_MongoDB.js
│   └── screenshots/
│
├── portfolio-5-distributed-cloud/
│   └── Ochie_Samuel_P5_README.md
│
└── README.md