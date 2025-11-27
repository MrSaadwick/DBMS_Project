EXEC CancelBooking 
    @booking_id = 22,
    @staff_id = 1,
    @cancellation_reason = 'Change of plans',
    @detailed_reason = 'Guest called to cancel due to family emergency';

    select * from Cancellations;
    select * from Bookings;