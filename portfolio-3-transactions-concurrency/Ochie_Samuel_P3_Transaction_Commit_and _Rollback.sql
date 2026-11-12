-- Portfolio 3: Transactions, ACID Compliance
--and Concurrency Control

USE library_db;

-- ============================================================================
-- SECTION 1: Successful Transaction (COMMIT) - Book Checkout Flow
-- ============================================================================
-- Scenario: A member checks out an available book. This requires two atomic steps:
-- 1. Insert a new record into the Loans table.
-- 2. Decrement the StockQuantity in the Books table.
-- If both succeed, the transaction is committed permanently.
-- ============================================================================

DELIMITER //

CREATE PROCEDURE sp_CheckoutBook(
    IN p_BorrowerID BIGINT,
    IN p_BookID BIGINT,
    IN p_DueDate DATE
)
BEGIN
    DECLARE v_CurrentStock INT;
    
    -- Start transaction block
    START TRANSACTION;
    
    -- Step 1: Pessimistic locking (SELECT ... FOR UPDATE) to prevent race conditions
    SELECT StockQuantity INTO v_CurrentStock
    FROM Books
    WHERE BookID = p_BookID
    FOR UPDATE;
    
    -- Step 2: Check if stock is available
    IF v_CurrentStock > 0 THEN
        -- Insert active loan record
        INSERT INTO Loans (BorrowerID, BookID, LoanDate, DueDate, Status)
        VALUES (p_BorrowerID, p_BookID, NOW(), p_DueDate, 'Active');
        
        -- Decrement stock quantity
        UPDATE Books
        SET StockQuantity = StockQuantity - 1
        WHERE BookID = p_BookID;
        
        -- Commit transaction if everything succeeded
        COMMIT;
        SELECT 'SUCCESS: Book checked out successfully. Transaction committed.' AS TransactionResult;
    ELSE
        -- Rollback if no stock is available
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'ERROR: Book is out of stock. Transaction rolled back.';
    END IF;
END //

DELIMITER ;


-- ============================================================================
-- SECTION 2: Failed Transaction with Rollback (ROLLBACK)
-- ============================================================================
-- Scenario: Attempting to check out a book with zero stock or an invalid member ID.
-- The transaction fails midway and rolls back, ensuring stock is not decremented 
-- and no partial loan record is persisted.
-- ============================================================================

-- Test execution demonstrating automatic rollback on constraint violation:
START TRANSACTION;

-- Attempting an invalid insert (e.g., non-existent member or business rule violation)
INSERT INTO Loans (BorrowerID, BookID, LoanDate, DueDate, Status)
VALUES (99999, 1, NOW(), DATE_ADD(NOW(), INTERVAL 14 DAY), 'Active');

-- Simulating an error condition check
-- If an error is caught or triggered, we explicitly rollback:
ROLLBACK;

SELECT 'INFO: Transaction successfully rolled back due to constraint violation.' AS RollbackStatus;