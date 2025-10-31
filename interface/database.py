import pyodbc
import pandas as pd
from typing import List, Dict, Any

class DatabaseHelper:
    def __init__(self):
        self.connection_string = self.find_working_connection()
    
    def find_working_connection(self):
        """Try multiple connection strings to find one that works"""
        
        connection_attempts = [
            # Different server names
            r"Driver={SQL Server};Server=localhost\SQLEXPRESS;Database=HotelBookingSystem;Trusted_Connection=yes;",
            r"Driver={SQL Server};Server=.\SQLEXPRESS;Database=HotelBookingSystem;Trusted_Connection=yes;",
            r"Driver={SQL Server};Server=(local)\SQLEXPRESS;Database=HotelBookingSystem;Trusted_Connection=yes;",
            r"Driver={SQL Server};Server=127.0.0.1\SQLEXPRESS;Database=HotelBookingSystem;Trusted_Connection=yes;",
            
            # Different drivers
            r"Driver={SQL Server Native Client 11.0};Server=localhost\SQLEXPRESS;Database=HotelBookingSystem;Trusted_Connection=yes;",
            r"Driver={ODBC Driver 17 for SQL Server};Server=localhost\SQLEXPRESS;Database=HotelBookingSystem;Trusted_Connection=yes;",
            r"Driver={SQL Server Native Client 2012};Server=localhost\SQLEXPRESS;Database=HotelBookingSystem;Trusted_Connection=yes;",
        ]
        
        print("🔍 Searching for working database connection...")
        
        for i, conn_str in enumerate(connection_attempts, 1):
            print(f"Attempt {i}: {conn_str.split(';')[1]}...")
            try:
                conn = pyodbc.connect(conn_str)
                conn.close()
                print("✅ SUCCESS! Connection established.")
                return conn_str
            except pyodbc.Error as e:
                print(f"   ❌ Failed: {e}")
                continue
        
        # If all fail, try connecting to master database to check if SQL Server is running
        print("\n💡 Trying to connect to master database...")
        try:
            test_conn = pyodbc.connect(r"Driver={SQL Server};Server=localhost\SQLEXPRESS;Database=master;Trusted_Connection=yes;")
            test_conn.close()
            print("✅ Can connect to master database - HotelBookingSystem might not exist")
            return r"Driver={SQL Server};Server=localhost\SQLEXPRESS;Database=master;Trusted_Connection=yes;"
        except:
            print("❌ Cannot connect to any database")
        
        raise Exception("No working database connection found. Please check if SQL Server Express is installed and running.")
    
    def get_connection(self):
        try:
            conn = pyodbc.connect(self.connection_string)
            return conn
        except Exception as e:
            print(f"❌ Database connection error: {e}")
            return None
    
    def execute_query(self, query: str, params: tuple = None) -> pd.DataFrame:
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
            print(f"❌ Query execution error: {e}")
            conn.close()
            return pd.DataFrame()
    
    def execute_non_query(self, query: str, params: tuple = None) -> int:
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
            print(f"❌ Non-query execution error: {e}")
            conn.close()
            return 0

# Global database instance
db = DatabaseHelper()