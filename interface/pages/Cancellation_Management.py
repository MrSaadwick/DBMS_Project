import streamlit as st
from database import db
from datetime import datetime, timedelta

st.set_page_config(page_title="Cancellation Management", layout="wide")
st.title("❌ Cancellation Management")

# Cancellation Statistics
col1, col2, col3, col4 = st.columns(4)

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

with col4:
    total_refund_amount = db.execute_query("""
        SELECT ISNULL(SUM(ABS(amount)), 0) as total_refunds 
        FROM Payments 
        WHERE status = 'Refunded'
    """)['total_refunds'][0]
    st.metric("Total Refunds", f"Rs. {total_refund_amount:,.2f}")

# Cancel Booking
st.subheader("🚫 Cancel Booking")

with st.form("cancel_booking"):
    # Get cancellable bookings (not already cancelled or checked-out AND check-in date is in future)
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
          AND b.check_in_date > GETDATE()  -- Only allow cancellation if check-in date is in future
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
        
        detailed_reason = st.text_area("Detailed Reason (Required)", placeholder="Provide detailed reason for cancellation...")
        
        # Calculate refund based on cancellation policy
        selected_booking_id = booking_options[selected_booking]
        booking_details = cancellable_bookings[cancellable_bookings['booking_id'] == selected_booking_id].iloc[0]
        
        st.info("📋 Cancellation Policy:")
        if booking_details['cancellation_type'] == 'Before Check-in':
            st.write("• 48+ hours before check-in: 90% refund")
            st.write("• 24-48 hours before check-in: 50% refund") 
            st.write("• Less than 24 hours: No refund")
            
            # Calculate hours until check-in
            check_in_date = booking_details['check_in_date']
            
            # Handle different date formats safely
            if isinstance(check_in_date, str):
                try:
                    # Try different date formats
                    if ' ' in check_in_date:
                        check_in_date = datetime.strptime(check_in_date, '%Y-%m-%d %H:%M:%S')
                    else:
                        check_in_date = datetime.strptime(check_in_date, '%Y-%m-%d')
                except ValueError:
                    # If parsing fails, use the current date (this will show no refund)
                    st.error("⚠️ Could not parse check-in date")
                    check_in_date = datetime.now()
            elif hasattr(check_in_date, 'to_pydatetime'):
                # Handle pandas Timestamp
                check_in_date = check_in_date.to_pydatetime()
            
            hours_until_checkin = (check_in_date - datetime.now()).total_seconds() / 3600
            
            if hours_until_checkin >= 48:
                default_refund = 90
                st.success(f"✅ {hours_until_checkin:.1f} hours until check-in - 90% refund applicable")
            elif hours_until_checkin >= 24:
                default_refund = 50
                st.warning(f"⚠️ {hours_until_checkin:.1f} hours until check-in - 50% refund applicable")
            else:
                default_refund = 0
                st.error(f"❌ {hours_until_checkin:.1f} hours until check-in - No refund applicable")
            
            refund_percentage = st.slider("Refund Percentage", 0, 100, default_refund)
        else:
            # This case should not occur due to our query filter, but keeping for safety
            st.error("❌ Cannot cancel booking - check-in date has already passed!")
            refund_percentage = 0
        
        refund_amount = (booking_details['total_amount'] * refund_percentage) / 100
        
        col1, col2 = st.columns(2)
        with col1:
            st.metric("Original Amount", f"Rs. {booking_details['total_amount']:,.2f}")
        with col2:
            st.metric("Refund Amount", f"Rs. {refund_amount:,.2f}")
        
        # SUBMIT BUTTON
        submitted = st.form_submit_button("❌ Confirm Cancellation")
        
    else:
        st.info("No cancellable bookings found")
        st.warning("⚠️ Note: Bookings cannot be cancelled after their check-in date has passed")
        submitted = False

    # Handle form submission - FIXED VERSION
    if submitted:
        if not cancellable_bookings.empty:
            if not detailed_reason.strip():
                st.error("❌ Please provide a detailed reason for cancellation")
            else:
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
                        """, (selected_booking_id, -refund_amount, f"Cancellation refund: {cancellation_reason} - {detailed_reason}"))
                    
                    # 3. Free up the room
                    db.execute_non_query("""
                        UPDATE Rooms SET status = 'Available' 
                        WHERE room_id = (SELECT room_id FROM Bookings WHERE booking_id = ?)
                    """, (selected_booking_id,))
                    
                    # 4. Log cancellation in Cancellations table - UPDATED WITH CORRECT COLUMNS
                    db.execute_non_query("""
                        INSERT INTO Cancellations 
                        (booking_id, cancellation_reason, detailed_reason, refund_amount, refund_percentage, original_booking_amount) 
                        VALUES (?, ?, ?, ?, ?, ?)
                    """, (selected_booking_id, cancellation_reason, detailed_reason, refund_amount, refund_percentage, booking_details['total_amount']))
                    
                    st.success(f"✅ Booking cancelled successfully! Refund: Rs. {refund_amount:,.2f}")
                    st.balloons()
                    
                    # Force immediate refresh
                    st.rerun()
                    
                except Exception as e:
                    st.error(f"❌ Cancellation failed: {str(e)}")
        else:
            st.error("❌ No booking selected for cancellation")

# Enhanced Cancellation History with Cancellations table data
st.subheader("📋 Detailed Cancellation History")

# Check if Cancellations table exists and get data
try:
    cancellations = db.execute_query("""
        SELECT 
            c.cancellation_id,
            b.booking_id,
            g.first_name + ' ' + g.last_name as guest_name,
            r.room_number,
            b.check_in_date,
            c.original_booking_amount,
            c.refund_amount,
            c.refund_percentage,
            c.cancellation_reason,
            c.detailed_reason,
            c.cancellation_date,
            b.booking_date
        FROM Cancellations c
        JOIN Bookings b ON c.booking_id = b.booking_id
        JOIN Guests g ON b.guest_id = g.guest_id
        JOIN Rooms r ON b.room_id = r.room_id
        ORDER BY c.cancellation_date DESC
    """)
    
    if not cancellations.empty:
        # Display summary metrics
        col1, col2, col3 = st.columns(3)
        with col1:
            total_refunds = cancellations['refund_amount'].sum()
            st.metric("Total Refunds in History", f"Rs. {total_refunds:,.2f}")
        with col2:
            avg_refund_percentage = cancellations['refund_percentage'].mean()
            st.metric("Average Refund Percentage", f"{avg_refund_percentage:.1f}%")
        with col3:
            total_cancellations_count = len(cancellations)
            st.metric("Total Cancellations", total_cancellations_count)
        
        # Display the dataframe
        st.dataframe(cancellations, use_container_width=True)
        
        # Show recent cancellations
        st.subheader("🕒 Recent Cancellations")
        recent_cancellations = cancellations.head(5)  # Show last 5 cancellations
        for _, cancel in recent_cancellations.iterrows():
            with st.expander(f"📋 Cancellation #{cancel['cancellation_id']} - {cancel['guest_name']} - {cancel['cancellation_date']}"):
                col1, col2 = st.columns(2)
                with col1:
                    st.write(f"**Booking ID:** {cancel['booking_id']}")
                    st.write(f"**Guest:** {cancel['guest_name']}")
                    st.write(f"**Room:** {cancel['room_number']}")
                    st.write(f"**Original Amount:** Rs. {cancel['original_booking_amount']:,.2f}")
                with col2:
                    st.write(f"**Refund Amount:** Rs. {cancel['refund_amount']:,.2f}")
                    st.write(f"**Refund Percentage:** {cancel['refund_percentage']}%")
                    st.write(f"**Reason:** {cancel['cancellation_reason']}")
                    st.write(f"**Cancelled on:** {cancel['cancellation_date']}")
                st.write(f"**Detailed Reason:** {cancel['detailed_reason']}")
        
        # Download option
        csv = cancellations.to_csv(index=False)
        st.download_button(
            label="📥 Download Cancellation Report",
            data=csv,
            file_name=f"cancellation_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
            mime="text/csv"
        )
    else:
        st.info("No cancellation history found in the Cancellations table")
        st.info("Cancellations will appear here after you cancel bookings using the form above.")

except Exception as e:
    st.error(f"❌ Error loading cancellation history: {str(e)}")
    st.info("Please make sure the Cancellations table exists in your database.")

# Quick cancellation analytics
st.subheader("📊 Cancellation Analytics")

try:
    analytics_col1, analytics_col2 = st.columns(2)

    with analytics_col1:
        cancellation_by_reason = db.execute_query("""
            SELECT 
                cancellation_reason,
                COUNT(*) as count,
                AVG(refund_percentage) as avg_refund_percentage,
                SUM(refund_amount) as total_refunds
            FROM Cancellations
            GROUP BY cancellation_reason
            ORDER BY count DESC
        """)
        
        if not cancellation_by_reason.empty:
            st.write("**Cancellations by Reason:**")
            st.dataframe(cancellation_by_reason, use_container_width=True)
        else:
            st.info("No cancellation analytics data available")

    with analytics_col2:
        monthly_cancellations = db.execute_query("""
            SELECT 
                FORMAT(cancellation_date, 'yyyy-MM') as month,
                COUNT(*) as cancellation_count,
                SUM(refund_amount) as total_refunds,
                AVG(refund_percentage) as avg_refund_rate
            FROM Cancellations
            GROUP BY FORMAT(cancellation_date, 'yyyy-MM')
            ORDER BY month DESC
        """)
        
        if not monthly_cancellations.empty:
            st.write("**Monthly Cancellation Trends:**")
            st.dataframe(monthly_cancellations, use_container_width=True)
        else:
            st.info("No monthly cancellation trends available")

except Exception as e:
    st.info("Cancellation analytics will be available after cancellations are recorded.")

# Refresh button to see latest data
if st.button("🔄 Refresh Data"):
    st.rerun()

st.markdown("---")
st.info("💡 **Tip:** Cancellations are automatically saved to the database and will appear in the history section above.")