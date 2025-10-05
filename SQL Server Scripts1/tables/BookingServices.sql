CREATE TABLE BookingServices (
    booking_service_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT DEFAULT 1,
    service_date DATETIME DEFAULT GETDATE(),
    total_price DECIMAL(10,2),
    notes TEXT,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);