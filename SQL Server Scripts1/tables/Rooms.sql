CREATE TABLE Rooms (
    room_id INT IDENTITY(1,1) PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type_id INT NOT NULL,
    floor_number INT,
    status VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Occupied', 'Maintenance', 'Cleaning')),
    has_sea_view BIT DEFAULT 0,
    has_balcony BIT DEFAULT 0,
    created_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (room_type_id) REFERENCES RoomTypes(room_type_id)
);