CREATE TABLE Cancellations (
    cancellation_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT NOT NULL,
    cancelled_by_user_id INT, -- staff who processed cancellation
    cancellation_date DATETIME DEFAULT GETDATE(),
    cancellation_reason VARCHAR(100),
    detailed_reason TEXT,
    refund_amount DECIMAL(10,2),
    refund_percentage INT,
    original_booking_amount DECIMAL(10,2) NOT NULL, -- This was missing!
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);