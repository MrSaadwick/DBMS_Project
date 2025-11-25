-- Automatically process cancellations and refunds
CREATE TRIGGER trg_ProcessCancellation
ON Cancellations
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @booking_id INT, @refund_amount DECIMAL(10,2);
    
    -- Get the inserted cancellation data
    SELECT @booking_id = booking_id, @refund_amount = refund_amount
    FROM inserted;
    
    -- Create automatic refund payment record
    IF @refund_amount > 0
    BEGIN
        INSERT INTO Payments (booking_id, amount, payment_method, status, notes)
        VALUES (@booking_id, -@refund_amount, 'Online Transfer', 'Pending', 
                'Automatic refund for cancellation #' + CAST((SELECT cancellation_id FROM inserted) AS VARCHAR));
    END
    
    -- Log the cancellation
    INSERT INTO AuditLog (table_name, record_id, action, description, changed_by)
    SELECT 'Cancellations', i.cancellation_id, 'INSERT', 
           'Cancellation processed for booking #' + CAST(i.booking_id AS VARCHAR) + '. Refund: ' + CAST(i.refund_amount AS VARCHAR),
           SYSTEM_USER
    FROM inserted i;
END;
GO