USE HotelBookingSystem;
GO

-- Safe insert for 15 additional room types (excluding Family Suite)
DECLARE @NewRoomTypes TABLE (
    type_name VARCHAR(50),
    description TEXT,
    base_price DECIMAL(10,2),
    capacity INT,
    amenities TEXT
);

INSERT INTO @NewRoomTypes VALUES
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
('Japanese Style Room', 'Traditional Japanese tatami room', 16000.00, 3, 'TV, WiFi, AC, Tatami Mats, Futons, Tea Ceremony Set');

-- Insert only non-existing room types
INSERT INTO RoomTypes (type_name, description, base_price, capacity, amenities)
SELECT nrt.type_name, nrt.description, nrt.base_price, nrt.capacity, nrt.amenities
FROM @NewRoomTypes nrt
WHERE NOT EXISTS (SELECT 1 FROM RoomTypes rt WHERE rt.type_name = nrt.type_name);

PRINT 'Successfully inserted ' + CAST(@@ROWCOUNT AS VARCHAR) + ' new room types';

select * from RoomTypes;

