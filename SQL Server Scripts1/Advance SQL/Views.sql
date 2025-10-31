USE HotelBookingSystem;
GO

-- 1. View for available rooms
CREATE VIEW AvailableRooms AS
SELECT 
    r.room_id,
    r.room_number,
    rt.type_name,
    rt.base_price,
    rt.capacity,
    r.floor_number,
    r.has_sea_view,
    r.has_balcony
FROM Rooms r
JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
WHERE r.status = 'Available';

-- 2. View for guest booking summary
CREATE VIEW GuestBookingSummary AS
SELECT 
    g.guest_id,
    g.first_name + ' ' + g.last_name AS guest_name,
    g.email,
    g.phone,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_amount) AS total_spent,
    MAX(b.booking_date) AS last_booking_date
FROM Guests g
LEFT JOIN Bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_id, g.first_name, g.last_name, g.email, g.phone;

-- 3. View for monthly revenue report
CREATE VIEW MonthlyRevenueReport AS
SELECT 
    YEAR(p.payment_date) AS year,
    MONTH(p.payment_date) AS month,
    DATENAME(MONTH, p.payment_date) AS month_name,
    SUM(p.amount) AS total_revenue,
    COUNT(p.payment_id) AS total_transactions,
    AVG(p.amount) AS average_transaction
FROM Payments p
WHERE p.status = 'Completed'
GROUP BY YEAR(p.payment_date), MONTH(p.payment_date), DATENAME(MONTH, p.payment_date);

-- 4. View for room occupancy details
CREATE VIEW RoomOccupancyDetails AS
SELECT 
    r.room_number,
    rt.type_name,
    r.status,
    COUNT(b.booking_id) AS total_bookings,
    SUM(DATEDIFF(day, b.check_in_date, b.check_out_date)) AS total_occupied_days
FROM Rooms r
JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
LEFT JOIN Bookings b ON r.room_id = b.room_id AND b.status IN ('Checked-Out', 'Checked-In')
GROUP BY r.room_number, rt.type_name, r.status;

-- 5. Using the views
SELECT * FROM AvailableRooms;
SELECT * FROM GuestBookingSummary WHERE total_bookings > 0;
SELECT * FROM MonthlyRevenueReport ORDER BY year, month;
SELECT * FROM RoomOccupancyDetails ORDER BY total_occupied_days DESC;