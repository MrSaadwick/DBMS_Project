USE HotelBookingSystem;
GO

-- 1. Subquery in WHERE - Guests who made payments > 20000
SELECT first_name, last_name, email
FROM Guests
WHERE guest_id IN (
    SELECT DISTINCT guest_id 
    FROM Bookings 
    WHERE total_amount > 20000
);

-- 2. Subquery in SELECT - Room occupancy rate
SELECT 
    room_number,
    status,
    (SELECT COUNT(*) 
     FROM Bookings b 
     WHERE b.room_id = r.room_id) AS total_bookings
FROM Rooms r;

-- 3. Correlated subquery - Guests with above average spending
SELECT 
    g.first_name,
    g.last_name,
    b.total_amount
FROM Guests g
JOIN Bookings b ON g.guest_id = b.guest_id
WHERE b.total_amount > (
    SELECT AVG(total_amount) 
    FROM Bookings
);

-- 4. EXISTS - Rooms that have never been booked
SELECT room_number, type_name
FROM Rooms r
JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
WHERE NOT EXISTS (
    SELECT 1 
    FROM Bookings b 
    WHERE b.room_id = r.room_id
);

-- 5. Subquery with HAVING - Room types with above average booking count
SELECT 
    rt.type_name,
    COUNT(b.booking_id) AS booking_count
FROM RoomTypes rt
JOIN Rooms r ON rt.room_type_id = r.room_type_id
JOIN Bookings b ON r.room_id = b.room_id
GROUP BY rt.type_name
HAVING COUNT(b.booking_id) > (
    SELECT AVG(booking_count) 
    FROM (
        SELECT COUNT(booking_id) AS booking_count
        FROM Bookings
        GROUP BY room_id
    ) AS room_bookings
);