USE HotelBookingSystem;
GO

-- 1. DELETE a specific Booking Service
DELETE FROM BookingServices 
WHERE booking_service_id = 5;

-- 2. DELETE a Payment record (only if status is Pending)
DELETE FROM Payments 
WHERE status = 'Pending' AND payment_id = 4;

-- 3. DELETE a Service (soft delete by setting unavailable)
UPDATE Services 
SET is_available = 0 
WHERE service_id = 5;

-- 4. DELETE a Guest (only if no bookings exist)
DELETE FROM Guests 
WHERE guest_id NOT IN (SELECT DISTINCT guest_id FROM Bookings) AND guest_id = 6;

-- 5. DELETE a Room (only if no future bookings)
DELETE FROM Rooms 
WHERE room_id NOT IN (SELECT DISTINCT room_id FROM Bookings WHERE check_in_date > GETDATE()) AND room_id = 10;

-- 6. DELETE old completed payments (archive operation)
-- DELETE FROM Payments WHERE status = 'Completed' AND payment_date < '2024-01-01';

-- 7. DELETE a Staff member (soft delete)
UPDATE Staff 
SET is_active = 0 
WHERE staff_id = 5;

-- Note: Always be cautious with DELETE operations. Use transactions for safety.
BEGIN TRANSACTION;
DELETE FROM BookingServices WHERE booking_service_id = 5;
-- ROLLBACK; -- Use if you want to undo
COMMIT;