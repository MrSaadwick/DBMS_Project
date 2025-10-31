import streamlit as st
import pandas as pd
from datetime import datetime, timedelta
from database import db

st.set_page_config(page_title="Booking Management", layout="wide")
st.title("📅 Booking Management")

# Initialize session state for booking calculation
if 'booking_calculation' not in st.session_state:
    st.session_state.booking_calculation = {
        'room_price': 0,
        'services_total': 0,
        'discount_amount': 0,
        'subtotal': 0,
        'tax_amount': 0,
        'grand_total': 0
    }

def calculate_booking_total(room_price, services_total, discount_percent=0, discount_amount=0, stay_duration=1):
    """Calculate real-time booking total with all components"""
    room_total = room_price * stay_duration
    subtotal = room_total + services_total
    
    # Apply discount (percentage takes priority over fixed amount)
    if discount_percent > 0:
        discount_amount = (subtotal * discount_percent) / 100
    
    discounted_total = max(0, subtotal - discount_amount)
    
    # Calculate tax (13% as example)
    tax_rate = 0.13
    tax_amount = discounted_total * tax_rate
    grand_total = discounted_total + tax_amount
    
    return {
        'room_total': room_total,
        'services_total': services_total,
        'discount_amount': discount_amount,
        'subtotal': subtotal,
        'tax_amount': tax_amount,
        'grand_total': grand_total
    }

def get_available_services():
    """Get all available services"""
    return db.execute_query("SELECT service_id, service_name, price FROM Services WHERE is_available = 1")

def get_discount_options():
    """Get available discount options"""
    return {
        "None": 0,
        "Early Bird (10%)": 10,
        "Long Stay (15%)": 15,
        "Corporate (20%)": 20,
        "Weekend Special (5%)": 5,
        "Senior Citizen (25%)": 25,
        "Custom Discount": "custom"
    }

# Debug function to test database connection
def test_database_connection():
    """Test if database operations work"""
    try:
        # Test basic query
        test_result = db.execute_query("SELECT 1 as test")
        if not test_result.empty:
            st.sidebar.success("✅ Database connected")
            return True
        else:
            st.sidebar.error("❌ Database query failed")
            return False
    except Exception as e:
        st.sidebar.error(f"❌ Database error: {e}")
        return False

# Test connection at startup
test_database_connection()

# Create New Booking with Real-time Pricing
st.subheader("➕ Create New Booking")

