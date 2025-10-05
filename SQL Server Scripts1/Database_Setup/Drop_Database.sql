-- Drop database if exists (use with caution!)
USE master;
GO

-- Drop connections first
ALTER DATABASE HotelBookingSystem SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Drop the database
DROP DATABASE IF EXISTS HotelBookingSystem;
GO