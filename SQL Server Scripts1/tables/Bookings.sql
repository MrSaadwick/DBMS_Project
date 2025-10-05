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