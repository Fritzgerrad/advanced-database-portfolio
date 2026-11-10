# Portfolio 1: Database Normalisation Report - Library Management System

## 1. Introduction
To ensure data integrity, eliminate redundancy, and prevent update, insertion, and deletion anomalies, the relational schema for the Library Management System has been normalised up to **Third Normal Form (3NF)**.

---

## 2. Normalisation Stages

### First Normal Form (1NF)
* **Rule:** All columns must contain atomic (indivisible) values, and each record must be unique.
* **Application:** 
  * Multivalued attributes such as a book's author list or a borrower's phone numbers were separated into distinct tables (`BookAuthors` and atomic scalar fields in `Borrowers`).
  * Every table has a clearly defined primary key (`BorrowerID`, `BookID`, `LoanID`, etc.).

### Second Normal Form (2NF)
* **Rule:** The relation must be in 1NF, and all non-key attributes must be fully functional dependent on the primary key (no partial dependencies).
* **Application:** 
  * In tables with composite primary keys (e.g., `BookAuthors` with composite key `(BookID, AuthorID)`), non-key attributes are fully dependent on the entire composite key, avoiding partial dependency issues.

### Third Normal Form (3NF)
* **Rule:** The relation must be in 2NF, and there must be no transitive dependencies (non-key attributes must not depend on other non-key attributes).
* **Application:**
  * **Categories Separation:** Instead of storing `CategoryName` and `CategoryDescription` directly inside the `Books` table (which would cause redundancy if multiple books share a category), a separate `Categories` table was created. `Books` only stores `CategoryID` as a foreign key.
  * **Authors Separation:** Similarly, author details (`FirstName`, `LastName`, `Bio`) are isolated in the `Authors` table and mapped via `BookAuthors`, preventing redundancy when an author writes multiple books.

---

## 3. Conclusion
The resulting database architecture achieves high relational integrity, fully satisfying 3NF requirements and protecting against data anomalies during concurrent library operations.