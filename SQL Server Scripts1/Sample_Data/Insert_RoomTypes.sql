USE HotelBookingSystem;
GO

-- Safe insert for all room types (only inserts non-existing ones)
INSERT INTO RoomTypes (type_name, description, base_price, capacity, amenities)
SELECT type_name, description, base_price, capacity, amenities
FROM (
    VALUES 
    ('Standard', 'Comfortable room with basic amenities', 5000.00, 2, 'TV, WiFi, AC, Attached Bath'),
    ('Deluxe', 'Spacious room with enhanced amenities', 8000.00, 3, 'TV, WiFi, AC, Mini-Fridge, Sofa'),
    ('Suite', 'Luxurious suite with separate living area', 15000.00, 4, 'TV, WiFi, AC, Mini-Bar, Jacuzzi, Living Room'),
    ('Executive', 'Business class room with work desk', 12000.00, 2, 'TV, WiFi, AC, Work Desk, Coffee Maker'),
    ('Presidential', 'Ultra-luxury suite with premium services', 25000.00, 4, 'TV, WiFi, AC, Private Pool, Butler Service'),
    ('Family Suite', 'Two-room suite perfect for families with children', 18000.00, 5, 'TV, WiFi, AC, Two Bedrooms, Kitchenette, Dining Area'),
    ('Honeymoon Suite', 'Romantic suite with special amenities for couples', 22000.00, 2, 'TV, WiFi, AC, King Bed, Champagne, Rose Petals, Jacuzzi'),
    ('Business Suite', 'Executive suite with enhanced work facilities', 16000.00, 2, 'TV, WiFi, AC, Office Setup, Printer, Conference Table'),
    ('Poolside Villa', 'Private villa with direct pool access', 30000.00, 4, 'TV, WiFi, AC, Private Pool, Garden, Outdoor Shower'),
    ('Accessible Deluxe', 'Deluxe room designed for wheelchair access', 8500.00, 2, 'TV, WiFi, AC, Wheelchair Access, Grab Bars, Roll-in Shower'),
    ('Penthouse Suite', 'Top-floor suite with panoramic city views', 35000.00, 6, 'TV, WiFi, AC, Private Terrace, Bar, Home Theater'),
    ('Garden Suite', 'Ground floor suite with private garden', 19000.00, 3, 'TV, WiFi, AC, Private Garden, Patio, Hammock'),
    ('Ocean View Room', 'Room with breathtaking ocean views', 14000.00, 2, 'TV, WiFi, AC, Ocean View, Balcony, Binoculars'),
    ('Mountain View Room', 'Room overlooking mountain ranges', 12000.00, 2, 'TV, WiFi, AC, Mountain View, Fireplace, Hot Tub'),
    ('Royal Suite', 'Opulent suite with royal treatment', 45000.00, 4, 'TV, WiFi, AC, Butler Service, Private Chef, Limo Service'),
    ('Studio Apartment', 'Self-contained studio with kitchen', 11000.00, 2, 'TV, WiFi, AC, Kitchenette, Dining Table, Sofa Bed'),
    ('Connecting Rooms', 'Two connecting rooms for larger groups', 22000.00, 6, 'TV, WiFi, AC, Two Rooms, Shared Door, Two Bathrooms'),
    ('Pet-Friendly Room', 'Special room for guests with pets', 9000.00, 2, 'TV, WiFi, AC, Pet Bed, Food Bowls, Pet Toys'),
    ('Wellness Suite', 'Room focused on health and wellness', 17000.00, 2, 'TV, WiFi, AC, Yoga Mat, Air Purifier, Essential Oils'),
    ('Art Deco Room', 'Themed room with artistic decor', 13000.00, 2, 'TV, WiFi, AC, Art Pieces, Vintage Furniture, Record Player'),
    ('Japanese Style Room', 'Traditional Japanese tatami room', 16000.00, 3, 'TV, WiFi, AC, Tatami Mats, Futons, Tea Ceremony Set'),
    ('Ski Chalet', 'Winter-themed room for ski enthusiasts', 20000.00, 4, 'TV, WiFi, AC, Fireplace, Ski Rack, Boot Warmer'),
    ('Library Suite', 'Suite with extensive book collection', 14000.00, 2, 'TV, WiFi, AC, Library, Reading Chairs, Writing Desk'),
    ('Technology Suite', 'Room with latest tech gadgets', 18000.00, 2, 'TV, WiFi, AC, Smart Home, VR Setup, Gaming Console'),
    ('Meditation Room', 'Peaceful room for relaxation', 9500.00, 1, 'WiFi, Meditation Cushions, Sound System, Incense')
) AS NewRooms(type_name, description, base_price, capacity, amenities)
WHERE NOT EXISTS (
    SELECT 1 FROM RoomTypes rt 
    WHERE rt.type_name = NewRooms.type_name
);

-- Display results
DECLARE @InsertedCount INT = @@ROWCOUNT;
PRINT 'Successfully inserted ' + CAST(@InsertedCount AS VARCHAR) + ' new room types';

-- Show current room types in the database
SELECT 
    type_id,
    type_name, 
    base_price,
    capacity,
    amenities
FROM RoomTypes 
ORDER BY base_price ASC;

select * from RoomTypes;

