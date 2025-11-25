EXEC GetRevenueReport @start_date = '2025-11-01', @group_by = 'monthly';
EXEC GetBookingReport @status = 'Confirmed', @room_type_id = 1;
EXEC GetDashboardStats;