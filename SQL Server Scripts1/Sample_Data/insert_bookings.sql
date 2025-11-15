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

INSERT INTO Bookings (guest_id, room_id, staff_id, check_in_date, check_out_date, total_amount, status, adults_count, children_count, special_requests) VALUES
-- Confirmed Bookings (1-8)
(1, 1, 1, '2024-03-15', '2024-03-18', 15000.00, 'Confirmed', 2, 0, 'Early check-in requested'),
(2, 6, 1, '2024-03-20', '2024-03-25', 40000.00, 'Confirmed', 2, 1, 'Baby cot needed'),
(3, 11, 2, '2024-03-22', '2024-03-24', 30000.00, 'Confirmed', 3, 0, 'Business trip'),
(4, 16, 1, '2024-04-01', '2024-04-05', 48000.00, 'Confirmed', 2, 0, 'Honeymoon arrangement'),
(5, 21, 2, '2024-04-10', '2024-04-12', 60000.00, 'Confirmed', 1, 0, 'Quiet room preferred'),
(6, 2, 1, '2024-04-15', '2024-04-20', 25000.00, 'Confirmed', 4, 2, 'Family vacation'),
(7, 7, 2, '2024-05-01', '2024-05-05', 32000.00, 'Confirmed', 2, 0, 'Anniversary celebration'),
(8, 12, 1, '2024-05-10', '2024-05-15', 75000.00, 'Confirmed', 2, 0, 'Executive meeting setup'),

-- Checked-In Bookings (9-12)
(9, 3, 2, '2024-03-10', '2024-03-14', 20000.00, 'Checked-In', 2, 1, 'Late checkout needed'),
(10, 8, 1, '2024-03-12', '2024-03-16', 34000.00, 'Checked-In', 3, 0, 'Extra towels'),
(11, 13, 2, '2024-03-14', '2024-03-18', 60000.00, 'Checked-In', 2, 0, 'Spa appointment'),
(12, 18, 1, '2024-03-16', '2024-03-20', 48000.00, 'Checked-In', 2, 2, 'Connecting rooms'),

-- Checked-Out Bookings (13-18)
(13, 4, 2, '2024-02-15', '2024-02-18', 15000.00, 'Checked-Out', 2, 0, 'Airport transfer'),
(14, 9, 1, '2024-02-20', '2024-02-25', 42500.00, 'Checked-Out', 2, 1, 'Special diet requirements'),
(15, 14, 2, '2024-02-22', '2024-02-26', 90000.00, 'Checked-Out', 4, 0, 'Business conference'),
(16, 19, 1, '2024-03-01', '2024-03-05', 64000.00, 'Checked-Out', 2, 0, 'Romantic setup'),
(17, 24, 2, '2024-03-05', '2024-03-08', 105000.00, 'Checked-Out', 3, 0, 'VIP treatment'),
(18, 5, 1, '2024-03-08', '2024-03-12', 20000.00, 'Checked-Out', 2, 0, 'Early breakfast'),

-- Future Bookings (19-25)
(19, 10, 2, '2024-06-01', '2024-06-07', 51000.00, 'Confirmed', 3, 2, 'Family reunion'),
(20, 15, 1, '2024-06-15', '2024-06-20', 120000.00, 'Confirmed', 2, 0, 'Wedding anniversary'),
(21, 20, 2, '2024-07-01', '2024-07-05', 40000.00, 'Confirmed', 2, 1, 'City tour booking'),
(22, 25, 1, '2024-07-10', '2024-07-15', 175000.00, 'Confirmed', 4, 0, 'Business delegation'),
(23, 17, 2, '2024-08-01', '2024-08-07', 67200.00, 'Confirmed', 2, 0, 'Long stay discount'),
(24, 22, 1, '2024-08-15', '2024-08-18', 90000.00, 'Confirmed', 2, 0, 'Honeymoon package'),
(25, 23, 2, '2024-09-01', '2024-09-05', 140000.00, 'Confirmed', 3, 0, 'Corporate event');



