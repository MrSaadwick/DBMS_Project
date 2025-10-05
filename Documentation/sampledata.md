USE HotelBookingSystem;
GO

INSERT INTO RoomTypes (type_name, description, base_price, capacity, amenities) VALUES
('Standard', 'Comfortable room with basic amenities', 5000.00, 2, 'TV, WiFi, AC, Attached Bath'),
('Deluxe', 'Spacious room with enhanced amenities', 8000.00, 3, 'TV, WiFi, AC, Mini-Fridge, Sofa'),
('Suite', 'Luxurious suite with separate living area', 15000.00, 4, 'TV, WiFi, AC, Mini-Bar, Jacuzzi, Living Room'),
('Executive', 'Business class room with work desk', 12000.00, 2, 'TV, WiFi, AC, Work Desk, Coffee Maker'),
('Presidential', 'Ultra-luxury suite with premium services', 25000.00, 4, 'TV, WiFi, AC, Private Pool, Butler Service');

USE HotelBookingSystem;
GO

INSERT INTO Guests (first_name, last_name, email, phone, address, id_card_number, date_of_birth) VALUES
('Ali', 'Khan', 'ali.khan@email.com', '03001234567', 'House 123, Street 45, Lahore', '3520112345671', '1985-03-15'),
('Sara', 'Ahmed', 'sara.ahmed@email.com', '03331234568', 'Flat 5, Commercial Area, Karachi', '3520112345672', '1990-07-22'),
('Usman', 'Malik', 'usman.malik@email.com', '03121234569', 'Plot 67, DHA, Islamabad', '3520112345673', '1988-11-30'),
('Fatima', 'Raza', 'fatima.raza@email.com', '03451234570', 'House 89, Gulberg, Lahore', '3520112345674', '1992-05-18'),
('Bilal', 'Hassan', 'bilal.hassan@email.com', '03001234571', 'Suite 12, Clifton, Karachi', '3520112345675', '1987-09-10');
-- Add 5-10 more guests...

USE HotelBookingSystem;
GO

INSERT INTO Staff (first_name, last_name, email, phone, position, department, salary) VALUES
('Ahmed', 'Raza', 'ahmed.raza@hotel.com', '03001234580', 'Receptionist', 'Front Desk', 45000.00),
('Ayesha', 'Butt', 'ayesha.butt@hotel.com', '03331234581', 'Manager', 'Administration', 120000.00),
('Kamran', 'Ali', 'kamran.ali@hotel.com', '03121234582', 'Housekeeper', 'Housekeeping', 35000.00),
('Zainab', 'Shah', 'zainab.shah@hotel.com', '03451234583', 'Chef', 'Food & Beverage', 80000.00),
('Omar', 'Farooq', 'omar.farooq@hotel.com', '03001234584', 'Security', 'Security', 40000.00);

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

USE HotelBookingSystem;
GO

INSERT INTO Bookings (guest_id, room_id, staff_id, check_in_date, check_out_date, total_amount, status, adults_count, children_count) VALUES
(1, 1, 1, '2024-01-15', '2024-01-18', 15000.00, 'Checked-Out', 2, 0),
(2, 3, 1, '2024-01-20', '2024-01-25', 40000.00, 'Confirmed', 2, 1),
(3, 5, 2, '2024-01-22', '2024-01-24', 30000.00, 'Checked-In', 3, 0),
(4, 7, 1, '2024-02-01', '2024-02-05', 48000.00, 'Confirmed', 2, 0),
(5, 2, 2, '2024-02-10', '2024-02-12', 10000.00, 'Confirmed', 1, 0),
(1, 6, 1, '2024-02-15', '2024-02-20', 75000.00, 'Confirmed', 4, 2),
(2, 8, 2, '2024-03-01', '2024-03-05', 125000.00, 'Confirmed', 2, 0);


USE HotelBookingSystem;
GO

INSERT INTO Bookings (guest_id, room_id, staff_id, check_in_date, check_out_date, total_amount, status, adults_count, children_count) VALUES
(1, 1, 1, '2024-01-15', '2024-01-18', 15000.00, 'Checked-Out', 2, 0),
(2, 3, 1, '2024-01-20', '2024-01-25', 40000.00, 'Confirmed', 2, 1),
(3, 5, 2, '2024-01-22', '2024-01-24', 30000.00, 'Checked-In', 3, 0),
(4, 7, 1, '2024-02-01', '2024-02-05', 48000.00, 'Confirmed', 2, 0),
(5, 2, 2, '2024-02-10', '2024-02-12', 10000.00, 'Confirmed', 1, 0),
(1, 6, 1, '2024-02-15', '2024-02-20', 75000.00, 'Confirmed', 4, 2),
(2, 8, 2, '2024-03-01', '2024-03-05', 125000.00, 'Confirmed', 2, 0);



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




