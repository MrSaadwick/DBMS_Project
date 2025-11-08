CREATE TABLE Bookings (
    booking_id INT IDENTITY(1,1) PRIMARY KEY,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    staff_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    booking_date DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Confirmed' CHECK (status IN ('Confirmed', 'Checked-In', 'Checked-Out', 'Cancelled')),
    special_requests TEXT,
    adults_count INT DEFAULT 1,
    children_count INT DEFAULT 0,
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);
-- Run these in SQL Server if you haven't added these columns
ALTER TABLE Bookings ADD 
    discount_percent DECIMAL(5,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    services_amount DECIMAL(10,2) DEFAULT 0;

    -- Safe column addition - only add if they don't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bookings' AND COLUMN_NAME = 'discount_percent')
BEGIN
    ALTER TABLE Bookings ADD discount_percent DECIMAL(5,2) DEFAULT 0;
    PRINT 'Added discount_percent column';
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bookings' AND COLUMN_NAME = 'discount_amount')
BEGIN
    ALTER TABLE Bookings ADD discount_amount DECIMAL(10,2) DEFAULT 0;
    PRINT 'Added discount_amount column';
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bookings' AND COLUMN_NAME = 'tax_amount')
BEGIN
    ALTER TABLE Bookings ADD tax_amount DECIMAL(10,2) DEFAULT 0;
    PRINT 'Added tax_amount column';
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bookings' AND COLUMN_NAME = 'services_amount')
BEGIN
    ALTER TABLE Bookings ADD services_amount DECIMAL(10,2) DEFAULT 0;
    PRINT 'Added services_amount column';
END

-- Verify the table structure
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Bookings'
ORDER BY ORDINAL_POSITION;

select * from Bookings;
