import streamlit as st
from database import db
from datetime import datetime, timedelta

st.set_page_config(page_title="Cancellation Management", layout="wide")
st.title("❌ Cancellation Management")

# Cancellation Statistics
col1, col2, col3 = st.columns(3)

with col1:
    total_cancellations = db.execute_query("SELECT COUNT(*) as count FROM Bookings WHERE status='Cancelled'")['count'][0]
    st.metric("Total Cancellations", total_cancellations)

with col2:
    pending_refunds = db.execute_query("SELECT COUNT(*) as count FROM Payments WHERE status='Refunded'")['count'][0]
    st.metric("Refunds Processed", pending_refunds)

with col3:
    cancellation_rate = db.execute_query("""
        SELECT 
            CAST(COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) as rate
        FROM Bookings
    """)['rate'][0]
    st.metric("Cancellation Rate", f"{cancellation_rate}%")

# Cancel Booking
st.subheader("🚫 Cancel Booking")

with st.form("cancel_booking"):
    # Get cancellable bookings (not already cancelled or checked-out)
    cancellable_bookings = db.execute_query("""
        SELECT 
            b.booking_id,
            g.first_name + ' ' + g.last_name as guest_name,
            r.room_number,
            b.check_in_date,
            b.total_amount,
            b.status,
            CASE 
                WHEN b.check_in_date > GETDATE() THEN 'Before Check-in'
                ELSE 'After Check-in'
            END as cancellation_type
        FROM Bookings b
        JOIN Guests g ON b.guest_id = g.guest_id
        JOIN Rooms r ON b.room_id = r.room_id
        WHERE b.status NOT IN ('Cancelled', 'Checked-Out')
        ORDER BY b.check_in_date
    """)
    
    if not cancellable_bookings.empty:
        booking_options = {}
        for _, booking in cancellable_bookings.iterrows():
            key = f"Booking #{booking['booking_id']} - {booking['guest_name']} (Room {booking['room_number']}) - {booking['check_in_date']}"
            booking_options[key] = booking['booking_id']
        
        selected_booking = st.selectbox("Select Booking to Cancel", options=list(booking_options.keys()))
        
        cancellation_reason = st.selectbox("Cancellation Reason", [
            "Guest Request",
            "No Show", 
            "Double Booking",
            "Hotel Operational Issues",
            "Weather Conditions",
            "Other"
        ])
        
        detailed_reason = st.text_area("Detailed Reason")
        
        # Calculate refund based on cancellation policy
        selected_booking_id = booking_options[selected_booking]
        booking_details = cancellable_bookings[cancellable_bookings['booking_id'] == selected_booking_id].iloc[0]
        
        st.info("📋 Cancellation Policy:")
        if booking_details['cancellation_type'] == 'Before Check-in':
            st.write("• 48+ hours before check-in: 90% refund")
            st.write("• 24-48 hours before check-in: 50% refund") 
            st.write("• Less than 24 hours: No refund")
            refund_percentage = st.slider("Refund Percentage", 0, 100, 90)
        else:
            st.write("• After check-in: No refund for used nights")
            st.write("• Future nights: 50% refund")
            refund_percentage = st.slider("Refund Percentage", 0, 100, 50)
        
        refund_amount = (booking_details['total_amount'] * refund_percentage) / 100
        
        col1, col2 = st.columns(2)
        with col1:
            st.metric("Original Amount", f"Rs. {booking_details['total_amount']:,.2f}")
        with col2:
            st.metric("Refund Amount", f"Rs. {refund_amount:,.2f}")
        
        if st.form_submit_button("❌ Confirm Cancellation"):
            # Start transaction
            try:
                # 1. Update booking status
                db.execute_non_query(
                    "UPDATE Bookings SET status = 'Cancelled' WHERE booking_id = ?",
                    (selected_booking_id,)
                )
                
                # 2. Process refund if applicable
                if refund_amount > 0:
                    db.execute_non_query("""
                        INSERT INTO Payments (booking_id, amount, payment_method, status, notes)
                        VALUES (?, ?, 'Refund', 'Refunded', ?)
                    """, (selected_booking_id, -refund_amount, f"Cancellation refund: {cancellation_reason}"))
                
                # 3. Free up the room
                db.execute_non_query("""
                    UPDATE Rooms SET status = 'Available' 
                    WHERE room_id = (SELECT room_id FROM Bookings WHERE booking_id = ?)
                """, (selected_booking_id,))
                
                # 4. Log cancellation (you might want to create a Cancellations table)
                st.success(f"✅ Booking cancelled successfully! Refund: Rs. {refund_amount:,.2f}")
                
            except Exception as e:
                st.error(f"❌ Cancellation failed: {e}")
    else:
        st.info("No cancellable bookings found")

# Cancellation History
st.subheader("📋 Cancellation History")

cancellations = db.execute_query("""
    SELECT 
        b.booking_id,
        g.first_name + ' ' + g.last_name as guest_name,
        r.room_number,
        b.check_in_date,
        b.total_amount,
        b.booking_date,
        p.amount as refund_amount
    FROM Bookings b
    JOIN Guests g ON b.guest_id = g.guest_id
    JOIN Rooms r ON b.room_id = r.room_id
    LEFT JOIN Payments p ON b.booking_id = p.booking_id AND p.status = 'Refunded'
    WHERE b.status = 'Cancelled'
    ORDER BY b.booking_date DESC
""")

if not cancellations.empty:
    st.dataframe(cancellations, use_container_width=True)
else:
    st.info("No cancellation history")