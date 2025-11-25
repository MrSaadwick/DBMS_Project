
USE HotelBookingSystem;
-- Procedure to process payment
CREATE PROCEDURE ProcessPayment
    @booking_id INT,
    @amount DECIMAL(10,2),
    @payment_method VARCHAR(20),
    @transaction_id VARCHAR(100) = NULL,
    @notes TEXT = NULL
AS
BEGIN
    BEGIN TRY
        INSERT INTO Payments (booking_id, amount, payment_method, transaction_id, notes)
        VALUES (@booking_id, @amount, @payment_method, @transaction_id, @notes);
        
        SELECT 'Payment processed successfully' as message;
    END TRY
    BEGIN CATCH
        THROW;
    END TRY
END;
GO

-- Procedure to process refund
CREATE PROCEDURE ProcessRefund
    @cancellation_id INT,
    @refund_method VARCHAR(20),
    @transaction_id VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @refund_amount DECIMAL(10,2);
        DECLARE @booking_id INT;
        
        -- Get cancellation details
        SELECT 
            @refund_amount = refund_amount,
            @booking_id = booking_id
        FROM Cancellations 
        WHERE cancellation_id = @cancellation_id 
        AND refund_status = 'Pending';
        
        IF @refund_amount IS NULL
            THROW 50001, 'Refund already processed or cancellation not found', 1;
        
        -- Update cancellation status
        UPDATE Cancellations 
        SET 
            refund_status = 'Processed',
            refund_processed_date = GETDATE(),
            refund_method = @refund_method,
            refund_transaction_id = @transaction_id
        WHERE cancellation_id = @cancellation_id;
        
        -- Update payment status
        UPDATE Payments 
        SET 
            status = 'Completed',
            transaction_id = @transaction_id
        WHERE booking_id = @booking_id AND amount < 0;
        
        COMMIT TRANSACTION;
        
        SELECT 'Refund processed successfully' as message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END TRY
END;
GO