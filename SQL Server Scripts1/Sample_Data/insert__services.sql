USE HotelBookingSystem;
GO

INSERT INTO Services (service_name, description, price, category, is_available) VALUES
('Breakfast Buffet', 'Continental breakfast buffet', 1500.00, 'Food', 1),
('Spa Treatment', 'Full body massage and spa', 5000.00, 'Spa', 1),
('Laundry Service', 'Dry cleaning and laundry', 800.00, 'Laundry', 1),
('Airport Transfer', 'Pickup and drop from airport', 2000.00, 'Transport', 1),
('Room Service', '24/7 in-room dining', 1200.00, 'Food', 1),
('Swimming Pool Access', 'Daily pool access', 1000.00, 'Recreation', 1),
('Business Center', 'Computer and printing services', 500.00, 'Business', 1);