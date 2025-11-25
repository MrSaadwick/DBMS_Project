-- Automatically calculate and update booking total when services are added
CREATE TRIGGER trg_UpdateBookingTotal_OnServices
ON BookingServices
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @affected_bookings TABLE (booking_id INT);
    
    -- Collect all affected booking IDs
    INSERT INTO @affected_bookings (booking_id)
    SELECT booking_id FROM inserted
    UNION
    SELECT booking_id FROM deleted;
    
    -- Update services_amount in Bookings table
    UPDATE b
    SET b.services_amount = COALESCE((
        SELECT SUM(total_price) 
        FROM BookingServices bs 
        WHERE bs.booking_id = b.booking_id
    ), 0),
    b.updated_date = GETDATE()
    FROM Bookings b
    INNER JOIN @affected_bookings ab ON b.booking_id = ab.booking_id;
    
    -- Recalculate total amount including services
    UPDATE b
    SET b.total_amount = 
        ((DATEDIFF(day, b.check_in_date, b.check_out_date) * rt.base_price) * 
        (1 - COALESCE(b.discount_percent, 0)/100)) + 
        COALESCE(b.services_amount, 0) +
        COALESCE(b.tax_amount, 0),
        b.updated_date = GETDATE()
    FROM Bookings b
    INNER JOIN @affected_bookings ab ON b.booking_id = ab.booking_id
    INNER JOIN Rooms r ON b.room_id = r.room_id
    INNER JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id;
END;
GO