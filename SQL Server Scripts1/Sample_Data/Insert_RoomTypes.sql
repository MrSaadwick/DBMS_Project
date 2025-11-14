USE HotelBookingSystem;
GO

INSERT INTO RoomTypes (type_name, description, base_price, capacity, amenities) VALUES
('Standard', 'Comfortable room with basic amenities', 5000.00, 2, 'TV, WiFi, AC, Attached Bath'),
('Deluxe', 'Spacious room with enhanced amenities', 8000.00, 3, 'TV, WiFi, AC, Mini-Fridge, Sofa'),
('Suite', 'Luxurious suite with separate living area', 15000.00, 4, 'TV, WiFi, AC, Mini-Bar, Jacuzzi, Living Room'),
('Executive', 'Business class room with work desk', 12000.00, 2, 'TV, WiFi, AC, Work Desk, Coffee Maker'),
('Presidential', 'Ultra-luxury suite with premium services', 25000.00, 4, 'TV, WiFi, AC, Private Pool, Butler Service');


INSERT INTO RoomTypes (type_name, description, base_price, capacity, amenities) VALUES
('Standard Single', 'Cozy room with single bed, perfect for solo travelers', 3500.00, 1, 'TV, WiFi, AC, Attached Bath, Work Desk'),
('Standard Double', 'Comfortable room with double bed for couples', 5000.00, 2, 'TV, WiFi, AC, Attached Bath, Mini-Fridge'),
('Deluxe King', 'Spacious room with king bed and city view', 8000.00, 2, 'TV, WiFi, AC, Mini-Fridge, Sofa, Coffee Maker'),
('Deluxe Twin', 'Large room with two double beds for friends/family', 8500.00, 3, 'TV, WiFi, AC, Mini-Fridge, Sofa, Balcony'),
('Executive Suite', 'Luxury suite with separate living area', 15000.00, 2, 'TV, WiFi, AC, Mini-Bar, Jacuzzi, Living Room, Work Desk'),
('Presidential Suite', 'Ultra-luxury suite with premium amenities', 25000.00, 4, 'TV, WiFi, AC, Private Pool, Butler Service, Kitchenette'),
('Family Suite', 'Perfect for families with children', 12000.00, 4, 'TV, WiFi, AC, 2 Bedrooms, Kitchenette, Play Area'),
('Honeymoon Suite', 'Romantic suite for newlyweds', 18000.00, 2, 'TV, WiFi, AC, King Bed, Jacuzzi, Champagne, Flower Decor'),
('Business Suite', 'Designed for corporate travelers', 14000.00, 2, 'TV, WiFi, AC, Work Desk, Printer, Meeting Area, Coffee Machine'),
('Accessible Room', 'Wheelchair accessible room', 4500.00, 2, 'TV, WiFi, AC, Roll-in Shower, Lowered Fixtures, Emergency Cord'),
('Ocean View Room', 'Room with stunning ocean view', 9500.00, 2, 'TV, WiFi, AC, Balcony, Sea View, Mini-Fridge'),
('Mountain View Room', 'Room with beautiful mountain view', 7500.00, 2, 'TV, WiFi, AC, Balcony, Mountain View, Coffee Maker'),
('Pool View Room', 'Room overlooking the swimming pool', 7000.00, 2, 'TV, WiFi, AC, Pool View, Mini-Fridge'),
('Garden View Room', 'Room with peaceful garden view', 6000.00, 2, 'TV, WiFi, AC, Garden View, Sitting Area'),
('Corner Suite', 'Spacious corner room with extra windows', 11000.00, 2, 'TV, WiFi, AC, Corner Location, Extra Windows, Sofa'),
('Penthouse', 'Top-floor luxury accommodation', 30000.00, 3, 'TV, WiFi, AC, Private Terrace, Bar, Jacuzzi, 360° View'),
('Junior Suite', 'Small suite with upgraded amenities', 9000.00, 2, 'TV, WiFi, AC, Separate Sitting Area, Mini-Bar'),
('Connecting Rooms', 'Two rooms with connecting door for families', 16000.00, 6, 'TV, WiFi, AC, Connecting Door, 2 Bathrooms'),
('Bridal Suite', 'Special suite for wedding parties', 22000.00, 2, 'TV, WiFi, AC, Romantic Decor, Champagne, Flower Arrangements'),
('Royal Suite', 'Ultimate luxury experience', 35000.00, 3, 'TV, WiFi, AC, Private Chef, Limo Service, Personal Butler');