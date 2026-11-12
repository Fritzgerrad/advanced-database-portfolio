# Library Management System — Database Design

My case study records `Categories`, `Authors`, `Books`, `BookAuthors`, `Borrowers`, `Loans`, and `Fines`.

## Users

* Library borrowers (students/members) searching catalog books and viewing active loans or overdue fines.
* Library staff managing book stock, borrower registrations, loan check-outs, returns, and fine processing.
* System administrators monitoring database operations, constraints, transaction safety, and query performance.

## Main operations

* Register borrowers, catalog books, and maintain category/author mappings.
* Process book check-outs (loans) and check-ins (returns) while tracking physical stock quantities.
* Automatically track overdue loans and issue financial penalties (fines).
* Query overdue loans, loan history, and popular categories via optimized reporting operations.

## Entities

| Entity | Information stored |
| --- | --- |
| Categories | Genre and subject classification domains for library books. |
| Authors | Primary information and biographical data for book authors. |
| Books | Physical book catalog details, ISBN numbers, publication year, and stock balances. |
| BookAuthors | Junction mapping supporting many-to-many relationships between books and authors. |
| Borrowers | Member accounts including personal contact information and membership status. |
| Loans | Circulation log recording checked-out books, borrowers, loan dates, due dates, and statuses. |
| Fines | Financial penalties assessed on overdue borrowing transactions. |

## Categories

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| CategoryID | INT | PK | Yes |
| CategoryName | VARCHAR(100) | Unique | Yes |
| Description | TEXT |  | No |

- Unique key: (`CategoryName`).

## Authors

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| AuthorID | INT | PK | Yes |
| FirstName | VARCHAR(50) |  | Yes |
| LastName | VARCHAR(50) |  | Yes |
| Bio | TEXT |  | No |
| CreatedAt | TIMESTAMP |  | Yes (Default: `CURRENT_TIMESTAMP`) |

## Books

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| BookID | INT | PK | Yes |
| Title | VARCHAR(150) |  | Yes |
| ISBN | VARCHAR(20) | Unique | Yes |
| PublicationYear | YEAR |  | Yes |
| CategoryID | INT | FK | Yes |
| StockQuantity | INT |  | Yes (Default: `1`, Constraint: `>= 0`) |

- Unique key: (`ISBN`).
- CategoryID → `Categories.CategoryID` (`ON UPDATE CASCADE`, `ON DELETE RESTRICT`).

## BookAuthors

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| BookID | INT | PK, FK | Yes |
| AuthorID | INT | PK, FK | Yes |

- Composite Primary Key: (`BookID`, `AuthorID`).
- BookID → `Books.BookID` (`ON DELETE CASCADE`).
- AuthorID → `Authors.AuthorID` (`ON DELETE CASCADE`).

## Borrowers

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| BorrowerID | INT | PK | Yes |
| FirstName | VARCHAR(50) |  | Yes |
| LastName | VARCHAR(50) |  | Yes |
| Email | VARCHAR(100) | Unique | Yes |
| Phone | VARCHAR(20) |  | Yes |
| MembershipStatus | ENUM |  | Yes (Default: `'Active'`) |
| JoinedDate | TIMESTAMP |  | Yes (Default: `CURRENT_TIMESTAMP`) |

- Unique key: (`Email`).
- MembershipStatus values: `'Active'`, `'Suspended'`, `'Expired'`.

## Loans

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| LoanID | INT | PK | Yes |
| BorrowerID | INT | FK | Yes |
| BookID | INT | FK | Yes |
| LoanDate | TIMESTAMP |  | Yes (Default: `CURRENT_TIMESTAMP`) |
| DueDate | DATE |  | Yes |
| ReturnDate | DATE |  | No |
| Status | ENUM |  | Yes (Default: `'Borrowed'`) |

- BorrowerID → `Borrowers.BorrowerID` (`ON UPDATE CASCADE`, `ON DELETE CASCADE`).
- BookID → `Books.BookID` (`ON UPDATE CASCADE`, `ON DELETE RESTRICT`).
- Status values: `'Borrowed'`, `'Returned'`, `'Overdue'`.

## Fines

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| FineID | INT | PK | Yes |
| LoanID | INT | FK | Yes |
| Amount | DECIMAL(8,2) |  | Yes (Constraint: `>= 0.00`) |
| IsPaid | BOOLEAN |  | Yes (Default: `FALSE`) |
| PaidDate | TIMESTAMP |  | No |

- Unique key: (`LoanID`) — a loan has at most one fine (1 : 0..1).
- LoanID → `Loans.LoanID` (`ON UPDATE CASCADE`, `ON DELETE CASCADE`).

## Relationships and business rules

- Each registered borrower must have a distinct email address.
- Each catalogued book must possess a distinct International Standard Book Number (ISBN).
- Every loan transaction must reference an existing borrower (`BorrowerID`) and catalogued book (`BookID`).
- Stock quantity cannot drop below zero (`StockQuantity >= 0`).
- Fine amounts must be non-negative values (`Amount >= 0.00`).
- Books and Categories linked to active loans or records cannot be deleted (`ON DELETE RESTRICT`), maintaining referential integrity.
- Deleting a loan entry automatically cascades to clean up dependent fine penalty logs (`ON DELETE CASCADE`).

## Assumptions

- Each row in `Books` tracks physical inventory balance via `StockQuantity`.
- An author can co-author multiple books, and a single book can have multiple authors through `BookAuthors`.
- Transaction operations (such as borrowing a book) run inside atomic blocks (`START TRANSACTION` ... `COMMIT`/`ROLLBACK`) to decrement stock and log a loan simultaneously.
- Performance optimization relies on targeted composite indexes on `Loans(BorrowerID, Status)` and `Books(ISBN)` to accelerate high-frequency reporting queries.