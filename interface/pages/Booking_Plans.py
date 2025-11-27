import streamlit as st
import pandas as pd
from database import db

st.set_page_config(page_title="Booking Plans", layout="wide")
st.title("📋 Booking Plans & Packages")

# Special Packages
st.subheader("🎁 Special Packages")

packages = {
    "Honeymoon Package": {
        "description": "Perfect for newlyweds with romantic amenities",
        "includes": ["Champagne on arrival", "Couples spa treatment", "Romantic dinner", "Flower decoration"],
        "price": 25000,
        "min_nights": 3
    },
    "Family Package": {
        "description": "Great for families with children",
        "includes": ["Extra bed", "Children's activities", "Family dinner", "Late check-out"],
        "price": 18000,
        "min_nights": 2
    },
    "Business Package": {
        "description": "For corporate travelers",
        "includes": ["Work desk in room", "Business center access", "Airport transfer", "Breakfast buffet"],
        "price": 15000,
        "min_nights": 1
    },
    "Weekend Getaway": {
        "description": "Perfect short stay package",
        "includes": ["Friday to Sunday stay", "All meals included", "Recreational activities", "Pool access"],
        "price": 12000,
        "min_nights": 2
    }
}

col1, col2 = st.columns(2)

for i, (package_name, details) in enumerate(packages.items()):
    with (col1 if i % 2 == 0 else col2):
        with st.container():
            st.markdown(f"### {package_name}")
            st.write(details['description'])
            st.metric("Package Price", f"Rs. {details['price']:,.2f}")
            
            st.write("**Includes:**")
            for item in details['includes']:
                st.write(f"• {item}")
            
            if st.button(f"Select {package_name}", key=f"package_{i}"):
                st.session_state.selected_package = package_name
                st.success(f"✅ {package_name} selected! Apply this when creating a booking.")

# Seasonal Pricing
st.subheader("📅 Seasonal Pricing")

seasonal_rates = db.execute_query("""
    SELECT 
        rt.type_name,
        rt.base_price as standard_rate,
        CASE 
            WHEN DATEPART(MONTH, GETDATE()) IN (12, 1, 2) THEN rt.base_price * 1.2
            WHEN DATEPART(MONTH, GETDATE()) IN (6, 7, 8) THEN rt.base_price * 1.1
            ELSE rt.base_price
        END as current_rate
    FROM RoomTypes rt
""")

if not seasonal_rates.empty:
    st.dataframe(seasonal_rates, use_container_width=True)
    
    st.info("💡 **Seasonal Rates:** December-February: +20%, June-August: +10%")

# Long Stay Discounts
st.subheader("🏷️ Long Stay Discounts")

st.write("**Extended Stay Benefits:**")
col1, col2, col3 = st.columns(3)

with col1:
    st.metric("7+ Nights", "15% Discount")
    st.write("• Complimentary airport transfer")
    st.write("• Daily breakfast included")

with col2:
    st.metric("14+ Nights", "25% Discount") 
    st.write("• One free spa treatment")
    st.write("• Room upgrade subject to availability")

with col3:
    st.metric("30+ Nights", "35% Discount")
    st.write("• Executive lounge access")
    st.write("• Personal concierge service")

# Booking Forecast
st.subheader("📈 Booking Forecast")

# Get booking trends (you can enhance this with real forecasting)
forecast_data = db.execute_query("""
    SELECT 
        DATENAME(MONTH, booking_date) as month,
        COUNT(*) as bookings,
        AVG(total_amount) as avg_booking_value
    FROM Bookings 
    WHERE booking_date >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY DATENAME(MONTH, booking_date), MONTH(booking_date)
    ORDER BY MONTH(booking_date)
""")

if not forecast_data.empty:
    col1, col2 = st.columns(2)
    
    with col1:
        st.write("**Monthly Bookings**")
        st.dataframe(forecast_data[['month', 'bookings']], hide_index=True)
    
    with col2:
        st.write("**Average Booking Value**")
        st.dataframe(forecast_data[['month', 'avg_booking_value']], hide_index=True)

# Corporate Rates
st.subheader("💼 Corporate Rates")

with st.form("corporate_rates"):
    st.write("**Setup Corporate Account**")
    
    col1, col2 = st.columns(2)
    
    with col1:
        company_name = st.text_input("Company Name")
        contact_person = st.text_input("Contact Person")
        email = st.text_input("Email")
    
    with col2:
        phone = st.text_input("Phone")
        discount_rate = st.slider("Corporate Discount (%)", 5, 25, 15)
        contract_duration = st.selectbox("Contract Duration", ["3 Months", "6 Months", "1 Year", "2 Years"])
    
    if st.form_submit_button("💼 Create Corporate Account"):
        st.success(f"✅ Corporate account created for {company_name} with {discount_rate}% discount")