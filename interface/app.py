import streamlit as st
import pandas as pd
import plotly.express as px
from database import db

# Page config
st.set_page_config(
    page_title="🏨 Luxury Hotel Booking",
    page_icon="🏨",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS
def load_css():
    st.markdown("""
    <style>
    .main-header {
        font-size: 3rem;
        color: #1f77b4;
        text-align: center;
        margin-bottom: 2rem;
    }
    .metric-card {
        background-color: #f0f2f6;
        padding: 1rem;
        border-radius: 10px;
        border-left: 4px solid #1f77b4;
    }
    </style>
    """, unsafe_allow_html=True)

def main_dashboard():
    load_css()
    st.markdown('<h1 class="main-header">🏨 Luxury Hotel Booking System</h1>', unsafe_allow_html=True)
    
    # Display metrics
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        guests = db.execute_query("SELECT COUNT(*) as count FROM Guests")['count'][0]
        st.metric("👥 Total Guests", guests)
    
    with col2:
        rooms = db.execute_query("SELECT COUNT(*) as count FROM Rooms WHERE status='Available'")['count'][0]
        st.metric("🏨 Available Rooms", rooms)
    
    with col3:
        bookings = db.execute_query("SELECT COUNT(*) as count FROM Bookings WHERE status='Confirmed'")['count'][0]
        st.metric("📅 Active Bookings", bookings)
    
    with col4:
        revenue = db.execute_query("SELECT ISNULL(SUM(amount),0) as revenue FROM Payments WHERE status='Completed'")['revenue'][0]
        st.metric("💰 Total Revenue", f"Rs. {revenue:,.2f}")
    
    # Charts section
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("📈 Revenue Trend")
        # Add revenue chart here
    
    with col2:
        st.subheader("🏨 Room Occupancy")
        # Add occupancy chart here

# Sidebar navigation
st.sidebar.title("🏨 Navigation")
page = st.sidebar.radio("Go to", [
      "Dashboard", 
    "Guest Management", 
    "Room Management", 
    "Booking Management",
    "Payment Management", 
    "Services Management",
    "Cancellation Management",
    "Booking Plans"
])

# Page routing
if page == "Dashboard":
    main_dashboard()
elif page == "Guest Management":
    st.switch_page("pages/Guest_Management.py")
elif page == "Room Management":
    st.switch_page("pages/Room_Management.py")
elif page == "Booking Management":
    st.switch_page("pages/Booking_Management.py")
if page == "Payment Management":
    st.switch_page("pages/Payment_Management.py")
elif page == "Services Management":
    st.switch_page("pages/Services_Management.py")
elif page == "Cancellation Management":
    st.switch_page("pages/Cancellation_Management.py")
elif page == "Booking Plans":
    st.switch_page("pages/Booking_Plans.py")