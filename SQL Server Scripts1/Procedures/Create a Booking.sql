EXEC CreateBooking 
    @guest_id = 1,
    @room_id = 1, 
    @staff_id = 1,
    @check_in_date = '2025-12-01',
    @check_out_date = '2025-12-05',
    @service_ids = '1:3,2:1,3:2', -- 3 breakfasts, 1 spa, 2 airport transfers
    @discount_percent = 10.0;