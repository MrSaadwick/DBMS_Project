-- Procedure to create a new booking with services
USE HotelBookingSystem;
GO

CREATE OR ALTER PROCEDURE CreateBooking
    @guest_id INT,
    @room_id INT,
    @staff_id INT,
    @check_in_date DATE,
    @check_out_date DATE,
    @adults_count INT = 1,
    @children_count INT = 0,
    @special_requests TEXT = NULL,
    @service_ids VARCHAR(MAX) = NULL, -- Comma-separated service IDs with quantities: '1:2,3:1,5:1'
    @discount_percent DECIMAL(5,2) = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Calculate stay duration and room price
        DECLARE @stay_duration INT = DATEDIFF(DAY, @check_in_date, @check_out_date);
        DECLARE @room_price DECIMAL(10,2);
        DECLARE @room_total DECIMAL(10,2);
        DECLARE @services_total DECIMAL(10,2) = 0;
        DECLARE @tax_amount DECIMAL(10,2);
        DECLARE @grand_total DECIMAL(10,2);
        
        -- Get room price
        SELECT @room_price = rt.base_price
        FROM Rooms r
        JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
        WHERE r.room_id = @room_id;
        
        IF @room_price IS NULL
            THROW 50001, 'Room not found or price not set', 1;
        
        SET @room_total = @room_price * @stay_duration;
        
        -- Calculate services total if provided
        IF @service_ids IS NOT NULL
        BEGIN
            CREATE TABLE #SelectedServices (service_id INT, quantity INT);
            
            INSERT INTO #SelectedServices (service_id, quantity)
            SELECT 
                CAST(SUBSTRING(value, 1, CHARINDEX(':', value) - 1) AS INT),
                CAST(SUBSTRING(value, CHARINDEX(':', value) + 1, LEN(value)) AS INT)
            FROM STRING_SPLIT(@service_ids, ',');
            
            SELECT @services_total = SUM(s.price * ss.quantity)
            FROM #SelectedServices ss
            JOIN Services s ON ss.service_id = s.service_id;
            
            DROP TABLE #SelectedServices;
        END
        
        -- Calculate totals
        DECLARE @subtotal DECIMAL(10,2) = @room_total + @services_total;
        DECLARE @discount_amount DECIMAL(10,2) = (@subtotal * @discount_percent) / 100;
        DECLARE @taxable_amount DECIMAL(10,2) = @subtotal - @discount_amount;
        SET @tax_amount = @taxable_amount * 0.13; -- 13% tax
        SET @grand_total = @taxable_amount + @tax_amount;
        
        -- Create booking (using only columns that exist in your table)
        INSERT INTO Bookings (
            guest_id, room_id, staff_id, check_in_date, check_out_date,
            total_amount, adults_count, children_count, special_requests
            -- Removed: discount_percent, discount_amount, tax_amount, services_amount
        )
        VALUES (
            @guest_id, @room_id, @staff_id, @check_in_date, @check_out_date,
            @grand_total, @adults_count, @children_count, @special_requests
        );
        
        DECLARE @new_booking_id INT = SCOPE_IDENTITY();
        
        -- Add services if provided
        IF @service_ids IS NOT NULL AND @new_booking_id IS NOT NULL
        BEGIN
            CREATE TABLE #BookingServices (service_id INT, quantity INT);
            
            INSERT INTO #BookingServices (service_id, quantity)
            SELECT 
                CAST(SUBSTRING(value, 1, CHARINDEX(':', value) - 1) AS INT),
                CAST(SUBSTRING(value, CHARINDEX(':', value) + 1, LEN(value)) AS INT)
            FROM STRING_SPLIT(@service_ids, ',');
            
            INSERT INTO BookingServices (booking_id, service_id, quantity, total_price)
            SELECT 
                @new_booking_id,
                bs.service_id,
                bs.quantity,
                (s.price * bs.quantity)
            FROM #BookingServices bs
            JOIN Services s ON bs.service_id = s.service_id;
            
            DROP TABLE #BookingServices;
        END
        
        -- Update room status
        UPDATE Rooms SET status = 'Occupied' WHERE room_id = @room_id;
        
        COMMIT TRANSACTION;
        
        -- Return booking details
        SELECT 
            @new_booking_id as booking_id,
            @grand_total as total_amount,
            @room_total as room_amount,
            @services_total as services_amount,
            @tax_amount as tax_amount,
            @discount_amount as discount_amount,
            'Booking created successfully' as message;
            
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