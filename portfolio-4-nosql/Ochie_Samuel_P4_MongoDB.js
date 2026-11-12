// Portfolio 4: Library Management System - MongoDB Document Model & Queries
// The data matches the SQL sample data from Portfolio 1 (same borrowers, books, loan ids and fine ids).

use('library_nosql_db');

// ---------------------------------------------------------------------------
// 1. Clean slate
// ---------------------------------------------------------------------------
db.borrowers.drop();
db.books.drop();

// ---------------------------------------------------------------------------
// 2. Schema validation: MongoDB is "schemaless" by default, but a validator gives the
//    collection the same basic guarantees as the NOT NULL / ENUM / CHECK rules in SQL.
// ---------------------------------------------------------------------------
db.createCollection('borrowers', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['borrowerId', 'firstName', 'lastName', 'email', 'membershipStatus', 'loans'],
            properties: {
                borrowerId: { bsonType: 'number' },
                email: { bsonType: 'string', pattern: '^.+@.+$' },
                membershipStatus: { enum: ['Active', 'Suspended', 'Expired'] },
                loans: {
                    bsonType: 'array',
                    items: {
                        bsonType: 'object',
                        required: ['loanId', 'bookId', 'dueDate', 'status'],
                        properties: {
                            status: { enum: ['Borrowed', 'Returned', 'Overdue'] },
                            fine: {
                                bsonType: ['object', 'null'],
                                properties: { amount: { bsonType: 'number', minimum: 0 } }
                            }
                        }
                    }
                }
            }
        }
    }
});

// ---------------------------------------------------------------------------
// 3. Indexes (the Mongo equivalent of the UNIQUE constraints and Portfolio 2 indexes)
// ---------------------------------------------------------------------------
db.borrowers.createIndex({ borrowerId: 1 }, { unique: true });
db.borrowers.createIndex({ email: 1 }, { unique: true });
db.borrowers.createIndex({ 'loans.status': 1 });          // multikey index on the embedded array
db.books.createIndex({ isbn: 1 }, { unique: true });
db.books.createIndex({ bookId: 1 }, { unique: true });

// ---------------------------------------------------------------------------
// 4. Borrowers with EMBEDDED loans (and each loan's fine).
// ---------------------------------------------------------------------------
const daysAgo = (n) => new Date(Date.now() - n * 24 * 60 * 60 * 1000);

db.borrowers.insertMany([
    {
        borrowerId: NumberInt(1),
        firstName: 'Alice',
        lastName: 'Smith',
        email: 'alice.smith@university.edu',
        membershipStatus: 'Active',
        joinedDate: new Date('2025-09-01'),
        loans: [
            {
                loanId: 1, bookId: 1,
                title: 'Database System Concepts',          // deliberate duplication, see README section 4
                isbn: '9780078022159',
                loanDate: daysAgo(15), dueDate: daysAgo(1),
                status: 'Overdue',
                fine: { fineId: 1, amount: 5.5, isPaid: false }
            }
        ]
    },
    {
        borrowerId: NumberInt(2),
        firstName: 'Bob',
        lastName: 'Jones',
        email: 'bob.jones@university.edu',
        membershipStatus: 'Active',
        joinedDate: new Date('2025-10-15'),
        loans: [
            {
                loanId: 2, bookId: 2,
                title: 'Fundamentals of Database Systems',
                isbn: '9780133970777',
                loanDate: daysAgo(5), dueDate: daysAgo(-9),   // due in 9 days
                status: 'Borrowed',
                fine: null
            }
        ]
    },
    {
        borrowerId: NumberInt(3),
        firstName: 'Charlie',
        lastName: 'Brown',
        email: 'charlie.brown@university.edu',
        membershipStatus: 'Suspended',
        joinedDate: new Date('2025-11-20'),
        loans: [
            {
                loanId: 3, bookId: 3,
                title: 'Operating System Concepts',
                isbn: '9781118063330',
                loanDate: daysAgo(20), dueDate: daysAgo(6),
                status: 'Overdue',
                fine: { fineId: 2, amount: 12.0, isPaid: false }
            }
        ]
    }
]);

