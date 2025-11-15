use HotelBookingSystem;
Go
CREATE TABLE Cancellations (
    cancellation_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT NOT NULL,
    cancelled_by_staff_id INT NOT NULL,  -- ← ALREADY EXISTS!
    cancelled_by_guest_id INT,
    cancellation_date DATETIME DEFAULT GETDATE(),
    cancellation_reason VARCHAR(100) NOT NULL,
    detailed_reason TEXT,
    original_booking_amount DECIMAL(10,2) NOT NULL,
    refund_amount DECIMAL(10,2) NOT NULL,
    cancellation_fee DECIMAL(10,2) DEFAULT 0,
    refund_percentage DECIMAL(5,2) NOT NULL,
    cancellation_type VARCHAR(20) NOT NULL,
    days_before_checkin INT NOT NULL,
    refund_status VARCHAR(20) DEFAULT 'Pending',
    refund_processed_date DATETIME,
    refund_method VARCHAR(20),
    refund_transaction_id VARCHAR(100),
    created_date DATETIME DEFAULT GETDATE(),
    updated_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id),
    FOREIGN KEY (cancelled_by_staff_id) REFERENCES Staff(staff_id),  -- ← FOREIGN KEY EXISTS!
    FOREIGN KEY (cancelled_by_guest_id) REFERENCES Guests(guest_id)
);