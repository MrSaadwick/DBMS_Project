-- Ensure room prices are within valid range
CREATE TRIGGER trg_ValidateRoomPrices
ON RoomTypes
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE base_price <= 0 OR base_price > 100000
    )
    BEGIN
        RAISERROR('Room price must be between 1 and 100,000.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO