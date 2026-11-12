# Portfolio 1: Normalisation Report — Library Management System

## 1. Starting point: an unnormalised record

A first, naive design might keep everything about a loan in one flat table:

`LibraryRecord(LoanID, BorrowerName, BorrowerEmail, BorrowerPhone, ISBN, Title, CategoryName, CategoryDescription, AuthorNames, LoanDate, DueDate, ReturnDate, FineAmount, FineIsPaid)`

| LoanID | BorrowerName | BorrowerEmail | ISBN | Title | CategoryName | CategoryDescription | AuthorNames |
|---|---|---|---|---|---|---|---|
| 1 | Alice Smith | alice.smith@university.edu | 9780078022159 | Database System Concepts | Computer Science | Books on algorithms… | Abraham Silberschatz |
| 2 | Alice Smith | alice.smith@university.edu | 9780133970777 | Fundamentals of Database Systems | Computer Science | Books on algorithms… | Ramez Elmasri |
| 5 | Bob Jones | bob.jones@university.edu | 9780078022159 | Database System Concepts | Computer Science | Books on algorithms… | Abraham Silberschatz |

Problems this causes:
* **Update anomaly:** changing a category description, or Alice's email, means editing every row that repeats it.
* **Insertion anomaly:** a new book, borrower or category cannot be recorded until a loan exists.
* **Deletion anomaly:** deleting the only loan of a book also deletes the book's details.
* **Repeating group:** a co-authored book needs several author names in one cell.

## 2. Functional dependencies identified

* `LoanID → BorrowerID, BookID, LoanDate, DueDate, ReturnDate, Status`
* `BorrowerID → FirstName, LastName, Email, Phone, MembershipStatus, JoinedDate` (and `Email → BorrowerID`, since email is unique)
* `BookID → Title, ISBN, PublicationYear, CategoryID, StockQuantity` (and `ISBN → BookID`)
* `CategoryID → CategoryName, Description`
* `AuthorID → FirstName, LastName, Bio`
* `LoanID → FineID, Amount, IsPaid, PaidDate` (at most one fine per loan)

## 3. Normalisation stages

### First Normal Form (1NF)
* **Rule:** every column holds a single atomic value and every row is uniquely identifiable.
* **Violation found:** `AuthorNames` held several authors in one cell (a repeating group).
* **Fix:** authors moved to `Authors`, linked through the junction table `BookAuthors(BookID, AuthorID)`.
* Every table now has a primary key. `Phone` stays a single atomic column because the system stores one contact number per member.

### Second Normal Form (2NF)
* **Rule:** 1NF, and no non-key attribute depends on only *part* of a composite key.
* **Violation found:** once the author repeating group is flattened, the natural key of the flat table becomes `(LoanID, AuthorID)`. `Title` and `BorrowerEmail` depend only on `LoanID`/`BookID`, which is part of that key, so they are partial dependencies.
* **Fix:** separate tables per entity (`Books`, `Borrowers`, `Loans`, `Authors`). The only composite key left is `BookAuthors(BookID, AuthorID)`, which has **no** non-key attributes, so it cannot have partial dependencies.

### Third Normal Form (3NF)
* **Rule:** 2NF, and no non-key attribute depends on another non-key attribute (no transitive dependency).
* **Violation found:** `LoanID → BookID → CategoryID → CategoryName, CategoryDescription`. The category details depend on the book, not on the loan.
* **Fix:** `Categories` table; `Books` keeps only `CategoryID` as a foreign key. Borrower and book details are likewise reached through `BorrowerID` and `BookID`, never repeated in `Loans`.

## 4. Final relations (all in 3NF)

`Categories`, `Authors`, `Books`, `BookAuthors`, `Borrowers`, `Loans`, `Fines`, as shown in `Ochie_Samuel_P1_Design.md`.

## 5. Deliberate, documented denormalisation

Three columns store information that could be derived. They were kept on purpose:

| Column | Could be derived from | Why it is kept | Risk and control |
|---|---|---|---|
| `Loans.Status` | `ReturnDate` and `DueDate` | Fast filtering (`WHERE Status = 'Overdue'`) and indexing in Portfolio 2 | Can drift out of date; must be updated in the same transaction as returns, or refreshed by a scheduled job |
| `Fines.Amount` | days overdue × daily rate | The rate can change; the amount charged is a historical fact that must not change retroactively | Stored once at assessment time |
| `Books.StockQuantity` | total copies − open loans | Avoids counting loans on every catalogue search | Updated atomically with the loan insert (Portfolio 3, `sp_CheckoutBook`) |

A strict textbook 3NF design would compute these on demand. Storing them is a performance trade-off made knowingly, and the transaction design in Portfolio 3 is what keeps them consistent.

## 6. Conclusion
The schema removes the update, insertion and deletion anomalies of the flat design. Each fact is stored once: a category description in `Categories`, an author's details in `Authors`, a borrower's email in `Borrowers`.
