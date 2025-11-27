import streamlit as st
from database import db

st.set_page_config(page_title="Services Management", layout="wide")
st.title("🛎️ Services Management")

# Service Statistics
col1, col2, col3 = st.columns(3)

with col1:
    total_services = db.execute_query("SELECT COUNT(*) as count FROM Services")['count'][0]
    st.metric("Total Services", total_services)

with col2:
    active_services = db.execute_query("SELECT COUNT(*) as count FROM Services WHERE is_available=1")['count'][0]
    st.metric("Active Services", active_services)

with col3:
    total_service_revenue = db.execute_query("SELECT ISNULL(SUM(total_price), 0) as revenue FROM BookingServices")['revenue'][0]
    st.metric("Service Revenue", f"Rs. {total_service_revenue:,.2f}")

# Add New Service
st.subheader("➕ Add New Service")

with st.form("add_service"):
    col1, col2 = st.columns(2)
    
    with col1:
        service_name = st.text_input("Service Name *")
        category = st.selectbox("Category", ["Food & Beverage", "Spa & Wellness", "Transport", "Recreation", "Business", "Other"])
        price = st.number_input("Price (Rs.) *", min_value=0.0, step=100.0)
    
    with col2:
        description = st.text_area("Description")
        is_available = st.checkbox("Available for Booking", value=True)
    
    if st.form_submit_button("💾 Add Service"):
        if service_name and price >= 0:
            query = """
            INSERT INTO Services (service_name, description, price, category, is_available)
            VALUES (?, ?, ?, ?, ?)
            """
            result = db.execute_non_query(query, (service_name, description, price, category, 1 if is_available else 0))
            
            if result > 0:
                st.success("✅ Service added successfully!")
            else:
                st.error("❌ Failed to add service")
        else:
            st.error("Please fill required fields")

# Manage Existing Services
st.subheader("📋 Manage Services")

services = db.execute_query("SELECT * FROM Services ORDER BY category, service_name")

if not services.empty:
    for _, service in services.iterrows():
        with st.expander(f"🛎️ {service['service_name']} - Rs. {service['price']:,.2f}"):
            col1, col2, col3 = st.columns([2, 1, 1])
            
            with col1:
                st.write(f"**Category:** {service['category']}")
                st.write(f"**Description:** {service['description']}")
                st.write(f"**Status:** {'✅ Available' if service['is_available'] else '❌ Unavailable'}")
            
            with col2:
                if st.button("Edit", key=f"edit_{service['service_id']}"):
                    st.session_state.editing_service = service['service_id']
            
            with col3:
                if st.button("Toggle Availability", key=f"toggle_{service['service_id']}"):
                    new_status = 0 if service['is_available'] else 1
                    db.execute_non_query(f"UPDATE Services SET is_available = {new_status} WHERE service_id = {service['service_id']}")
                    st.rerun()

# Book Service for Guest
st.subheader("🎯 Book Service for Guest")

with st.form("book_service"):
    col1, col2 = st.columns(2)
    
    with col1:
        # Get active bookings
        active_bookings = db.execute_query("""
            SELECT b.booking_id, g.first_name + ' ' + g.last_name as guest_name, r.room_number
            FROM Bookings b
            JOIN Guests g ON b.guest_id = g.guest_id
            JOIN Rooms r ON b.room_id = r.room_id
            WHERE b.status IN ('Confirmed', 'Checked-In')
        """)
        
        booking_options = {f"Booking #{row['booking_id']} - {row['guest_name']}": row['booking_id'] 
                          for _, row in active_bookings.iterrows()}
        selected_booking = st.selectbox("Select Booking", options=list(booking_options.keys()))
    
    with col2:
        # Get available services
        available_services = db.execute_query("SELECT service_id, service_name, price FROM Services WHERE is_available = 1")
        service_options = {f"{row['service_name']} - Rs. {row['price']:,.2f}": row['service_id'] 
                          for _, row in available_services.iterrows()}
        selected_service = st.selectbox("Select Service", options=list(service_options.keys()))
        
        quantity = st.number_input("Quantity", min_value=1, max_value=10, value=1)
    
    if st.form_submit_button("📝 Book Service"):
        if selected_booking and selected_service:
            booking_id = booking_options[selected_booking]
            service_id = service_options[selected_service]
            service_price = available_services[available_services['service_id'] == service_id]['price'].iloc[0]
            total_price = service_price * quantity
            
            query = """
            INSERT INTO BookingServices (booking_id, service_id, quantity, total_price)
            VALUES (?, ?, ?, ?)
            """
            
            result = db.execute_non_query(query, (booking_id, service_id, quantity, total_price))
            
            if result > 0:
                st.success(f"✅ Service booked successfully! Total: Rs. {total_price:,.2f}")
            else:
                st.error("❌ Failed to book service")