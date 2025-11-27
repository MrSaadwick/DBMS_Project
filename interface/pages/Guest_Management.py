import streamlit as st
from database import db

st.set_page_config(page_title="Guest Management", layout="wide")
st.title("👥 Guest Management")

# Add new guest form
with st.form("add_guest"):
    st.subheader("Add New Guest")
    col1, col2 = st.columns(2)
    
    with col1:
        first_name = st.text_input("First Name *")
        last_name = st.text_input("Last Name *")
        email = st.text_input("Email *")
    
    with col2:
        phone = st.text_input("Phone")
        id_card = st.text_input("ID Card Number")
    
    if st.form_submit_button("💾 Add Guest"):
        if first_name and last_name and email:
            query = """INSERT INTO Guests (first_name, last_name, email, phone, id_card_number) 
                       VALUES (?, ?, ?, ?, ?)"""
            result = db.execute_non_query(query, (first_name, last_name, email, phone, id_card))
            if result > 0:
                st.success("✅ Guest added successfully!")
            else:
                st.error("❌ Failed to add guest")
        else:
            st.error("Please fill required fields (*)")

# Guest list
st.subheader("Guest List")
guests = db.execute_query("SELECT * FROM Guests ORDER BY first_name")
st.dataframe(guests, use_container_width=True)