USE HotelBookingSystem;
GO

INSERT INTO Rooms (room_number, room_type_id, floor_number, status, has_sea_view, has_balcony) VALUES
('101', 1, 1, 'Available', 0, 0),
('102', 1, 1, 'Available', 0, 1),
('201', 2, 2, 'Available', 1, 1),
('202', 2, 2, 'Maintenance', 1, 1),
('301', 3, 3, 'Available', 1, 1),
('302', 3, 3, 'Available', 1, 1),
('401', 4, 4, 'Available', 1, 1),
('501', 5, 5, 'Available', 1, 1),
('103', 1, 1, 'Available', 0, 0),
('203', 2, 2, 'Available', 1, 1);


INSERT INTO Rooms (room_number, room_type_id, floor_number, status, has_sea_view, has_balcony) VALUES
-- Standard Rooms (1-5)
('101', 1, 1, 'Available', 0, 0),
('102', 1, 1, 'Available', 0, 1),
('103', 2, 1, 'Occupied', 0, 0),
('104', 2, 1, 'Available', 0, 1),
('105', 2, 1, 'Maintenance', 0, 0),

-- Deluxe Rooms (6-10)
('201', 3, 2, 'Available', 1, 1),
('202', 3, 2, 'Occupied', 1, 1),
('203', 4, 2, 'Available', 0, 1),
('204', 4, 2, 'Available', 1, 1),
('205', 4, 2, 'Cleaning', 0, 1),

-- Executive & Specialty Rooms (11-15)
('301', 5, 3, 'Available', 1, 1),
('302', 5, 3, 'Occupied', 1, 1),
('303', 6, 3, 'Available', 1, 1),
('304', 7, 3, 'Available', 0, 1),
('305', 8, 3, 'Available', 1, 1),

-- Premium Rooms (16-20)
('401', 9, 4, 'Available', 1, 1),
('402', 10, 4, 'Available', 0, 0),
('403', 11, 4, 'Occupied', 1, 1),
('404', 12, 4, 'Available', 1, 1),
('405', 13, 4, 'Available', 1, 1),

-- Luxury Suites (21-25)
('501', 14, 5, 'Available', 1, 1),
('502', 15, 5, 'Available', 1, 1),
('503', 16, 5, 'Available', 1, 1),
('504', 17, 5, 'Available', 1, 1),
('505', 18, 5, 'Available', 1, 1);

