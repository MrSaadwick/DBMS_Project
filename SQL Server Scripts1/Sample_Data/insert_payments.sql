USE HotelBookingSystem;
GO

INSERT INTO Payments (booking_id, amount, payment_method, transaction_id, status) VALUES
(1, 15000.00, 'Credit Card', 'TXN001234', 'Completed'),
(2, 20000.00, 'Cash', 'TXN001235', 'Completed'),
(3, 15000.00, 'Online Transfer', 'TXN001236', 'Completed'),
(4, 24000.00, 'Credit Card', 'TXN001237', 'Pending'),
(5, 5000.00, 'Debit Card', 'TXN001238', 'Completed'),
(6, 37500.00, 'Online Transfer', 'TXN001239', 'Completed'),
(7, 62500.00, 'Credit Card', 'TXN001240', 'Completed');

INSERT INTO Payments (booking_id, amount, payment_method, transaction_id, status, notes) VALUES
-- Completed Payments (1-15)
(1, 15000.00, 'Credit Card', 'TXN001234', 'Completed', 'Full payment for 3 nights'),
(2, 20000.00, 'Cash', 'TXN001235', 'Completed', 'Advance payment 50%'),
(2, 20000.00, 'Credit Card', 'TXN001236', 'Completed', 'Balance payment on check-in'),
(3, 30000.00, 'Online Transfer', 'TXN001237', 'Completed', 'Full corporate payment'),
(4, 48000.00, 'Credit Card', 'TXN001238', 'Completed', 'Honeymoon package full payment'),
(5, 60000.00, 'Debit Card', 'TXN001239', 'Completed', 'VIP guest full payment'),
(6, 12500.00, 'Cash', 'TXN001240', 'Completed', '50% advance for family booking'),
(7, 32000.00, 'Credit Card', 'TXN001241', 'Completed', 'Anniversary special full payment'),
(8, 37500.00, 'Online Transfer', 'TXN001242', 'Completed', '50% corporate advance'),
(9, 20000.00, 'Credit Card', 'TXN001243', 'Completed', 'Full payment on arrival'),
(10, 34000.00, 'Debit Card', 'TXN001244', 'Completed', 'Business trip full payment'),
(11, 60000.00, 'Credit Card', 'TXN001245', 'Completed', 'Luxury suite full payment'),
(12, 24000.00, 'Cash', 'TXN001246', 'Completed', '50% family booking advance'),
(13, 15000.00, 'Credit Card', 'TXN001247', 'Completed', 'Standard room full payment'),
(14, 42500.00, 'Online Transfer', 'TXN001248', 'Completed', 'Deluxe room full payment'),

-- Pending Payments (16-20)
(15, 45000.00, 'Credit Card', 'TXN001249', 'Pending', '50% advance for executive suite'),
(16, 32000.00, 'Cash', NULL, 'Pending', 'Balance payment due on check-out'),
(17, 52500.00, 'Online Transfer', NULL, 'Pending', '50% penthouse advance'),
(18, 10000.00, 'Credit Card', NULL, 'Pending', 'Balance for standard room'),
(19, 25500.00, 'Debit Card', NULL, 'Pending', '50% family suite advance'),

-- Refund Payments (21-25) - Use negative amounts with regular payment methods
(20, -12000.00, 'Online Transfer', 'REF001250', 'Refunded', 'Cancellation refund - 90%'),
(21, -8000.00, 'Credit Card', 'REF001251', 'Refunded', 'Cancellation refund - 80%'),
(22, -35000.00, 'Online Transfer', 'REF001252', 'Refunded', 'Corporate cancellation refund'),
(23, -16800.00, 'Debit Card', 'REF001253', 'Refunded', 'Long stay cancellation'),
(24, -45000.00, 'Credit Card', 'REF001254', 'Refunded', 'Honeymoon cancellation');


select * from Payments;
