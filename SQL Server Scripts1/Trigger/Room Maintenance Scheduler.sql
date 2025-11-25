-- Automatically schedule room maintenance after check-out
CREATE TRIGGER trg_ScheduleRoomMaintenance
ON Bookings
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- When booking status changes to Checked-Out, schedule cleaning
    IF UPDATE(status)
    BEGIN
        INSERT INTO RoomMaintenance (room_id, maintenance_type, scheduled_date, status, notes)
        SELECT i.room_id, 'Cleaning', GETDATE(), 'Scheduled', 
               'Automatic cleaning scheduled after check-out of booking #' + CAST(i.booking_id AS VARCHAR)
        FROM inserted i
        INNER JOIN deleted d ON i.booking_id = d.booking_id
        WHERE i.status = 'Checked-Out' AND d.status != 'Checked-Out';
    END
END;
GO