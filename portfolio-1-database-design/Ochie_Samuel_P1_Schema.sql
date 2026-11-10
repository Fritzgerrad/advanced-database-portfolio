-- Portfolio 1: Library Management System - Production Database Schema

DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db;
USE library_db;

-- 1. Authors Table (Normalized to support 2NF/3NF separation of author details)
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Bio TEXT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories Table (To avoid repeating category strings and ensure 3NF)
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) UNIQUE NOT NULL,
    Description TEXT NULL
);

-- 3. Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(150) NOT NULL,
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    PublicationYear YEAR NOT NULL,
    CategoryID INT NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 1 CHECK (StockQuantity >= 0),
    CONSTRAINT fk_book_category FOREIGN KEY (CategoryID) 
        REFERENCES Categories(CategoryID) 
        ON UPDATE CASCADE 
        ON DELETE RESTRICT
);

-- 4. BookAuthors Junction Table (Handles Many-to-Many relationship between Books and Authors)
CREATE TABLE BookAuthors (
    BookID INT NOT NULL,
    AuthorID INT NOT NULL,
    PRIMARY KEY (BookID, AuthorID),
    CONSTRAINT fk_ba_book FOREIGN KEY (BookID) 
        REFERENCES Books(BookID) 
        ON DELETE CASCADE,
    CONSTRAINT fk_ba_author FOREIGN KEY (AuthorID) 
        REFERENCES Authors(AuthorID) 
        ON DELETE CASCADE
);

-- 5. Borrowers Table
CREATE TABLE Borrowers (
    BorrowerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    MembershipStatus ENUM('Active', 'Suspended', 'Expired') DEFAULT 'Active',
    JoinedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Loans Table (Tracks book circulation)
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    BorrowerID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DueDate DATE NOT NULL,
    ReturnDate DATE NULL,
    Status ENUM('Borrowed', 'Returned', 'Overdue') DEFAULT 'Borrowed',
    CONSTRAINT fk_loan_borrower FOREIGN KEY (BorrowerID) 
        REFERENCES Borrowers(BorrowerID) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    CONSTRAINT fk_loan_book FOREIGN KEY (BookID) 
        REFERENCES Books(BookID) 
        ON UPDATE CASCADE 
        ON DELETE RESTRICT
);

-- 7. Fines Table (Tracks financial penalties for late returns)
CREATE TABLE Fines (
    FineID INT PRIMARY KEY AUTO_INCREMENT,
    LoanID INT NOT NULL,
    Amount DECIMAL(8, 2) NOT NULL CHECK (Amount >= 0.00),
    IsPaid BOOLEAN DEFAULT FALSE,
    PaidDate TIMESTAMP NULL,
    CONSTRAINT fk_fine_loan FOREIGN KEY (LoanID) 
        REFERENCES Loans(LoanID) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);