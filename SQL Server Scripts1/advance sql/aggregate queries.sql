USE HotelBookingSystem;
GO

-- 1. COUNT total guests
SELECT COUNT(*) AS total_guests FROM Guests;

-- 2. COUNT bookings by status
SELECT status, COUNT(*) AS booking_count
FROM Bookings
GROUP BY status;

-- 3. AVERAGE room price by room type
SELECT rt.type_name,
AVG(rt.base_price) AS avg_price,
COUNT(r.room_id) AS room_count
FROM RoomTypes rt
LEFT JOIN Rooms r ON rt.room_type_id = r.room_type_id
GROUP BY rt.type_name, rt.room_type_id;

-- 4. SUM total revenue by payment method
SELECT payment_method,
SUM(amount) AS total_revenue,
COUNT(*) AS transaction_count
FROM Payments
WHERE status = 'Completed'
GROUP BY payment_method;

-- 5. MAX and MIN room prices
SELECT
MAX(base_price) AS highest_price,
MIN(base_price) AS lowest_price,
AVG(base_price) AS average_price
FROM RoomTypes;

-- 6. GROUP BY with HAVING - Room types with average price > 10000
SELECT type_name, AVG(base_price) AS avg_price
FROM RoomTypes
GROUP BY type_name
HAVING AVG(base_price) > 10000;

-- 7. Revenue by month
SELECT
YEAR(payment_date) AS year,
MONTH(payment_date) AS month,
SUM(amount) AS monthly_revenue,
COUNT(*) AS payment_count
FROM Payments
WHERE status = 'Completed'
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER BY year, month;

-- 8. Staff with most bookings handled
SELECT s.staff_id, s.first_name, s.last_name, COUNT(b.booking_id) AS bookings_handled
FROM Staff s
JOIN Bookings b ON s.staff_id = b.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY bookings_handled DESC;