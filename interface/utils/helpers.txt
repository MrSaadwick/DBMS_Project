import pandas as pd
from datetime import datetime

def format_currency(amount):
    """Format number as currency"""
    return f"Rs. {amount:,.2f}"

def validate_email(email):
    """Basic email validation"""
    return '@' in email and '.' in email

def get_today_checkins():
    """Get today's check-ins"""
    from database import db
    query = "SELECT COUNT(*) as count FROM Bookings WHERE check_in_date = CAST(GETDATE() AS DATE)"
    return db.execute_query(query)['count'][0]