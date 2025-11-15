USE HotelBookingSystem;
GO

select * from Cancellations;

INSERT INTO Cancellations (booking_id, cancelled_by_staff_id, cancellation_reason, detailed_reason, original_booking_amount, refund_amount, cancellation_fee, refund_percentage, cancellation_type, days_before_checkin, refund_status) VALUES

-- No Show Cancellations (9-12)
(9, 1, 'No Show', 'Guest did not arrive and no communication', 20000.00, 2000.00, 18000.00, 10.0, 'No Show', 0, 'Not Applicable'),
(21, 2, 'No Show', 'No response to multiple contact attempts', 34000.00, 3400.00, 30600.00, 10.0, 'No Show', 0, 'Not Applicable'),
(11, 1, 'No Show', 'Corporate booking - company went silent', 60000.00, 6000.00, 54000.00, 10.0, 'No Show', 0, 'Not Applicable'),
(12, 2, 'No Show', 'International guest - flight issues suspected', 48000.00, 4800.00, 43200.00, 10.0, 'No Show', 0, 'Not Applicable'),


-- Weather & Travel Restrictions (16-18)
(16, 2, 'Weather Conditions', 'Severe weather alert in guest''s area', 64000.00, 57600.00, 6400.00, 90.0, 'Before Check-in', 4, 'Processed'),
(17, 1, 'Travel Restrictions', 'New travel restrictions implemented', 105000.00, 94500.00, 10500.00, 90.0, 'Before Check-in', 6, 'Processed'),
(18, 2, 'Weather Conditions', 'Hurricane warning affecting travel', 20000.00, 18000.00, 2000.00, 90.0, 'Before Check-in', 3, 'Processed'),

-- Personal Emergencies (19-20)
(19, 1, 'Personal Emergency', 'Family bereavement', 51000.00, 45900.00, 5100.00, 90.0, 'Before Check-in', 5, 'Processed'),
(20, 2, 'Personal Emergency', 'Medical emergency requiring hospitalization', 120000.00, 108000.00, 12000.00, 90.0, 'Before Check-in', 8, 'Processed');


-- Get list of existing booking IDs
SELECT booking_id FROM Bookings ORDER BY booking_id;