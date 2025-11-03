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