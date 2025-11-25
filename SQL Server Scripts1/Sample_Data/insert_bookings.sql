USE HotelBookingSystem;
GO
INSERT INTO Bookings (guest_id, room_id, staff_id, check_in_date, check_out_date, total_amount, status, adults_count, children_count, special_requests) VALUES
-- November 2025 Bookings (1-12)
(1, 1, 1, '2025-11-15', '2025-11-18', 15000.00, 'Confirmed', 2, 0, 'Early check-in requested'),
(2, 6, 1, '2025-11-20', '2025-11-25', 40000.00, 'Confirmed', 2, 1, 'Baby cot needed'),
(3, 11, 2, '2025-11-22', '2025-11-24', 30000.00, 'Confirmed', 3, 0, 'Business trip'),
(4, 16, 1, '2025-11-25', '2025-11-29', 48000.00, 'Confirmed', 2, 0, 'Honeymoon arrangement'),
(5, 21, 2, '2025-11-28', '2025-11-30', 60000.00, 'Confirmed', 1, 0, 'Quiet room preferred'),
(6, 2, 1, '2025-11-30', '2025-12-05', 25000.00, 'Confirmed', 4, 2, 'Family vacation'),
(7, 7, 2, '2025-11-10', '2025-11-14', 32000.00, 'Checked-Out', 2, 0, 'Anniversary celebration'),
(8, 12, 1, '2025-11-12', '2025-11-16', 75000.00, 'Checked-Out', 2, 0, 'Executive meeting setup'),
(9, 3, 2, '2025-11-05', '2025-11-09', 20000.00, 'Checked-Out', 2, 1, 'Late checkout needed'),
(10, 8, 1, '2025-11-08', '2025-11-12', 34000.00, 'Checked-Out', 3, 0, 'Extra towels'),
(11, 13, 2, '2025-11-18', '2025-11-22', 60000.00, 'Checked-In', 2, 0, 'Spa appointment'),
(12, 18, 1, '2025-11-20', '2025-11-24', 48000.00, 'Checked-In', 2, 2, 'Connecting rooms'),
-- December 2025 Bookings (13-25)
(13, 4, 2, '2025-12-01', '2025-12-04', 15000.00, 'Confirmed', 2, 0, 'Airport transfer'),
(14, 9, 1, '2025-12-05', '2025-12-10', 42500.00, 'Confirmed', 2, 1, 'Special diet requirements'),
(15, 14, 2, '2025-12-08', '2025-12-12', 90000.00, 'Confirmed', 4, 0, 'Business conference'),
(16, 19, 1, '2025-12-12', '2025-12-16', 64000.00, 'Confirmed', 2, 0, 'Romantic setup'),
(17, 24, 2, '2025-12-15', '2025-12-18', 105000.00, 'Confirmed', 3, 0, 'VIP treatment'),
(18, 5, 1, '2025-12-18', '2025-12-22', 20000.00, 'Confirmed', 2, 0, 'Early breakfast'),
(19, 10, 2, '2025-12-20', '2025-12-26', 51000.00, 'Confirmed', 3, 2, 'Family reunion'),
(20, 15, 1, '2025-12-22', '2025-12-27', 120000.00, 'Confirmed', 2, 0, 'Wedding anniversary'),
(21, 20, 2, '2025-12-25', '2025-12-29', 40000.00, 'Confirmed', 2, 1, 'City tour booking'),
(22, 25, 1, '2025-12-26', '2025-12-31', 175000.00, 'Confirmed', 4, 0, 'Business delegation'),
(23, 17, 2, '2025-12-28', '2026-01-03', 67200.00, 'Confirmed', 2, 0, 'Long stay discount'),
(24, 22, 1, '2025-12-29', '2026-01-01', 90000.00, 'Confirmed', 2, 0, 'Honeymoon package'),
(25, 23, 2, '2025-12-30', '2026-01-03', 140000.00, 'Confirmed', 3, 0, 'Corporate event');
select * from Rooms;
select * from Bookings;