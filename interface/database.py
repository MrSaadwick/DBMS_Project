import pyodbc
import pandas as pd

class DatabaseHelper:
    def __init__(self):
        self.connection_string = (
            r"Driver={SQL Server};"
            r"Server=localhost\SQLEXPRESS;"
            r"Database=HotelBookingSystem;"
            r"Trusted_Connection=yes;"
        )
    
    def get_connection(self):
        try:
            return pyodbc.connect(self.connection_string)
        except Exception as e:
            print(f"Database connection error: {e}")
            return None
    
    def execute_query(self, query, params=None):
        conn = self.get_connection()
        if conn is None:
            return pd.DataFrame()
        
        try:
            if params:
                result = pd.read_sql_query(query, conn, params=params)
            else:
                result = pd.read_sql_query(query, conn)
            conn.close()
            return result
        except Exception as e:
            print(f"Query execution error: {e}")
            conn.close()
            return pd.DataFrame()
    
    def execute_non_query(self, query, params=None):
        conn = self.get_connection()
        if conn is None:
            return 0
        
        try:
            cursor = conn.cursor()
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            conn.commit()
            rows_affected = cursor.rowcount
            conn.close()
            return rows_affected
        except Exception as e:
            print(f"Non-query execution error: {e}")
            conn.close()
            return 0

db = DatabaseHelper()