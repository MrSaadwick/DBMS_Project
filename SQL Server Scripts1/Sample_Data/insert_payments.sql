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