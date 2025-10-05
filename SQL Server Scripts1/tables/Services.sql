CREATE TABLE Services (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50),
    is_available BIT DEFAULT 1,
    created_date DATETIME DEFAULT GETDATE()
);