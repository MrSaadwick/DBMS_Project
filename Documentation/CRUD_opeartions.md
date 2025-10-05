USE HotelBookingSystem;
GO

-- 1. INSERT a new Guest
INSERT INTO Guests (first_name, last_name, email, phone, address, id_card_number, date_of_birth)
VALUES ('John', 'Smith', 'john.smith@email.com', '03001239999', 'House 456, Model Town, Lahore', '3520198765432', '1990-08-25');

-- 2. INSERT a new Room Type
INSERT INTO RoomTypes (type_name, description, base_price, capacity, amenities)
VALUES ('Family Suite', 'Large suite perfect for families', 18000.00, 5, 'TV, WiFi, AC, Kitchenette, 2 Bedrooms');

-- 3. INSERT a new Room
INSERT INTO Rooms (room_number, room_type_id, floor_number, status, has_sea_view, has_balcony)
VALUES ('601', 3, 6, 'Available', 1, 1);

-- 4. INSERT a new Staff member
INSERT INTO Staff (first_name, last_name, email, phone, position, department, salary)
VALUES ('Sana', 'Khan', 'sana.khan@hotel.com', '03331239999', 'Assistant Manager', 'Administration', 80000.00);

-- 5. INSERT a new Service
INSERT INTO Services (service_name, description, price, category, is_available)
VALUES ('Car Rental', 'Daily car rental service', 3500.00, 'Transport', 1);

-- 6. INSERT a new Booking
INSERT INTO Bookings (guest_id, room_id, staff_id, check_in_date, check_out_date, total_amount, adults_count, children_count)
VALUES (3, 5, 1, '2024-03-10', '2024-03-15', 75000.00, 2, 1);

-- 7. INSERT a new Payment
INSERT INTO Payments (booking_id, amount, payment_method, transaction_id, status)
VALUES (7, 37500.00, 'Credit Card', 'TXN001241', 'Completed');

-- 8. INSERT a Booking Service
INSERT INTO BookingServices (booking_id, service_id, quantity, total_price)
VALUES (7, 1, 5, 7500.00);






##Update Operation


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



###Delete_operation
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








###Select_Operation
USE HotelBookingSystem;
GO

-- 1. SELECT all Guests
SELECT * FROM Guests;

-- 2. SELECT specific columns from Rooms
SELECT room_id, room_number, status, floor_number 
FROM Rooms 
WHERE status = 'Available';

-- 3. SELECT with WHERE clause - Available Deluxe Rooms
SELECT r.room_number, rt.type_name, rt.base_price
FROM Rooms r
JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
WHERE rt.type_name = 'Deluxe' AND r.status = 'Available';

-- 4. SELECT with ORDER BY - RoomTypes by price
SELECT type_name, base_price, capacity
FROM RoomTypes
ORDER BY base_price DESC;

-- 5. SELECT with DISTINCT - Unique room statuses
SELECT DISTINCT status FROM Rooms;

-- 6. SELECT with AND/OR - Specific room criteria
SELECT room_number, floor_number, has_sea_view, has_balcony
FROM Rooms
WHERE (has_sea_view = 1 OR has_balcony = 1) AND floor_number BETWEEN 2 AND 4;

-- 7. SELECT with IN - Multiple room types
SELECT room_number, room_type_id
FROM Rooms
WHERE room_type_id IN (1, 3, 5);

-- 8. SELECT with BETWEEN - Bookings within date range
SELECT booking_id, guest_id, check_in_date, check_out_date
FROM Bookings
WHERE check_in_date BETWEEN '2024-01-01' AND '2024-03-31';

-- 9. SELECT with LIKE - Guests with specific email pattern
SELECT first_name, last_name, email
FROM Guests
WHERE email LIKE '%@gmail.com';

-- 10. SELECT with LIMIT (TOP in SQL Server) - Latest 5 bookings
SELECT TOP 5 booking_id, guest_id, booking_date, status
FROM Bookings
ORDER BY booking_date DESC;

-- 11. SELECT with IS NULL - Guests without phone
SELECT first_name, last_name, email
FROM Guests
WHERE phone IS NULL;

-- 12. SELECT with calculated columns - Booking duration
SELECT booking_id, 
       guest_id,
       check_in_date,
       check_out_date,
       DATEDIFF(day, check_in_date, check_out_date) as stay_duration
FROM Bookings;