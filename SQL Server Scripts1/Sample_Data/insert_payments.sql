USE HotelBookingSystem;
GO

INSERT INTO Payments (booking_id, amount, payment_method, transaction_id, status, notes) VALUES
-- November Bookings Payments
(1, 15000.00, 'Credit Card', 'TXN202511001', 'Completed', 'Full payment for 3 nights'),
(2, 20000.00, 'Cash', 'TXN202511002', 'Completed', 'Advance payment 50%'),
(2, 20000.00, 'Credit Card', 'TXN202511003', 'Completed', 'Balance payment on check-in'),
(3, 30000.00, 'Online Transfer', 'TXN202511004', 'Completed', 'Full corporate payment'),
(4, 48000.00, 'Credit Card', 'TXN202511005', 'Completed', 'Honeymoon package full payment'),
(5, 60000.00, 'Debit Card', 'TXN202511006', 'Completed', 'VIP guest full payment'),
(6, 12500.00, 'Cash', 'TXN202511007', 'Completed', '50% advance for family booking'),

-- December Bookings Payments
(13, 15000.00, 'Credit Card', 'TXN202512001', 'Completed', 'Standard room full payment'),
(14, 21250.00, 'Online Transfer', 'TXN202512002', 'Pending', '50% deluxe room advance'),
(15, 45000.00, 'Credit Card', 'TXN202512003', 'Pending', '50% executive suite advance'),
(16, 32000.00, 'Cash', 'TXN202512004', 'Pending', '50% romantic suite advance'),
(17, 52500.00, 'Online Transfer', 'TXN202512005', 'Pending', '50% penthouse advance'),
(18, 10000.00, 'Credit Card', 'TXN202512006', 'Pending', '50% standard room advance'),
(19, 25500.00, 'Debit Card', 'TXN202512007', 'Pending', '50% family suite advance');

