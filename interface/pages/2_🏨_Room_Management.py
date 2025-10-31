import streamlit as st
from database import db

st.set_page_config(page_title="Room Management", layout="wide")
st.title("🏨 Room Management")

# Room statistics
col1, col2, col3, col4 = st.columns(4)
with col1:
    total = db.execute_query("SELECT COUNT(*) as count FROM Rooms")['count'][0]
    st.metric("Total Rooms", total)
with col2:
    available = db.execute_query("SELECT COUNT(*) as count FROM Rooms WHERE status='Available'")['count'][0]
    st.metric("Available", available)
with col3:
    occupied = db.execute_query("SELECT COUNT(*) as count FROM Rooms WHERE status='Occupied'")['count'][0]
    st.metric("Occupied", occupied)
with col4:
    maintenance = db.execute_query("SELECT COUNT(*) as count FROM Rooms WHERE status='Maintenance'")['count'][0]
    st.metric("Maintenance", maintenance)

# Rooms table
st.subheader("All Rooms")
rooms = db.execute_query("""
    SELECT r.room_number, rt.type_name, r.status, r.floor_number 
    FROM Rooms r JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
    ORDER BY r.room_number
""")
st.dataframe(rooms, use_container_width=True)