CREATE TRIGGER trg_UpdateTimestamps
ON Guests
AFTER UPDATE
AS
BEGIN
    UPDATE Guests 
    SET updated_date = GETDATE()
    FROM Guests g
    INNER JOIN inserted i ON g.guest_id = i.guest_id
END;
GO

-- Apply similar triggers to other tables
CREATE TRIGGER trg_Bookings_UpdateTimestamps
ON Bookings
AFTER UPDATE
AS
BEGIN
    UPDATE Bookings 
    SET updated_date = GETDATE()
    FROM Bookings b
    INNER JOIN inserted i ON b.booking_id = i.booking_id
END;
GO