USE HotelBookingSystem;
GO

-- 1. UPDATE Guest information
UPDATE Guests 
SET phone = '03001112222', address = 'New Address, Lahore'
WHERE guest_id = 1;

-- 2. UPDATE Room price
UPDATE RoomTypes 
SET base_price = 8500.00 
WHERE type_name = 'Deluxe';

-- 3. UPDATE Room status
UPDATE Rooms 
SET status = 'Maintenance' 
WHERE room_number = '101';

-- 4. UPDATE Staff salary
UPDATE Staff 
SET salary = salary * 1.10  -- 10% raise
WHERE department = 'Housekeeping';

-- 5. UPDATE Service price
UPDATE Services 
SET price = 5500.00 
WHERE service_name = 'Spa Treatment';

-- 6. UPDATE Booking status
UPDATE Bookings 
SET status = 'Checked-In' 
WHERE booking_id = 2;

-- 7. UPDATE Payment status
UPDATE Payments 
SET status = 'Completed' 
WHERE status = 'Pending' AND booking_id = 4;

-- 8. UPDATE Booking Service quantity
UPDATE BookingServices 
SET quantity = 3, total_price = quantity * (SELECT price FROM Services WHERE service_id = BookingServices.service_id)
WHERE booking_service_id = 1;