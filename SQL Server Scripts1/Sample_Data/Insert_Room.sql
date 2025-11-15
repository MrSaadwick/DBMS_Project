USE HotelBookingSystem;
GO



INSERT INTO Rooms (room_number, room_type_id, floor_number, status, has_sea_view, has_balcony) VALUES

-- Deluxe Rooms (6-10)
('207', 24, 2, 'Available', 1, 1),
('206', 23, 2, 'Occupied', 1, 1),
('203', 22, 2, 'Available', 0, 1),
('204', 21, 2, 'Available', 1, 1),
('205', 20, 2, 'Cleaning', 0, 1),

-- Executive & Specialty Rooms (11-15)
('306', 25, 3, 'Available', 1, 1),
('307', 19, 3, 'Occupied', 1, 1),
('303', 6, 3, 'Available', 1, 1),
('304', 7, 3, 'Available', 0, 1),
('305', 8, 3, 'Available', 1, 1),

-- Premium Rooms (16-20)
('406', 9, 4, 'Available', 1, 1),
('407', 10, 4, 'Available', 0, 0),
('403', 11, 4, 'Occupied', 1, 1),
('404', 12, 4, 'Available', 1, 1),
('405', 13, 4, 'Available', 1, 1),

-- Luxury Suites (21-25)
('506', 14, 5, 'Available', 1, 1),
('502', 15, 5, 'Available', 1, 1),
('503', 16, 5, 'Available', 1, 1),
('504', 17, 5, 'Available', 1, 1),
('505', 18, 5, 'Available', 1, 1);

select * from Rooms;

