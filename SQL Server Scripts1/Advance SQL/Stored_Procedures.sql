USE HotelBookingSystem;
GO

-- 1. Stored Procedure to add new booking with validation
CREATE PROCEDURE AddNewBooking
    @guest_id INT,
    @room_id INT,
    @staff_id INT,
    @check_in_date DATE,
    @check_out_date DATE,
    @adults_count INT = 1,
    @children_count INT = 0,
    @special_requests TEXT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Check if room is available
        IF EXISTS (SELECT 1 FROM Rooms WHERE room_id = @room_id AND status != 'Available')
        BEGIN
            THROW 50001, 'Room is not available for booking', 1;
        END
        
        -- Check date validity
        IF @check_in_date >= @check_out_date
        BEGIN
            THROW 50002, 'Check-out date must be after check-in date', 1;
        END
        
        -- Calculate total amount
        DECLARE @room_price DECIMAL(10,2);
        DECLARE @stay_duration INT;
        DECLARE @total_amount DECIMAL(10,2);
        
        SELECT @room_price = rt.base_price
        FROM Rooms r
        JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
        WHERE r.room_id = @room_id;
        
        SET @stay_duration = DATEDIFF(day, @check_in_date, @check_out_date);
        SET @total_amount = @room_price * @stay_duration;
        
        -- Insert booking
        INSERT INTO Bookings (
            guest_id, room_id, staff_id, check_in_date, check_out_date,
            total_amount, adults_count, children_count, special_requests
        )
        VALUES (
            @guest_id, @room_id, @staff_id, @check_in_date, @check_out_date,
            @total_amount, @adults_count, @children_count, @special_requests
        );
        
        -- Update room status
        UPDATE Rooms SET status = 'Occupied' WHERE room_id = @room_id;
        
        COMMIT TRANSACTION;
        
        SELECT 'Booking created successfully' AS message, SCOPE_IDENTITY() AS new_booking_id;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- 2. Stored Procedure to check out guest
CREATE PROCEDURE CheckOutGuest
    @booking_id INT
AS
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE Bookings 
    SET status = 'Checked-Out' 
    WHERE booking_id = @booking_id AND status = 'Checked-In';
    
    DECLARE @room_id INT;
    SELECT @room_id = room_id FROM Bookings WHERE booking_id = @booking_id;
    
    UPDATE Rooms 
    SET status = 'Cleaning' 
    WHERE room_id = @room_id;
    
    COMMIT TRANSACTION;
    
    SELECT 'Guest checked out successfully. Room marked for cleaning.' AS message;
END;
GO

-- 3. Stored Procedure to get guest booking history
CREATE PROCEDURE GetGuestBookingHistory
    @guest_id INT
AS
BEGIN
    SELECT 
        b.booking_id,
        b.booking_date,
        b.check_in_date,
        b.check_out_date,
        r.room_number,
        rt.type_name,
        b.total_amount,
        b.status,
        s.first_name + ' ' + s.last_name AS handled_by
    FROM Bookings b
    JOIN Rooms r ON b.room_id = r.room_id
    JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
    JOIN Staff s ON b.staff_id = s.staff_id
    WHERE b.guest_id = @guest_id
    ORDER BY b.booking_date DESC;
END;
GO

-- 4. Using the stored procedures
EXEC AddNewBooking 
    @guest_id = 2,
    @room_id = 3,
    @staff_id = 1,
    @check_in_date = '2024-04-01',
    @check_out_date = '2024-04-05',
    @adults_count = 2,
    @children_count = 1;

EXEC CheckOutGuest @booking_id = 3;
EXEC GetGuestBookingHistory @guest_id = 1;
