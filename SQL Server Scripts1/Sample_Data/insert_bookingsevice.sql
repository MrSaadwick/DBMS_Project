
USE HotelBookingSystem;
GO

select * from BookingServices;

INSERT INTO BookingServices (booking_id, service_id, quantity, total_price, notes) VALUES
-- Breakfast Services (1-5)
(1, 1, 3, 4500.00, 'Daily breakfast for 2 guests'),
(2, 1, 5, 7500.00, 'Family breakfast including child'),
(3, 1, 4, 6000.00, 'Business breakfast meetings'),
(4, 1, 4, 6000.00, 'Honeymoon breakfast in bed'),
(5, 1, 2, 3000.00, 'Single guest breakfast'),

-- Spa & Wellness (6-10)
(6, 2, 2, 10000.00, 'Couples spa treatment'),
(7, 2, 1, 5000.00, 'Anniversary spa package'),
(8, 11, 3, 7500.00, 'Executive fitness sessions'),
(9, 2, 2, 10000.00, 'Relaxation massage'),
(10, 12, 2, 3000.00, 'Babysitting during meetings'),

-- Transport Services (11-15)
(11, 3, 2, 4000.00, 'Airport pickup and drop'),
(12, 3, 1, 2000.00, 'Airport arrival only'),
(13, 8, 3, 10500.00, 'Car rental for city tour'),
(14, 3, 2, 4000.00, 'Round trip airport transfer'),
(15, 8, 1, 3500.00, 'Business car rental'),

-- Special Services (16-20)
(16, 9, 1, 8000.00, 'Romantic private dinner'),
(17, 14, 1, 6000.00, 'Champagne welcome'),
(18, 13, 1, 2000.00, 'Welcome flower arrangement'),
(19, 15, 2, 16000.00, 'Business meeting room rental'),
(20, 16, 1, 7000.00, 'Anniversary photography'),

-- Premium Services (21-25)
(21, 17, 1, 5500.00, 'Golf course access'),
(22, 18, 1, 9000.00, 'Private cooking class'),
(23, 19, 3, 36000.00, 'Butler service for 3 days'),
(24, 20, 1, 25000.00, 'Helicopter city tour'),
(25, 10, 1, 4500.00, 'Guided historical tour');
