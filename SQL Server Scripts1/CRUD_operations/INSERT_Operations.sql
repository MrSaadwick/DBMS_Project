USE HotelBookingSystem;
GO

-- 1. INSERT a new Guest
INSERT INTO Guests (first_name, last_name, email, phone, address, id_card_number, date_of_birth)
VALUES ('John', 'Smith', 'john.smith@email.com', '03001239999', 'House 456, Model Town, Lahore', '3520198765432', '1990-08-25');

-- 2. INSERT a new Room Type
INSERT INTO RoomTypes (type_name, description, base_price, capacity, amenities)
VALUES ('Family Suite', 'Large suite perfect for families', 18000.00, 5, 'TV, WiFi, AC, Kitchenette, 2 Bedrooms');

-- 3. INSERT a new Room
INSERT INTO Rooms (room_number, room_type_id, floor_number, status, has_sea_view, has_balcony)
VALUES ('601', 3, 6, 'Available', 1, 1);

-- 4. INSERT a new Staff member
INSERT INTO Staff (first_name, last_name, email, phone, position, department, salary)
VALUES ('Sana', 'Khan', 'sana.khan@hotel.com', '03331239999', 'Assistant Manager', 'Administration', 80000.00);

-- 5. INSERT a new Service
INSERT INTO Services (service_name, description, price, category, is_available)
VALUES ('Car Rental', 'Daily car rental service', 3500.00, 'Transport', 1);

-- 6. INSERT a new Booking
INSERT INTO Bookings (guest_id, room_id, staff_id, check_in_date, check_out_date, total_amount, adults_count, children_count)
VALUES (3, 5, 1, '2024-03-10', '2024-03-15', 75000.00, 2, 1);

-- 7. INSERT a new Payment
INSERT INTO Payments (booking_id, amount, payment_method, transaction_id, status)
VALUES (7, 37500.00, 'Credit Card', 'TXN001241', 'Completed');

-- 8. INSERT a Booking Service
INSERT INTO BookingServices (booking_id, service_id, quantity, total_price)
VALUES (7, 1, 5, 7500.00);