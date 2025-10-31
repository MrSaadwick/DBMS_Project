import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from tkinter import messagebox
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from database import db

class MainForm(ttk.Window):
    def __init__(self):
        super().__init__(themename="darkly")
        self.title("🏨 Luxury Hotel Booking System")
        self.geometry("1200x800")
        self.minsize(1100, 700)
        
        self.create_modern_ui()
        self.load_dashboard_stats()
    
    def create_modern_ui(self):
        # Create main container
        main_container = ttk.Frame(self)
        main_container.pack(fill=BOTH, expand=True, padx=20, pady=20)
        
        # Header with gradient effect
        header_frame = ttk.Frame(main_container, bootstyle="primary")
        header_frame.pack(fill=X, pady=(0, 20))
        
        ttk.Label(
            header_frame, 
            text="🏨 LUXURY HOTEL BOOKING SYSTEM", 
            font=('Helvetica', 24, 'bold'),
            bootstyle="inverse-primary"
        ).pack(pady=20)
        
        # Stats Cards Frame
        stats_frame = ttk.Frame(main_container)
        stats_frame.pack(fill=X, pady=(0, 20))
        
        # Stats Cards
        cards_data = [
            ("👥 Total Guests", "primary", "guests"),
            ("🏨 Available Rooms", "success", "rooms"),
            ("📅 Today's Check-ins", "warning", "bookings"),
            ("💰 Total Revenue", "info", "revenue")
        ]
        
        self.stats_labels = {}
        for i, (text, style, key) in enumerate(cards_data):
            card = ttk.Frame(stats_frame, bootstyle=style)
            card.grid(row=0, column=i, padx=10, sticky="nsew")
            stats_frame.columnconfigure(i, weight=1)
            
            ttk.Label(
                card, 
                text=text, 
                font=('Helvetica', 12, 'bold'),
                bootstyle=f"inverse-{style}"
            ).pack(fill=X, padx=15, pady=10)
            
            value_label = ttk.Label(
                card, 
                text="0", 
                font=('Helvetica', 18, 'bold'),
                bootstyle=f"inverse-{style}"
            )
            value_label.pack(pady=(0, 15))
            self.stats_labels[key] = value_label
        
        # Quick Actions Frame
        actions_frame = ttk.LabelFrame(main_container, text="🚀 Quick Actions", bootstyle="info")
        actions_frame.pack(fill=X, pady=(0, 20))
        
        actions = [
            ("👥 Manage Guests", "primary", self.open_guests),
            ("🏨 Room Management", "success", self.open_rooms),
            ("📅 Bookings", "warning", self.open_bookings),
            ("💰 Payments", "info", self.open_payments),
            ("📊 Analytics", "dark", self.open_analytics),
            ("⚙️ Settings", "secondary", self.open_settings)
        ]
        
        for i, (text, style, command) in enumerate(actions):
            btn = ttk.Button(
                actions_frame,
                text=text,
                bootstyle=style,
                command=command,
                width=18
            )
            btn.grid(row=i//3, column=i%3, padx=10, pady=10, sticky="nsew")
            actions_frame.columnconfigure(i%3, weight=1)
        
        # Charts Frame
        charts_frame = ttk.Frame(main_container)
        charts_frame.pack(fill=BOTH, expand=True)
        
        # Revenue Chart
        chart1_frame = ttk.Frame(charts_frame)
        chart1_frame.pack(side=LEFT, fill=BOTH, expand=True, padx=(0, 10))
        self.create_revenue_chart(chart1_frame)
        
        # Occupancy Chart
        chart2_frame = ttk.Frame(charts_frame)
        chart2_frame.pack(side=LEFT, fill=BOTH, expand=True, padx=(10, 0))
        self.create_occupancy_chart(chart2_frame)
    
    def create_revenue_chart(self, parent):
        frame = ttk.LabelFrame(parent, text="📈 Monthly Revenue", bootstyle="success")
        frame.pack(fill=BOTH, expand=True)
        
        fig, ax = plt.subplots(figsize=(6, 4), facecolor='#2C2C2C')
        ax.set_facecolor('#2C2C2C')
        
        # Sample data - you'll replace this with actual data
        months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
        revenue = [50000, 75000, 60000, 90000, 85000, 95000]
        
        bars = ax.bar(months, revenue, color='#00BC8C', alpha=0.8)
        ax.set_ylabel('Revenue (Rs.)', color='white')
        ax.tick_params(colors='white')
        ax.grid(True, alpha=0.3)
        
        # Add value labels on bars
        for bar in bars:
            height = bar.get_height()
            ax.text(bar.get_x() + bar.get_width()/2., height,
                   f'Rs.{height/1000:.0f}K',
                   ha='center', va='bottom', color='white')
        
        canvas = FigureCanvasTkAgg(fig, frame)
        canvas.draw()
        canvas.get_tk_widget().pack(fill=BOTH, expand=True, padx=10, pady=10)
    
    def create_occupancy_chart(self, parent):
        frame = ttk.LabelFrame(parent, text="🏨 Room Occupancy", bootstyle="warning")
        frame.pack(fill=BOTH, expand=True)
        
        fig, ax = plt.subplots(figsize=(6, 4), facecolor='#2C2C2C')
        ax.set_facecolor('#2C2C2C')
        
        # Sample data
        statuses = ['Available', 'Occupied', 'Maintenance']
        counts = [15, 8, 2]
        colors = ['#00BC8C', '#F39C12', '#E74C3C']
        
        ax.pie(counts, labels=statuses, colors=colors, autopct='%1.1f%%',
              startangle=90, textprops={'color': 'white'})
        ax.axis('equal')
        
        canvas = FigureCanvasTkAgg(fig, frame)
        canvas.draw()
        canvas.get_tk_widget().pack(fill=BOTH, expand=True, padx=10, pady=10)
    
    def load_dashboard_stats(self):
        # Total Guests
        guests_query = "SELECT COUNT(*) as total FROM Guests"
        guests_result = db.execute_query(guests_query)
        self.stats_labels["guests"].config(text=f"{guests_result['total'][0]:,}")
        
        # Available Rooms
        rooms_query = "SELECT COUNT(*) as total FROM Rooms WHERE status = 'Available'"
        rooms_result = db.execute_query(rooms_query)
        self.stats_labels["rooms"].config(text=f"{rooms_result['total'][0]:,}")
        
        # Today's Check-ins
        bookings_query = "SELECT COUNT(*) as total FROM Bookings WHERE check_in_date = CAST(GETDATE() AS DATE)"
        bookings_result = db.execute_query(bookings_query)
        self.stats_labels["bookings"].config(text=f"{bookings_result['total'][0]:,}")
        
        # Total Revenue
        revenue_query = "SELECT ISNULL(SUM(amount), 0) as total FROM Payments WHERE status = 'Completed'"
        revenue_result = db.execute_query(revenue_query)
        self.stats_labels["revenue"].config(text=f"Rs. {revenue_result['total'][0]:,.2f}")
    
    def open_guests(self):
        from forms.guests_form import GuestsForm
        GuestsForm(self)
    
    def open_rooms(self):
        from forms.rooms_form import RoomsForm
        RoomsForm(self)
    
    def open_bookings(self):
        from forms.bookings_form import BookingsForm
        BookingsForm(self)
    
    def open_payments(self):
        messagebox.showinfo("Payments", "Payments management coming soon!")
    
    def open_analytics(self):
        messagebox.showinfo("Analytics", "Advanced analytics dashboard coming soon!")
    
    def open_settings(self):
        messagebox.showinfo("Settings", "System settings panel coming soon!")