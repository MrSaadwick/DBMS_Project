import streamlit as st
import pandas as pd
from database import db

st.set_page_config(page_title="Payment Management", layout="wide")
st.title("💰 Payment Management")

# Payment Statistics
col1, col2, col3, col4 = st.columns(4)

with col1:
    total_payments = db.execute_query("SELECT COUNT(*) as count FROM Payments")['count'][0]
    st.metric("Total Payments", total_payments)

with col2:
    completed_payments = db.execute_query("SELECT COUNT(*) as count FROM Payments WHERE status='Completed'")['count'][0]
    st.metric("Completed", completed_payments)

with col3:
    pending_payments = db.execute_query("SELECT COUNT(*) as count FROM Payments WHERE status='Pending'")['count'][0]
    st.metric("Pending", pending_payments)

with col4:
    total_revenue = db.execute_query("SELECT ISNULL(SUM(amount), 0) as revenue FROM Payments WHERE status='Completed'")['revenue'][0]
    st.metric("Total Revenue", f"Rs. {total_revenue:,.2f}")

# Process New Payment
st.subheader("💳 Process New Payment")

with st.form("process_payment"):
    col1, col2 = st.columns(2)
    
    with col1:
        # Get bookings that need payment
        unpaid_bookings = db.execute_query("""
            SELECT b.booking_id, g.first_name + ' ' + g.last_name as guest_name, 
                   b.total_amount, r.room_number
            FROM Bookings b
            JOIN Guests g ON b.guest_id = g.guest_id
            JOIN Rooms r ON b.room_id = r.room_id
            WHERE b.booking_id NOT IN (SELECT booking_id FROM Payments WHERE status = 'Completed')
            AND b.status IN ('Confirmed', 'Checked-In')
        """)
        
        booking_options = {f"Booking #{row['booking_id']} - {row['guest_name']} (Room {row['room_number']})": row['booking_id'] 
                          for _, row in unpaid_bookings.iterrows()}
        selected_booking = st.selectbox("Select Booking", options=list(booking_options.keys()))
        
        amount = st.number_input("Amount", min_value=0.0, step=1000.0)
    
    with col2:
        payment_method = st.selectbox("Payment Method", ["Credit Card", "Debit Card", "Cash", "Online Transfer", "Bank Deposit"])
        transaction_id = st.text_input("Transaction ID (Optional)")
        notes = st.text_area("Notes")
    
    if st.form_submit_button("💳 Process Payment"):
        if selected_booking and amount > 0:
            booking_id = booking_options[selected_booking]
            
            query = """
            INSERT INTO Payments (booking_id, amount, payment_method, transaction_id, status, notes)
            VALUES (?, ?, ?, ?, 'Completed', ?)
            """
            
            result = db.execute_non_query(query, (booking_id, amount, payment_method, transaction_id, notes))
            
            if result > 0:
                st.success("✅ Payment processed successfully!")
                
                # Update booking status if fully paid
                booking_total = db.execute_query(f"SELECT total_amount FROM Bookings WHERE booking_id = {booking_id}")['total_amount'][0]
                paid_amount = db.execute_query(f"SELECT ISNULL(SUM(amount), 0) as paid FROM Payments WHERE booking_id = {booking_id} AND status = 'Completed'")['paid'][0]
                
                if paid_amount >= booking_total:
                    db.execute_non_query(f"UPDATE Bookings SET status = 'Confirmed' WHERE booking_id = {booking_id}")
                    st.info("💰 Booking fully paid and confirmed!")
            else:
                st.error("❌ Failed to process payment")
        else:
            st.error("Please select a booking and enter amount")

# Payment History
st.subheader("📋 Payment History")

payments = db.execute_query("""
    SELECT 
        p.payment_id,
        b.booking_id,
        g.first_name + ' ' + g.last_name as guest_name,
        p.amount,
        p.payment_method,
        p.payment_date,
        p.status,
        p.transaction_id
    FROM Payments p
    JOIN Bookings b ON p.booking_id = b.booking_id
    JOIN Guests g ON b.guest_id = g.guest_id
    ORDER BY p.payment_date DESC
""")

if not payments.empty:
    st.dataframe(payments, use_container_width=True)
    
    # Export option
    if st.button("📊 Export Payment Report"):
        csv = payments.to_csv(index=False)
        st.download_button(
            label="Download CSV",
            data=csv,
            file_name="payment_report.csv",
            mime="text/csv"
        )
else:
    st.info("No payment records found")