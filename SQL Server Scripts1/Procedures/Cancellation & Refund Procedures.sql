-- Procedure to cancel booking with automatic refund calculation
USE HotelBookingSystem;
GO

CREATE OR ALTER PROCEDURE CancelBooking
    @booking_id INT,
    @staff_id INT,
    @cancellation_reason VARCHAR(100),
    @detailed_reason TEXT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @booking_amount DECIMAL(10,2);
        DECLARE @check_in_date DATE;
        DECLARE @days_before_checkin INT;
        DECLARE @refund_percentage DECIMAL(5,2);
        DECLARE @refund_amount DECIMAL(10,2);
        DECLARE @cancellation_fee DECIMAL(10,2);
        DECLARE @cancellation_type VARCHAR(20);
        DECLARE @room_id INT;
        DECLARE @guest_id INT;
        
        -- Get booking details
        SELECT 
            @booking_amount = total_amount,
            @check_in_date = check_in_date,
            @room_id = room_id,
            @guest_id = guest_id
        FROM Bookings 
        WHERE booking_id = @booking_id;
        
        IF @booking_amount IS NULL
            THROW 50001, 'Booking not found', 1;
        
        -- Check if booking is already cancelled
        IF EXISTS (SELECT 1 FROM Bookings WHERE booking_id = @booking_id AND status = 'Cancelled')
            THROW 50002, 'Booking is already cancelled', 1;
        
        -- Calculate days before check-in
        SET @days_before_checkin = DATEDIFF(HOUR, GETDATE(), @check_in_date) / 24;
        
        -- Determine cancellation type and refund percentage
        IF @days_before_checkin > 0
        BEGIN
            SET @cancellation_type = 'Before Check-in';
            IF @days_before_checkin >= 2      -- 48+ hours
                SET @refund_percentage = 90.0;
            ELSE IF @days_before_checkin >= 1 -- 24-48 hours
                SET @refund_percentage = 50.0;
            ELSE                              -- Less than 24 hours
                SET @refund_percentage = 10.0;
        END
        ELSE
        BEGIN
            SET @cancellation_type = 'No Show';
            SET @refund_percentage = 0.0;
        END
        
        -- Calculate refund and fee
        SET @refund_amount = (@booking_amount * @refund_percentage) / 100;
        SET @cancellation_fee = @booking_amount - @refund_amount;
        
        -- Create cancellation record
        INSERT INTO Cancellations (
            booking_id, cancelled_by_staff_id, cancellation_reason, detailed_reason,
            original_booking_amount, refund_amount, cancellation_fee, refund_percentage,
            cancellation_type, days_before_checkin, refund_status
        )
        VALUES (
            @booking_id, @staff_id, @cancellation_reason, @detailed_reason,
            @booking_amount, @refund_amount, @cancellation_fee, @refund_percentage,
            @cancellation_type, @days_before_checkin, 
            CASE WHEN @refund_amount > 0 THEN 'Pending' ELSE 'Not Applicable' END
        );
        
        -- Update booking status
        UPDATE Bookings SET status = 'Cancelled' WHERE booking_id = @booking_id;
        
        -- Free up the room
        UPDATE Rooms SET status = 'Available' WHERE room_id = @room_id;
        
        -- Create refund payment record if applicable
        IF @refund_amount > 0
        BEGIN
            INSERT INTO Payments (booking_id, amount, payment_method, status, notes)
            VALUES (@booking_id, -@refund_amount, 'Refund', 'Pending', 
                   'Cancellation refund - ' + @cancellation_reason);
        END
        
        COMMIT TRANSACTION;
        
        -- Return cancellation details
        SELECT 
            @booking_id as booking_id,
            @guest_id as guest_id,
            @refund_amount as refund_amount,
            @cancellation_fee as cancellation_fee,
            @refund_percentage as refund_percentage,
            @cancellation_type as cancellation_type,
            'Booking cancelled successfully' as message;
            
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO