-- Additional check constraints for data validation

-- Drop the existing constraint
ALTER TABLE Payments DROP CONSTRAINT CHK_Payments_Amount;

-- Add new constraint that includes 'Refund'
ALTER TABLE Payments 
ADD CONSTRAINT CHK_Payments_Method 
CHECK (payment_method IN ('Cash', 'Credit Card', 'Debit Card', 'Online Transfer', 'Refund'));

-- Ensure check_out_date is after check_in_date
ALTER TABLE Bookings
ADD CONSTRAINT CHK_Bookings_CheckDates
CHECK (check_out_date > check_in_date);

-- Ensure booking dates are not in the past
ALTER TABLE Bookings  
ADD CONSTRAINT CHK_Bookings_FutureDates
CHECK (booking_date <= GETDATE());

-- Ensure price values are positive
ALTER TABLE RoomTypes
ADD CONSTRAINT CHK_RoomTypes_Price
CHECK (base_price > 0);

ALTER TABLE Services
ADD CONSTRAINT CHK_Services_Price
CHECK (price >= 0);

ALTER TABLE Payments
ADD CONSTRAINT CHK_Payments_Amount
CHECK (amount > 0);

-- Ensure email format is valid
ALTER TABLE Guests
ADD CONSTRAINT CHK_Guests_Email
CHECK (email LIKE '%@%.%');

ALTER TABLE Staff
ADD CONSTRAINT CHK_Staff_Email
CHECK (email LIKE '%@%.%');

-- Ensure phone number has at least 10 digits
ALTER TABLE Guests
ADD CONSTRAINT CHK_Guests_Phone
CHECK (LEN(phone) >= 10);

-- Ensure capacity is at least 1
ALTER TABLE RoomTypes
ADD CONSTRAINT CHK_RoomTypes_Capacity
CHECK (capacity >= 1);

-- Ensure quantity is positive
ALTER TABLE BookingServices
ADD CONSTRAINT CHK_BookingServices_Quantity
CHECK (quantity > 0);