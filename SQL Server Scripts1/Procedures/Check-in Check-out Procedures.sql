-- Procedure for guest check-in
USE HotelBookingSystem;
CREATE PROCEDURE CheckInGuest
    @booking_id INT,
    @staff_id INT
AS
BEGIN
    BEGIN TRY
        UPDATE Bookings 
        SET status = 'Checked-In'
        WHERE booking_id = @booking_id AND status = 'Confirmed';
        
        IF @@ROWCOUNT > 0
            SELECT 'Guest checked in successfully' as message;
        ELSE
            THROW 50001, 'Booking not found or already checked in', 1;
    END TRY
    BEGIN CATCH
        THROW;
    END TRY
END;
GO

-- Procedure for guest check-out with payment processing
CREATE PROCEDURE CheckOutGuest
    @booking_id INT,
    @payment_method VARCHAR(20),
    @staff_id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Update booking status
        UPDATE Bookings 
        SET status = 'Checked-Out'
        WHERE booking_id = @booking_id AND status = 'Checked-In';
        
        IF @@ROWCOUNT = 0
            THROW 50001, 'Booking not found or not checked in', 1;
        
        -- Get total amount
        DECLARE @total_amount DECIMAL(10,2);
        SELECT @total_amount = total_amount FROM Bookings WHERE booking_id = @booking_id;
        
        -- Check if payment already exists
        IF NOT EXISTS (SELECT 1 FROM Payments WHERE booking_id = @booking_id AND status = 'Completed')
        BEGIN
            -- Create payment record
            INSERT INTO Payments (booking_id, amount, payment_method, status)
            VALUES (@booking_id, @total_amount, @payment_method, 'Completed');
        END
        
        -- Free up the room
        UPDATE Rooms 
        SET status = 'Cleaning'
        WHERE room_id = (SELECT room_id FROM Bookings WHERE booking_id = @booking_id);
        
        COMMIT TRANSACTION;
        
        SELECT 'Guest checked out successfully' as message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END TRY
END;
GO