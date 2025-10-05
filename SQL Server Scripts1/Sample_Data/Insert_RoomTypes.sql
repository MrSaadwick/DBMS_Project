USE HotelBookingSystem;
GO

INSERT INTO RoomTypes (type_name, description, base_price, capacity, amenities) VALUES
('Standard', 'Comfortable room with basic amenities', 5000.00, 2, 'TV, WiFi, AC, Attached Bath'),
('Deluxe', 'Spacious room with enhanced amenities', 8000.00, 3, 'TV, WiFi, AC, Mini-Fridge, Sofa'),
('Suite', 'Luxurious suite with separate living area', 15000.00, 4, 'TV, WiFi, AC, Mini-Bar, Jacuzzi, Living Room'),
('Executive', 'Business class room with work desk', 12000.00, 2, 'TV, WiFi, AC, Work Desk, Coffee Maker'),
('Presidential', 'Ultra-luxury suite with premium services', 25000.00, 4, 'TV, WiFi, AC, Private Pool, Butler Service');