with st.form("new_booking"):
    col1, col2 = st.columns(2)
    
    with col1:
        # Guest Selection
        guests = db.execute_query("SELECT guest_id, first_name + ' ' + last_name as name FROM Guests ORDER BY first_name")
        
        if guests.empty:
            st.error("❌ No guests found in database. Please add guests first.")
            guest_options = {"No guests available": 0}
        else:
            guest_options = {row['name']: row['guest_id'] for _, row in guests.iterrows()}
        
        selected_guest = st.selectbox("Select Guest *", options=list(guest_options.keys()))
        
        # Date Selection
        today = datetime.now().date()
        check_in = st.date_input("Check-in Date *", min_value=today)
        check_out = st.date_input("Check-out Date *", min_value=check_in + timedelta(days=1) if check_in else today + timedelta(days=1))
        
        # Calculate stay duration
        stay_duration = (check_out - check_in).days if check_out and check_in else 0
        
        # Room Selection with Real-time Pricing
        st.subheader("🏨 Room Selection")
        available_rooms = db.execute_query("""
            SELECT 
                r.room_id, r.room_number, rt.type_name, rt.base_price,
                r.has_sea_view, r.has_balcony, rt.capacity
            FROM Rooms r
            JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
            WHERE r.status = 'Available'
            ORDER BY rt.base_price
        """)
        
        selected_room_price = 0
        selected_room_id = None
        selected_room_key = ""
        
        if not available_rooms.empty:
            room_options = {}
            for _, room in available_rooms.iterrows():
                amenities = []
                if room['has_sea_view']: amenities.append("🌊 Sea View")
                if room['has_balcony']: amenities.append("🌿 Balcony")
                amenities_str = " + " + " + ".join(amenities) if amenities else ""
                
                key = f"Room {room['room_number']} - {room['type_name']} (Rs. {room['base_price']:,.0f}/night{amenities_str}) - Capacity: {room['capacity']}"
                room_options[key] = {
                    'room_id': room['room_id'],
                    'price': room['base_price']
                }
            
            selected_room_key = st.selectbox("Select Room *", options=list(room_options.keys()))
            selected_room_id = room_options[selected_room_key]['room_id']
            selected_room_price = room_options[selected_room_key]['price']
            
        else:
            st.error("❌ No available rooms found!")
    
    with col2:
        # Guest Details
        adults = st.number_input("Adults *", min_value=1, max_value=10, value=2, key="adults")
        children = st.number_input("Children", min_value=0, max_value=10, value=0, key="children")
        
        # Services Selection
        st.subheader("🛎️ Additional Services")
        available_services = get_available_services()
        
        selected_services = {}
        if not available_services.empty:
            for _, service in available_services.iterrows():
                quantity = st.number_input(
                    f"{service['service_name']} - Rs. {service['price']:,.0f}",
                    min_value=0,
                    max_value=10,
                    value=0,
                    key=f"service_{service['service_id']}"
                )
                if quantity > 0:
                    selected_services[service['service_id']] = {
                        'name': service['service_name'],
                        'price': service['price'],
                        'quantity': quantity,
                        'total': service['price'] * quantity
                    }
        else:
            st.info("No additional services available")
        
        # Discounts and Special Offers
        st.subheader("🎁 Discounts & Offers")
        
        discount_options = get_discount_options()
        selected_discount = st.selectbox("Select Discount", options=list(discount_options.keys()))
        
        discount_percent = 0
        discount_amount = 0
        
        if selected_discount == "Custom Discount":
            col_disc1, col_disc2 = st.columns(2)
            with col_disc1:
                discount_percent = st.number_input("Discount Percentage", min_value=0.0, max_value=100.0, value=0.0)
            with col_disc2:
                discount_amount = st.number_input("Or Fixed Amount", min_value=0.0, value=0.0)
        else:
            discount_percent = discount_options[selected_discount]
        
        # Special requests
        special_requests = st.text_area("Special Requests", placeholder="Any special requirements...")
    
    # Real-time Pricing Display
    st.subheader("💰 Real-time Pricing Breakdown")
    
    if selected_room_price > 0 and stay_duration > 0:
        # Calculate services total
        services_total = sum(service['total'] for service in selected_services.values())
        
        # Calculate all totals
        calculation = calculate_booking_total(
            selected_room_price, 
            services_total, 
            discount_percent, 
            discount_amount,
            stay_duration
        )
        
        # Update session state
        st.session_state.booking_calculation = calculation
        
        # Display pricing breakdown
        col1, col2, col3, col4 = st.columns(4)
        
        with col1:
            st.metric("Room Total", f"Rs. {calculation['room_total']:,.2f}")
            st.caption(f"Rs. {selected_room_price:,.0f} × {stay_duration} nights")
        
        with col2:
            st.metric("Services", f"Rs. {calculation['services_total']:,.2f}")
            if services_total > 0:
                service_names = [f"{s['name']} (×{s['quantity']})" for s in selected_services.values()]
                st.caption(" + ".join(service_names))
        
        with col3:
            st.metric("Discount", f"-Rs. {calculation['discount_amount']:,.2f}")
            if discount_percent > 0:
                st.caption(f"{discount_percent}% off")
        
        with col4:
            st.metric("Grand Total", f"Rs. {calculation['grand_total']:,.2f}")
            st.caption(f"Incl. Rs. {calculation['tax_amount']:,.2f} tax")
        
        # Detailed breakdown
        with st.expander("📊 Detailed Breakdown"):
            breakdown_data = {
                'Item': [
                    f'Room ({stay_duration} nights)',
                    'Additional Services',
                    'Subtotal',
                    f'Discount ({discount_percent}%)' if discount_percent > 0 else 'Discount',
                    'Taxable Amount',
                    'Tax (13%)',
                    '**Grand Total**'
                ],
                'Amount': [
                    f"Rs. {calculation['room_total']:,.2f}",
                    f"Rs. {calculation['services_total']:,.2f}",
                    f"Rs. {calculation['subtotal']:,.2f}",
                    f"-Rs. {calculation['discount_amount']:,.2f}",
                    f"Rs. {calculation['subtotal'] - calculation['discount_amount']:,.2f}",
                    f"Rs. {calculation['tax_amount']:,.2f}",
                    f"**Rs. {calculation['grand_total']:,.2f}**"
                ]
            }
            
            breakdown_df = pd.DataFrame(breakdown_data)
            st.table(breakdown_df)
    else:
        st.info("💡 Select a room and valid dates to see pricing")
    
    # Submit Booking
    submit_button = st.form_submit_button("💳 Create Booking")
    
    if submit_button:
        st.write("🔍 Debug Info:")
        st.write(f"- Guest Selected: {selected_guest != 'No guests available'}")
        st.write(f"- Room Selected: {selected_room_price > 0}")
        st.write(f"- Stay Duration: {stay_duration} days")
        st.write(f"- Guest ID: {guest_options.get(selected_guest, 'Invalid')}")
        
        if (selected_guest != 'No guests available' and selected_room_price > 0 
            and stay_duration > 0 and guest_options[selected_guest] != 0):
            
            try:
                # Get the final calculation
                final_calculation = st.session_state.booking_calculation
                
                # Debug: Show the query parameters
                st.write("📝 Booking Parameters:")
                st.write(f"- Guest ID: {guest_options[selected_guest]}")
                st.write(f"- Room ID: {selected_room_id}")
                st.write(f"- Dates: {check_in} to {check_out}")
                st.write(f"- Total Amount: {final_calculation['grand_total']}")
                
                # Create booking - SIMPLIFIED QUERY FIRST
                booking_query = """
                INSERT INTO Bookings (
                    guest_id, room_id, staff_id, check_in_date, check_out_date,
                    total_amount, adults_count, children_count, special_requests
                ) VALUES (?, ?, 1, ?, ?, ?, ?, ?, ?)
                """
                
                booking_params = (
                    guest_options[selected_guest],
                    selected_room_id,
                    check_in.strftime('%Y-%m-%d'),
                    check_out.strftime('%Y-%m-%d'),
                    float(final_calculation['grand_total']),
                    int(adults),
                    int(children),
                    str(special_requests) if special_requests else ""
                )
                
                st.write("🚀 Executing booking query...")
                booking_result = db.execute_non_query(booking_query, booking_params)
                
                if booking_result > 0:
                    st.success("✅ Booking created successfully!")
                    
                    # Get the new booking ID
                    new_booking_result = db.execute_query("SELECT IDENT_CURRENT('Bookings') as new_id")
                    if not new_booking_result.empty:
                        new_booking_id = new_booking_result['new_id'][0]
                        st.success(f"📋 Booking ID: #{new_booking_id}")
                        
                        # Add selected services if any
                        if selected_services:
                            for service_id, service_details in selected_services.items():
                                service_query = """
                                INSERT INTO BookingServices (booking_id, service_id, quantity, total_price)
                                VALUES (?, ?, ?, ?)
                                """
                                db.execute_non_query(service_query, (
                                    new_booking_id, service_id, 
                                    service_details['quantity'], service_details['total']
                                ))
                            st.success(f"✅ Added {len(selected_services)} services to booking")
                        
                        # Update room status
                        room_update_result = db.execute_non_query(
                            "UPDATE Rooms SET status = 'Occupied' WHERE room_id = ?",
                            (selected_room_id,)
                        )
                        
                        if room_update_result > 0:
                            st.success("✅ Room status updated to Occupied")
                        else:
                            st.warning("⚠️ Room status update failed")
                        
                        st.balloons()
                        
                    else:
                        st.success("✅ Booking created! (Could not retrieve booking ID)")
                
                else:
                    st.error("❌ Failed to create booking - No rows affected")
                    
            except Exception as e:
                st.error(f"❌ Error creating booking: {str(e)}")
                st.info("💡 Check if all required database tables and columns exist")
        else:
            st.error("❌ Please fill all required fields (*) and ensure valid selections")

# Current Bookings Section
st.subheader("📋 Current Bookings")

# Simple bookings display without filters for now
bookings = db.execute_query("""
    SELECT 
        b.booking_id,
        g.first_name + ' ' + g.last_name as guest_name,
        r.room_number,
        rt.type_name,
        b.check_in_date,
        b.check_out_date,
        b.total_amount,
        b.status
    FROM Bookings b
    JOIN Guests g ON b.guest_id = g.guest_id
    JOIN Rooms r ON b.room_id = r.room_id
    JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
    ORDER BY b.booking_date DESC
    LIMIT 10
""")

if not bookings.empty:
    st.dataframe(bookings, use_container_width=True)
else:
    st.info("No bookings found in the system")

# Database Schema Check (for debugging)
with st.expander("🔧 Database Schema Check"):
    if st.button("Check Booking Table Structure"):
        try:
            table_info = db.execute_query("""
                SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
                FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'Bookings'
            """)
            if not table_info.empty:
                st.write("Bookings Table Structure:")
                st.dataframe(table_info)
            else:
                st.error("Bookings table not found or no columns")
        except Exception as e:
            st.error(f"Error checking schema: {e}")