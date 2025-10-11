USE HotelBookingSystem;
GO

-- 1. INNER JOIN - Guest booking details
SELECT
g.first_name, g.last_name, g.email,
b.booking_id, b.check_in_date, b.check_out_date,
r.room_number, rt.type_name, b.total_amount
FROM Bookings b
INNER JOIN Guests g ON b.guest_id = g.guest_id
INNER JOIN Rooms r ON b.room_id = r.room_id
INNER JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id;

-- 2. LEFT JOIN - All rooms with their bookings (including rooms with no bookings)
SELECT
r.room_number, rt.type_name, r.status,
b.booking_id, b.check_in_date, b.check_out_date,
g.first_name, g.last_name
FROM Rooms r
INNER JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
LEFT JOIN Bookings b ON r.room_id = b.room_id AND b.status IN ('Confirmed', 'Checked-In')
LEFT JOIN Guests g ON b.guest_id = g.guest_id;

-- 3. Multiple JOINs - Complete booking details with services
SELECT
b.booking_id,
g.first_name + ' ' + g.last_name AS guest_name,
r.room_number,
rt.type_name,
b.check_in_date,
b.check_out_date,
s.service_name,
bs.quantity,
bs.total_price AS service_cost
FROM Bookings b
JOIN Guests g ON b.guest_id = g.guest_id
JOIN Rooms r ON b.room_id = r.room_id
JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
LEFT JOIN BookingServices bs ON b.booking_id = bs.booking_id
LEFT JOIN Services s ON bs.service_id = s.service_id;

-- 4. SELF JOIN - Find guests with multiple bookings
SELECT
g1.guest_id,
g1.first_name,
g1.last_name,
COUNT(b.booking_id) AS total_bookings
FROM Guests g1
JOIN Bookings b ON g1.guest_id = b.guest_id
GROUP BY g1.guest_id, g1.first_name, g1.last_name
HAVING COUNT(b.booking_id) > 1;

-- 5. THREE TABLE JOIN - Staff performance with department
SELECT
s.staff_id,
s.first_name + ' ' + s.last_name AS staff_name,
s.department,
s.position,
COUNT(b.booking_id) AS bookings_handled,
SUM(b.total_amount) AS total_revenue_generated
FROM Staff s
LEFT JOIN Bookings b ON s.staff_id = b.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name, s.department, s.position
ORDER BY total_revenue_generated DESC;