EXEC CancelBooking 
    @booking_id = 1,
    @staff_id = 1,
    @cancellation_reason = 'Guest Request',
    @detailed_reason = 'Change in travel plans';