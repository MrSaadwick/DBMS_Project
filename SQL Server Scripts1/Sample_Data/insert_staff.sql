USE HotelBookingSystem;
GO

INSERT INTO Staff (first_name, last_name, email, phone, position, department, salary) VALUES
('Ahmed', 'Raza', 'ahmed.raza@hotel.com', '03001234580', 'Receptionist', 'Front Desk', 45000.00),
('Ayesha', 'Butt', 'ayesha.butt@hotel.com', '03331234581', 'Manager', 'Administration', 120000.00),
('Kamran', 'Ali', 'kamran.ali@hotel.com', '03121234582', 'Housekeeper', 'Housekeeping', 35000.00),
('Zainab', 'Shah', 'zainab.shah@hotel.com', '03451234583', 'Chef', 'Food & Beverage', 80000.00),
('Omar', 'Farooq', 'omar.farooq@hotel.com', '03001234584', 'Security', 'Security', 40000.00);

INSERT INTO Staff (first_name, last_name, email, phone, position, department, salary, hire_date) VALUES
('Ahmed', 'Raza', 'ahmed.raza@luxuryhotel.com', '03009876541', 'Receptionist', 'Front Desk', 45000.00, '2022-01-15'),
('Ayesha', 'Butt', 'ayesha.butt@luxuryhotel.com', '03339876542', 'Manager', 'Administration', 120000.00, '2020-03-10'),
('Kamran', 'Ali', 'kamran.ali@luxuryhotel.com', '03129876543', 'Housekeeping Supervisor', 'Housekeeping', 55000.00, '2021-06-20'),
('Zainab', 'Shah', 'zainab.shah@luxuryhotel.com', '03459876544', 'Executive Chef', 'Food & Beverage', 150000.00, '2019-08-05'),
('Omar', 'Farooq', 'omar.farooq@luxuryhotel.com', '03009876545', 'Security Head', 'Security', 60000.00, '2022-02-28'),
('Sana', 'Khan', 'sana.khan@luxuryhotel.com', '03339876546', 'Concierge', 'Front Desk', 48000.00, '2023-01-10'),
('Bilal', 'Hassan', 'bilal.hassan@luxuryhotel.com', '03129876547', 'IT Manager', 'IT Department', 90000.00, '2021-04-15'),
('Fatima', 'Malik', 'fatima.malik@luxuryhotel.com', '03459876548', 'Sales Manager', 'Sales & Marketing', 110000.00, '2020-11-20'),
('Usman', 'Akhtar', 'usman.akhtar@luxuryhotel.com', '03009876549', 'Maintenance Supervisor', 'Maintenance', 52000.00, '2022-07-12'),
('Nadia', 'Chaudhry', 'nadia.chaudhry@luxuryhotel.com', '03339876550', 'Spa Manager', 'Wellness', 85000.00, '2021-09-25'),
('Haris', 'Rasheed', 'haris.rasheed@luxuryhotel.com', '03129876551', 'Assistant Manager', 'Administration', 75000.00, '2022-03-18'),
('Mehak', 'Tariq', 'mehak.tariq@luxuryhotel.com', '03459876552', 'Event Planner', 'Events', 68000.00, '2023-02-14'),
('Faisal', 'Iqbal', 'faisal.iqbal@luxuryhotel.com', '03009876553', 'Head Waiter', 'Food & Beverage', 42000.00, '2022-05-30'),
('Rabia', 'Khalid', 'rabia.khalid@luxuryhotel.com', '03339876554', 'HR Manager', 'Human Resources', 95000.00, '2020-12-01'),
('Waseem', 'Nawaz', 'waseem.nawaz@luxuryhotel.com', '03129876555', 'Accountant', 'Finance', 80000.00, '2021-08-22'),
('Saima', 'Rahman', 'saima.rahman@luxuryhotel.com', '03459876556', 'Housekeeper', 'Housekeeping', 35000.00, '2023-03-05'),
('Tariq', 'Mahmood', 'tariq.mahmood@luxuryhotel.com', '03009876557', 'Bell Captain', 'Front Desk', 38000.00, '2022-09-17'),
('Hina', 'Saeed', 'hina.saeed@luxuryhotel.com', '03339876558', 'Reservation Agent', 'Reservations', 46000.00, '2023-01-08'),
('Imran', 'Javed', 'imran.javed@luxuryhotel.com', '03129876559', 'Security Guard', 'Security', 32000.00, '2022-11-11'),
('Sadia', 'Akram', 'sadia.akram@luxuryhotel.com', '03459876560', 'Cleaner', 'Housekeeping', 30000.00, '2023-04-20');
