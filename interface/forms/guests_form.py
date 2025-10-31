import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from ttkbootstrap.tableview import Tableview
from ttkbootstrap.validation import validator
from database import db

class GuestsForm(ttk.Toplevel):
    def __init__(self, parent):
        super().__init__(parent)
        self.title("👥 Guest Management")
        self.geometry("1000x700")
        self.transient(parent)
        self.grab_set()
        
        self.create_modern_ui()
        self.load_guests()
    
    def create_modern_ui(self):
        # Main container
        main_container = ttk.Frame(self)
        main_container.pack(fill=BOTH, expand=True, padx=20, pady=20)
        
        # Header
        header_frame = ttk.Frame(main_container)
        header_frame.pack(fill=X, pady=(0, 20))
        
        ttk.Label(
            header_frame,
            text="👥 Guest Management",
            font=('Helvetica', 18, 'bold'),
            bootstyle="primary"
        ).pack(side=LEFT)
        
        # Search frame
        search_frame = ttk.Frame(header_frame)
        search_frame.pack(side=RIGHT)
        
        self.search_var = ttk.StringVar()
        search_entry = ttk.Entry(
            search_frame,
            textvariable=self.search_var,
            width=30,
            bootstyle="primary"
        )
        search_entry.pack(side=LEFT, padx=(0, 10))
        search_entry.bind('<KeyRelease>', self.on_search)
        
        ttk.Button(
            search_frame,
            text="🔍 Search",
            bootstyle="outline-primary",
            command=self.search_guests
        ).pack(side=LEFT, padx=(0, 10))
        
        ttk.Button(
            search_frame,
            text="🔄 Refresh",
            bootstyle="outline-secondary",
            command=self.load_guests
        ).pack(side=LEFT)
        
        # Input Form
        form_frame = ttk.LabelFrame(main_container, text="➕ Add New Guest", bootstyle="info")
        form_frame.pack(fill=X, pady=(0, 20))
        
        # Row 1
        row1 = ttk.Frame(form_frame)
        row1.pack(fill=X, padx=15, pady=10)
        
        ttk.Label(row1, text="First Name *", bootstyle="primary").pack(side=LEFT, padx=(0, 10))
        self.first_name = ttk.Entry(row1, width=20, bootstyle="primary")
        self.first_name.pack(side=LEFT, padx=(0, 20))
        
        ttk.Label(row1, text="Last Name *", bootstyle="primary").pack(side=LEFT, padx=(0, 10))
        self.last_name = ttk.Entry(row1, width=20, bootstyle="primary")
        self.last_name.pack(side=LEFT, padx=(0, 20))
        
        ttk.Label(row1, text="Email *", bootstyle="primary").pack(side=LEFT, padx=(0, 10))
        self.email = ttk.Entry(row1, width=25, bootstyle="primary")
        self.email.pack(side=LEFT)
        
        # Row 2
        row2 = ttk.Frame(form_frame)
        row2.pack(fill=X, padx=15, pady=10)
        
        ttk.Label(row2, text="Phone", bootstyle="primary").pack(side=LEFT, padx=(0, 10))
        self.phone = ttk.Entry(row2, width=20, bootstyle="primary")
        self.phone.pack(side=LEFT, padx=(0, 20))
        
        ttk.Label(row2, text="ID Card", bootstyle="primary").pack(side=LEFT, padx=(0, 10))
        self.id_card = ttk.Entry(row2, width=20, bootstyle="primary")
        self.id_card.pack(side=LEFT, padx=(0, 20))
        
        ttk.Button(
            row2,
            text="💾 Add Guest",
            bootstyle="success",
            command=self.add_guest
        ).pack(side=LEFT, padx=(0, 10))
        
        ttk.Button(
            row2,
            text="🗑️ Clear",
            bootstyle="outline-secondary",
            command=self.clear_form
        ).pack(side=LEFT)
        
        # Table
        table_frame = ttk.Frame(main_container)
        table_frame.pack(fill=BOTH, expand=True)
        
        self.create_table(table_frame)
    
    def create_table(self, parent):
        coldata = [
            {"text": "ID", "stretch": False, "width": 80},
            {"text": "First Name", "stretch": True},
            {"text": "Last Name", "stretch": True},
            {"text": "Email", "stretch": True},
            {"text": "Phone", "stretch": True},
            {"text": "ID Card", "stretch": True}
        ]
        
        self.table = Tableview(
            parent,
            coldata=coldata,
            rowdata=[],
            paginated=True,
            searchable=False,
            bootstyle="primary",
            stripecolor=("default", None),
        )
        self.table.pack(fill=BOTH, expand=True, pady=(10, 0))
        
        # Bind double click event
        self.table.bind('<<TreeviewSelect>>', self.on_row_select)
    
    def load_guests(self):
        query = """
        SELECT guest_id, first_name, last_name, email, phone, id_card_number 
        FROM Guests 
        ORDER BY first_name, last_name
        """
        result = db.execute_query(query)
        
        rowdata = []
        for _, row in result.iterrows():
            rowdata.append((
                row['guest_id'],
                row['first_name'],
                row['last_name'],
                row['email'],
                row['phone'] or 'N/A',
                row['id_card_number'] or 'N/A'
            ))
        
        self.table.build_table_data(rowdata=rowdata)
    
    def add_guest(self):
        first_name = self.first_name.get().strip()
        last_name = self.last_name.get().strip()
        email = self.email.get().strip()
        phone = self.phone.get().strip()
        id_card = self.id_card.get().strip()
        
        if not first_name or not last_name or not email:
            ttk.dialogs.Messagebox.show_error(
                "First name, last name, and email are required!",
                "Validation Error"
            )
            return
        
        query = """
        INSERT INTO Guests (first_name, last_name, email, phone, id_card_number, address, date_of_birth)
        VALUES (?, ?, ?, ?, ?, 'Not provided', GETDATE())
        """
        
        rows_affected = db.execute_non_query(query, (first_name, last_name, email, phone, id_card))
        
        if rows_affected > 0:
            ttk.dialogs.Messagebox.show_info("Guest added successfully!", "Success")
            self.clear_form()
            self.load_guests()
        else:
            ttk.dialogs.Messagebox.show_error("Failed to add guest!", "Error")
    
    def search_guests(self):
        search_term = self.search_var.get().strip()
        if not search_term:
            self.load_guests()
            return
        
        query = """
        SELECT guest_id, first_name, last_name, email, phone, id_card_number 
        FROM Guests 
        WHERE first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR phone LIKE ?
        ORDER BY first_name, last_name
        """
        
        result = db.execute_query(query, (
            f'%{search_term}%', f'%{search_term}%', 
            f'%{search_term}%', f'%{search_term}%'
        ))
        
        rowdata = []
        for _, row in result.iterrows():
            rowdata.append((
                row['guest_id'],
                row['first_name'],
                row['last_name'],
                row['email'],
                row['phone'] or 'N/A',
                row['id_card_number'] or 'N/A'
            ))
        
        self.table.build_table_data(rowdata=rowdata)
    
    def on_search(self, event=None):
        self.search_guests()
    
    def on_row_select(self, event):
        selection = self.table.get_rows(selected=True)
        if selection:
            row = selection[0].values
            # You can implement edit functionality here
            print(f"Selected: {row}")
    
    def clear_form(self):
        self.first_name.delete(0, END)
        self.last_name.delete(0, END)
        self.email.delete(0, END)
        self.phone.delete(0, END)
        self.id_card.delete(0, END)