// ---------------------------------------------------------------------------
// 5. Books with EMBEDDED category and authors
// ---------------------------------------------------------------------------
db.books.insertMany([
    {
        bookId: 1, title: 'Database System Concepts', isbn: '9780078022159', publicationYear: 2019,
        category: { name: 'Computer Science', description: 'Books on algorithms, databases, and software engineering' },
        authors: [{ firstName: 'Abraham', lastName: 'Silberschatz' }],
        stockQuantity: 5
    },
    {
        bookId: 2, title: 'Fundamentals of Database Systems', isbn: '9780133970777', publicationYear: 2015,
        category: { name: 'Computer Science', description: 'Books on algorithms, databases, and software engineering' },
        authors: [{ firstName: 'Ramez', lastName: 'Elmasri' }],
        stockQuantity: 3
    },
    {
        bookId: 3, title: 'Operating System Concepts', isbn: '9781118063330', publicationYear: 2018,
        category: { name: 'Computer Science', description: 'Books on algorithms, databases, and software engineering' },
        authors: [{ firstName: 'Abraham', lastName: 'Silberschatz' }],
        stockQuantity: 4
    },
    {
        bookId: 4, title: 'Discrete Mathematics and Its Applications', isbn: '9780073383095', publicationYear: 2011,
        category: { name: 'Mathematics', description: 'Books on calculus, linear algebra, and discrete math' },
        authors: [{ firstName: 'Kenneth', lastName: 'Rosen' }],
        stockQuantity: 2
    }
]);

// ---------------------------------------------------------------------------
// 6. QUERIES AND UPDATES
// ---------------------------------------------------------------------------

// Query A: borrowers who currently have an overdue loan
print('--- A. Overdue loans report ---');
db.borrowers.find(
    { 'loans.status': 'Overdue' },
    { _id: 0, firstName: 1, lastName: 1, 'loans.title': 1, 'loans.status': 1, 'loans.fine.amount': 1 }
).toArray();

// Query B: a single-document update. Return loan 1 and mark its fine as paid.
print('--- B. Return loan 1 and pay its fine ---');
db.borrowers.updateOne(
    { 'loans.loanId': 1 },
    {
        $set: {
            'loans.$.status': 'Returned',
            'loans.$.returnDate': new Date(),
            'loans.$.fine.isPaid': true
        }
    }
);
db.borrowers.find({ borrowerId: 1 }).toArray();

// Query C: aggregation 1 - number of loans and total unpaid fines per loan status
print('--- C. Loans per status and unpaid fines ---');
db.borrowers.aggregate([
    { $unwind: '$loans' },
    {
        $group: {
            _id: '$loans.status',
            totalLoans: { $sum: 1 },
            unpaidFines: {
                $sum: { $cond: [{ $eq: ['$loans.fine.isPaid', false] }, '$loans.fine.amount', 0] }
            }
        }
    },
    { $sort: { totalLoans: -1 } }
]).toArray();

// Query D: aggregation 2 - loans per book category, joining the two collections with $lookup
print('--- D. Loans per category ($lookup) ---');
db.borrowers.aggregate([
    { $unwind: '$loans' },
    { $lookup: { from: 'books', localField: 'loans.bookId', foreignField: 'bookId', as: 'book' } },
    { $unwind: '$book' },
    { $group: { _id: '$book.category.name', totalLoans: { $sum: 1 } } },
    { $sort: { totalLoans: -1 } }
]).toArray();

// Query E: evidence that the index is used (look for IXSCAN, not COLLSCAN, in winningPlan)
print('--- E. Execution plan for the overdue filter ---');
db.borrowers.find({ 'loans.status': 'Overdue' }).explain('executionStats');
