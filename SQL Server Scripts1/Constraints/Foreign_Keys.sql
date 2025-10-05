-- Add additional foreign key constraints and relationships

-- Rooms -> RoomTypes (already defined in table creation)
-- Bookings -> Guests, Rooms, Staff (already defined in table creation)
-- Payments -> Bookings (already defined in table creation)
-- BookingServices -> Bookings, Services (already defined in table creation)

-- Additional foreign key for cascading deletes (if needed)
ALTER TABLE Bookings
ADD CONSTRAINT FK_Bookings_Guests_Cascade
FOREIGN KEY (guest_id) REFERENCES Guests(guest_id)
ON DELETE CASCADE;

ALTER TABLE Payments
ADD CONSTRAINT FK_Payments_Bookings_Cascade  
FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
ON DELETE CASCADE;

ALTER TABLE BookingServices
ADD CONSTRAINT FK_BookingServices_Bookings_Cascade
FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
ON DELETE CASCADE;