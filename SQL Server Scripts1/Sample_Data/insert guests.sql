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


INSERT INTO Guests (first_name, last_name, email, phone, address, id_card_number, date_of_birth) VALUES
('Ali', 'Khan', 'ali.khan@email.com', '03001234567', 'House 123, Street 45, Lahore', '3520112345671', '1985-03-15'),
('Sara', 'Ahmed', 'sara.ahmed@email.com', '03331234568', 'Flat 5, Commercial Area, Karachi', '3520112345672', '1990-07-22'),
('Usman', 'Malik', 'usman.malik@email.com', '03121234569', 'Plot 67, DHA, Islamabad', '3520112345673', '1988-11-30'),
('Fatima', 'Raza', 'fatima.raza@email.com', '03451234570', 'House 89, Gulberg, Lahore', '3520112345674', '1992-05-18'),
('Bilal', 'Hassan', 'bilal.hassan@email.com', '03001234571', 'Suite 12, Clifton, Karachi', '3520112345675', '1987-09-10'),
('Ayesha', 'Butt', 'ayesha.butt@email.com', '03331234572', 'House 34, Model Town, Lahore', '3520112345676', '1993-12-25'),
('Omar', 'Farooq', 'omar.farooq@email.com', '03121234573', 'Flat 8, Blue Area, Islamabad', '3520112345677', '1986-08-14'),
('Zainab', 'Shah', 'zainab.shah@email.com', '03451234574', 'House 56, Bahria Town, Lahore', '3520112345678', '1991-04-30'),
('Kamran', 'Ali', 'kamran.ali@email.com', '03001234575', 'Plot 23, DHA, Karachi', '3520112345679', '1984-01-20'),
('Nadia', 'Khan', 'nadia.khan@email.com', '03331234576', 'House 78, F-7, Islamabad', '3520112345680', '1994-06-08'),
('Ahmed', 'Raza', 'ahmed.raza@email.com', '03121234577', 'Flat 15, Gulshan, Karachi', '3520112345681', '1989-02-17'),
('Saima', 'Malik', 'saima.malik@email.com', '03451234578', 'House 90, Johar Town, Lahore', '3520112345682', '1995-10-12'),
('Haris', 'Chaudhry', 'haris.chaudhry@email.com', '03001234579', 'Plot 45, DHA, Islamabad', '3520112345683', '1983-07-03'),
('Mehak', 'Akhtar', 'mehak.akhtar@email.com', '03331234580', 'House 67, Clifton, Karachi', '3520112345684', '1996-09-28'),
('Faisal', 'Iqbal', 'faisal.iqbal@email.com', '03121234581', 'Flat 22, Gulberg, Lahore', '3520112345685', '1982-12-15'),
('Rabia', 'Tariq', 'rabia.tariq@email.com', '03451234582', 'House 33, F-8, Islamabad', '3520112345686', '1997-03-22'),
('Waseem', 'Haider', 'waseem.haider@email.com', '03001234583', 'Plot 89, DHA, Karachi', '3520112345687', '1981-05-19'),
('Sana', 'Rasheed', 'sana.rasheed@email.com', '03331234584', 'House 44, Model Town, Lahore', '3520112345688', '1998-08-07'),
('Tariq', 'Mahmood', 'tariq.mahmood@email.com', '03121234585', 'Flat 18, Blue Area, Islamabad', '3520112345689', '1980-11-11'),
('Hina', 'Khalid', 'hina.khalid@email.com', '03451234586', 'House 55, Bahria Town, Karachi', '3520112345690', '1999-01-30'),
('Imran', 'Saeed', 'imran.saeed@email.com', '03001234587', 'Plot 12, DHA, Lahore', '3520112345691', '1979-04-25'),
('Sadia', 'Nawaz', 'sadia.nawaz@email.com', '03331234588', 'House 88, F-6, Islamabad', '3520112345692', '2000-07-14'),
('Asif', 'Rahman', 'asif.rahman@email.com', '03121234589', 'Flat 25, Clifton, Karachi', '3520112345693', '1978-10-08'),
('Noreen', 'Akram', 'noreen.akram@email.com', '03451234590', 'House 77, Gulberg, Lahore', '3520112345694', '2001-12-19'),
('Kashif', 'Javed', 'kashif.javed@email.com', '03001234591', 'Plot 34, DHA, Islamabad', '3520112345695', '1977-02-28');