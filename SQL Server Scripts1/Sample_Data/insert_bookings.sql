USE HotelBookingSystem;
GO

INSERT INTO Bookings (guest_id, room_id, staff_id, check_in_date, check_out_date, total_amount, status, adults_count, children_count) VALUES
(1, 1, 1, '2024-01-15', '2024-01-18', 15000.00, 'Checked-Out', 2, 0),
(2, 3, 1, '2024-01-20', '2024-01-25', 40000.00, 'Confirmed', 2, 1),
(3, 5, 2, '2024-01-22', '2024-01-24', 30000.00, 'Checked-In', 3, 0),
(4, 7, 1, '2024-02-01', '2024-02-05', 48000.00, 'Confirmed', 2, 0),
(5, 2, 2, '2024-02-10', '2024-02-12', 10000.00, 'Confirmed', 1, 0),
(1, 6, 1, '2024-02-15', '2024-02-20', 75000.00, 'Confirmed', 4, 2),
(2, 8, 2, '2024-03-01', '2024-03-05', 125000.00, 'Confirmed', 2, 0);