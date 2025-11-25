use HotelBookingSystem;
Go

select g.first_name,g.guest_id,c.refund_amount from Guests g
join Bookings b on g.guest_id=b.guest_id 
inner join
Cancellations c on b.booking_id=c.booking_id
where refund_status='Not Applicable';
select * from Rooms;
select * from Bookings;