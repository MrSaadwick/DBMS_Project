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
