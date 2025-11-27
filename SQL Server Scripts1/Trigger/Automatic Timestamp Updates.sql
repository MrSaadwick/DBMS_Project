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

