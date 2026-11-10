# Portfolio 2: Query Processing and Optimisation Report

## 1. Overview
This module demonstrates query tuning and performance optimisation for the Library Management System. By examining query execution plans using `EXPLAIN`, bottlenecks such as full table scans on high-traffic circulation tables were identified and resolved.

## 2. Identified Performance Bottlenecks
* **Table Scans on `Loans`:** Frequent checks for active or overdue loans by specific borrowers (`BorrowerID`) initially required scanning every record in the `Loans` table.
* **Lookups on `Books`:** Catalogue searches querying items by `ISBN` lacked targeted indexing.

## 3. Implemented Optimisation Strategies
1. **Composite Indexing (`idx_loans_borrower_status`):** Combined `BorrowerID` and `Status` into a single index to accelerate overdue queries.
2. **Column Indexing (`idx_books_isbn`):** Added a unique index on book ISBNs to ensure O(1) lookup performance during check-outs.
3. **Index on `Fines` (`idx_fines_ispaid`):** Optimized financial reporting for unpaid penalties.

## 4. Results
Post-optimisation `EXPLAIN` analyses confirm that database operations transitioned from costly full table scans (`type: ALL`) to efficient index lookups (`type: ref`), significantly lowering execution costs and resource utilization.