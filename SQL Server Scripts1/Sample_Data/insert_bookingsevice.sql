
USE HotelBookingSystem;
GO

INSERT INTO BookingServices (booking_id, service_id, quantity, total_price) VALUES
(1, 1, 3, 4500.00),  -- 3 breakfasts for booking 1
(1, 3, 1, 800.00),   -- Laundry service for booking 1
(2, 1, 5, 7500.00),  -- 5 breakfasts for booking 2
(2, 4, 1, 2000.00),  -- Airport transfer for booking 2
(3, 2, 2, 10000.00), -- 2 spa treatments for booking 3
(4, 1, 4, 6000.00),  -- 4 breakfasts for booking 4
(5, 5, 2, 2400.00);  -- 2 room services for booking 5