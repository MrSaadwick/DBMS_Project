USE HotelBookingSystem;
GO
INSERT INTO Guests (first_name, last_name, email, phone, address, id_card_number, date_of_birth) VALUES
('Ali', 'Khan', 'ali.khan@email.com', '03001234567', 'House 123, Street 45, Lahore', '3520112345671', '1985-03-15'),
('Sara', 'Ahmed', 'sara.ahmed@email.com', '03331234568', 'Flat 5, Commercial Area, Karachi', '3520112345672', '1990-07-22'),
('Usman', 'Malik', 'usman.malik@email.com', '03121234569', 'Plot 67, DHA, Islamabad', '3520112345673', '1988-11-30'),
('Fatima', 'Raza', 'fatima.raza@email.com', '03451234570', 'House 89, Gulberg, Lahore', '3520112345674', '1992-05-18'),
('Bilal', 'Hassan', 'bilal.hassan@email.com', '03001234571', 'Suite 12, Clifton, Karachi', '3520112345675', '1987-09-10');
-- Add 5-10 more guests...

select * from Guests;
select * from payments;