// Portfolio 4: Library Management System - MongoDB Document Model & Queries


// Switch to (or create) the library NoSQL database
use('library_nosql_db');

// 1. Drop existing collections to ensure a clean slate
db.borrowers.drop();
db.books.drop();

// 2. Insert Document Model: Borrowers with Embedded Loans and Fines
// In NoSQL document design, embedding related data avoids expensive multi-table joins.
db.borrowers.insertMany([
    {
        borrowerId: 1,
        firstName: "Alice",
        lastName: "Smith",
        email: "alice.smith@university.edu",
        membershipStatus: "Active",
        joinedDate: new Date("2025-09-01"),
        activeLoans: [
            {
                loanId: 101,
                bookId: 1,
                title: "Database System Concepts",
                isbn: "9780078022159",
                loanDate: new Date("2026-02-01"),
                dueDate: new Date("2026-02-15"),
                status: "Overdue",
                fine: {
                    fineId: 501,
                    amount: 5.50,
                    isPaid: false
                }
            }
        ]
    },
    {
        borrowerId: 2,
        firstName: "Bob",
        lastName: "Jones",
        email: "bob.jones@university.edu",
        membershipStatus: "Active",
        joinedDate: new Date("2025-10-15"),
        activeLoans: [
            {
                loanId: 102,
                bookId: 2,
                title: "Fundamentals of Database Systems",
                isbn: "9780133970777",
                loanDate: new Date("2026-02-10"),
                dueDate: new Date("2026-02-24"),
                status: "Borrowed",
                fine: null
            }
        ]
    },
    {
        borrowerId: 3,
        firstName: "Charlie",
        lastName: "Brown",
        email: "charlie.brown@university.edu",
        membershipStatus: "Active",
        joinedDate: new Date("2025-11-20"),
        activeLoans: []
    }
]);

// 3. Insert Document Model: Books with Embedded Categories and Authors
db.books.insertMany([
    {
        bookId: 1,
        title: "Database System Concepts",
        isbn: "9780078022159",
        publicationYear: 2019,
        category: {
            name: "Computer Science",
            description: "Books on algorithms, databases, and software engineering"
        },
        authors: [
            { firstName: "Abraham", lastName: "Silberschatz" }
        ],
        stockQuantity: 5
    },
    {
        bookId: 2,
        title: "Fundamentals of Database Systems",
        isbn: "9780133970777",
        publicationYear: 2015,
        category: {
            name: "Computer Science",
            description: "Books on algorithms, databases, and software engineering"
        },
        authors: [
            { firstName: "Ramez", lastName: "Elmasri" }
        ],
        stockQuantity: 3
    }
]);

// 4. CRUD OPERATIONS AND QUERIES

// Query A: Find all borrowers who currently have an 'Overdue' loan status
print("--- Overdue Loans Report ---");
db.borrowers.find({ "activeLoans.status": "Overdue" }).toArray();

// Query B: Update operation - Mark a fine as paid and update loan status
print("--- Updating Fine Status for Loan 101 ---");
db.borrowers.updateOne(
    { "activeLoans.loanId": 101 },
    { 
        $set: { 
            "activeLoans.$.status": "Returned",
            "activeLoans.$.fine.isPaid": true 
        } 
    }
);

// Query C: Aggregation Pipeline - Count total active loans per membership status
print("--- Aggregation Pipeline: Loan Distribution ---");
db.borrowers.aggregate([
    { $unwind: "$activeLoans" },
    { 
        $group: { 
            _id: "$membershipStatus", 
            totalActiveLoans: { $sum: 1 } 
        } 
    }
]).toArray();