import pyodbc
import pandas as pd
from typing import List, Dict, Any

class DatabaseHelper:
    def __init__(self):
        self.connection_string = (
            "Driver={SQL Server};"
            "Server=localhost;"
            "Database=HotelBookingSystem;"
            "Trusted_Connection=yes;"
        )
    
    def get_connection(self):
        try:
            return pyodbc.connect(self.connection_string)
        except Exception as e:
            print(f"Database connection error: {e}")
            return None
    
    def execute_query(self, query: str, params: tuple = None) -> pd.DataFrame:
        try:
            with self.get_connection() as conn:
                if params:
                    return pd.read_sql_query(query, conn, params=params)
                else:
                    return pd.read_sql_query(query, conn)
        except Exception as e:
            print(f"Query execution error: {e}")
            return pd.DataFrame()
    
    def execute_non_query(self, query: str, params: tuple = None) -> int:
        try:
            with self.get_connection() as conn:
                cursor = conn.cursor()
                if params:
                    cursor.execute(query, params)
                else:
                    cursor.execute(query)
                conn.commit()
                return cursor.rowcount
        except Exception as e:
            print(f"Non-query execution error: {e}")
            return 0

# Global database instance
db = DatabaseHelper()