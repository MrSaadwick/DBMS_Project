USE HotelBookingSystem;
-- Procedure to check room availability
CREATE PROCEDURE CheckRoomAvailability
    @check_in_date DATE,
    @check_out_date DATE,
    @room_type_id INT = NULL,
    @adults_count INT = 1,
    @children_count INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        r.room_id,
        r.room_number,
        rt.type_name,
        rt.base_price,
        rt.capacity,
        rt.amenities,
        r.floor_number,
        r.has_sea_view,
        r.has_balcony
    FROM Rooms r
    JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
    WHERE r.status = 'Available'
    AND rt.capacity >= (@adults_count + @children_count)
    AND (@room_type_id IS NULL OR r.room_type_id = @room_type_id)
    AND r.room_id NOT IN (
        SELECT room_id 
        FROM Bookings 
        WHERE status IN ('Confirmed', 'Checked-In')
        AND (
            (check_in_date <= @check_out_date AND check_out_date >= @check_in_date)
        )
    )
    ORDER BY rt.base_price;
END;
GO

-- Procedure to get dashboard statistics
CREATE PROCEDURE GetDashboardStats
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        -- Guest stats
        (SELECT COUNT(*) FROM Guests) as total_guests,
        (SELECT COUNT(*) FROM Bookings WHERE status = 'Confirmed') as confirmed_bookings,
        (SELECT COUNT(*) FROM Bookings WHERE status = 'Checked-In') as active_stays,
        
        -- Room stats
        (SELECT COUNT(*) FROM Rooms WHERE status = 'Available') as available_rooms,
        (SELECT COUNT(*) FROM Rooms WHERE status = 'Occupied') as occupied_rooms,
        (SELECT COUNT(*) FROM Rooms WHERE status = 'Maintenance') as maintenance_rooms,
        
        -- Revenue stats
        (SELECT ISNULL(SUM(amount), 0) FROM Payments 
         WHERE status = 'Completed' AND payment_date >= CAST(GETDATE() AS DATE)) as today_revenue,
        (SELECT ISNULL(SUM(amount), 0) FROM Payments 
         WHERE status = 'Completed' AND payment_date >= DATEADD(DAY, -30, GETDATE())) as monthly_revenue,
         
        -- Cancellation stats
        (SELECT COUNT(*) FROM Cancellations 
         WHERE cancellation_date >= DATEADD(DAY, -30, GETDATE())) as monthly_cancellations;
END;
GO