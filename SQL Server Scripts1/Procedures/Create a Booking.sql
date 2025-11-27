EXEC CreateBooking 
    @guest_id = 8,
    @room_id = 4, 
    @staff_id = 3,
    @check_in_date = '2025-12-01',
    @check_out_date = '2025-12-05',
    @service_ids = '1:3,2:1,3:2', -- 3 breakfasts, 1 spa, 2 airport transfers
    @discount_percent = 10.0;

    select * from Bookings;

    select * from Rooms;
    -- Test the booking creation
EXEC CreateBooking 
    @guest_id = 5,
    @room_id = 9,
    @staff_id = 2,
    @check_in_date = '2024-02-15',
    @check_out_date = '2024-02-18',
    @adults_count = 2,
    @children_count = 1,
    @special_requests = 'Late check-in requested',
    @service_ids = '1:2,3:1',  -- 2x Breakfast, 1x Airport pickup
    @discount_percent = 5.00;