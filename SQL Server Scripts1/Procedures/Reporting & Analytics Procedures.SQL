USE HotelBookingSystem;
-- Procedure to get booking report with filters
CREATE PROCEDURE GetBookingReport
    @start_date DATE = NULL,
    @end_date DATE = NULL,
    @status VARCHAR(20) = NULL,
    @room_type_id INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        b.booking_id,
        g.first_name + ' ' + g.last_name as guest_name,
        r.room_number,
        rt.type_name as room_type,
        b.check_in_date,
        b.check_out_date,
        DATEDIFF(DAY, b.check_in_date, b.check_out_date) as stay_duration,
        b.total_amount,
        b.status,
        s.first_name + ' ' + s.last_name as handled_by,
        b.booking_date
    FROM Bookings b
    JOIN Guests g ON b.guest_id = g.guest_id
    JOIN Rooms r ON b.room_id = r.room_id
    JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
    JOIN Staff s ON b.staff_id = s.staff_id
    WHERE 
        (@start_date IS NULL OR b.check_in_date >= @start_date)
        AND (@end_date IS NULL OR b.check_in_date <= @end_date)
        AND (@status IS NULL OR b.status = @status)
        AND (@room_type_id IS NULL OR rt.room_type_id = @room_type_id)
    ORDER BY b.booking_date DESC;
END;
GO

-- Procedure to get revenue report
CREATE PROCEDURE GetRevenueReport
    @start_date DATE = NULL,
    @end_date DATE = NULL,
    @group_by VARCHAR(20) = 'daily' -- daily, weekly, monthly
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @group_by = 'daily'
    BEGIN
        SELECT 
            CAST(payment_date AS DATE) as period,
            COUNT(*) as transaction_count,
            SUM(amount) as total_revenue,
            AVG(amount) as average_transaction
        FROM Payments
        WHERE status = 'Completed'
        AND (@start_date IS NULL OR payment_date >= @start_date)
        AND (@end_date IS NULL OR payment_date <= @end_date)
        GROUP BY CAST(payment_date AS DATE)
        ORDER BY period DESC;
    END
    ELSE IF @group_by = 'weekly'
    BEGIN
        SELECT 
            DATEPART(YEAR, payment_date) as year,
            DATEPART(WEEK, payment_date) as week_number,
            COUNT(*) as transaction_count,
            SUM(amount) as total_revenue
        FROM Payments
        WHERE status = 'Completed'
        AND (@start_date IS NULL OR payment_date >= @start_date)
        AND (@end_date IS NULL OR payment_date <= @end_date)
        GROUP BY DATEPART(YEAR, payment_date), DATEPART(WEEK, payment_date)
        ORDER BY year DESC, week_number DESC;
    END
    ELSE IF @group_by = 'monthly'
    BEGIN
        SELECT 
            YEAR(payment_date) as year,
            MONTH(payment_date) as month,
            DATENAME(MONTH, payment_date) as month_name,
            COUNT(*) as transaction_count,
            SUM(amount) as total_revenue
        FROM Payments
        WHERE status = 'Completed'
        AND (@start_date IS NULL OR payment_date >= @start_date)
        AND (@end_date IS NULL OR payment_date <= @end_date)
        GROUP BY YEAR(payment_date), MONTH(payment_date), DATENAME(MONTH, payment_date)
        ORDER BY year DESC, month DESC;
    END
END;
GO