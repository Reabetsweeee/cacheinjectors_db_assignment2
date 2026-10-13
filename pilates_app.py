# Group Name: Cache Injectors
#file name : pilates_app.py
# Group Members:
# 1. Richard Mulaudzi - 4343883
# 2. Reabetswe Selepe - 4462904
# 3. Tondani Mukwevho - 4495953
# 4. Aphelele Simelane - 4391966
# 5. Cush Nethanani - 4489773
import mysql.connector
from mysql.connector import Error
from tabulate import tabulate
import logging
import getpass

#Logging configuration to save program messages and errors to log file.
logging.basicConfig(
    filename= "pilates_log.txt",
    level= logging.INFO,
    format= "%(asctime)s - %(levelname)s - %(message)s"
)

#Listing all 10 Section 6 SQL Queries
queries= [
    ("Query 1: Alphabetical Client Directory",
    "SELECT client_id, first_name, last_name, phone FROM Client ORDER BY last_name ASC, first_name ASC"), 
    ("Query 2: High-Capacity Session Filtering", 
    "SELECT session_id, session_date, start_time, max_capacity FROM Session WHERE max_capacity > 10 ORDER BY session_date ASC;"),
    ("Query 3: Client Membership Tier Mapping", 
    "SELECT c.client_id, CONCAT(c.first_name, ' ', c.last_name) AS client_name, m.plan_name, m.classes_per_month, m.is_unlimited FROM Client c INNER JOIN MembershipPlan m ON c.membership_plan_id = m.plan_id ORDER BY c.client_id ASC;"),
    ("Query 4: Complete Class Schedule Overview", 
    "SELECT s.session_id, pc.class_name, CONCAT(i.first_name, ' ', i.last_name) AS instructor_name, s.session_date, s.start_time, s.max_capacity FROM Session s INNER JOIN PilatesClass pc ON s.class_id = pc.class_id INNER JOIN Instructor i ON s.instructor_id = i.instructor_id ORDER BY s.session_date ASC, s.start_time ASC;"),
    ("Query 5: Overall Booking Status Summary", 
    "SELECT booking_status, COUNT(*) AS total_bookings FROM Booking GROUP BY booking_status ORDER BY total_bookings DESC;"),
    ("Query 6: Dynamic Client Age Calculation", 
    "SELECT client_id, CONCAT(first_name, ' ', last_name) AS full_name, date_of_birth, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age FROM Client ORDER BY age DESC;"),
    ("Query 7: Popular Sessions Identification", 
    "SELECT s.session_id, pc.class_name, s.session_date, s.start_time, COUNT(b.booking_id) AS active_booking_count FROM Session s INNER JOIN PilatesClass pc ON s.class_id = pc.class_id INNER JOIN Booking b ON s.session_id = b.session_id WHERE b.booking_status IN ('Booked', 'Attended') GROUP BY s.session_id, pc.class_name, s.session_date, s.start_time HAVING COUNT(b.booking_id) >= 2;"),
    ("Query 8: Real-Time Session Capacity & Available Spots", 
    "SELECT s.session_id, pc.class_name, s.session_date, s.start_time, s.max_capacity, COUNT(CASE WHEN b.booking_status IN ('Booked', 'Attended') THEN 1 END) AS active_bookings, (s.max_capacity - COUNT(CASE WHEN b.booking_status IN ('Booked', 'Attended') THEN 1 END)) AS available_spots FROM Session s INNER JOIN PilatesClass pc ON s.class_id = pc.class_id LEFT JOIN Booking b ON s.session_id = b.session_id GROUP BY s.session_id, pc.class_name, s.session_date, s.start_time, s.max_capacity ORDER BY s.session_id ASC;"),
    ("Query 9: Monthly Client Booking Allocation Audit", 
    "SELECT c.client_id, CONCAT(c.first_name, ' ', c.last_name) AS client_name, m.plan_name, m.classes_per_month, COUNT(b.booking_id) AS current_month_bookings FROM Client c INNER JOIN MembershipPlan m ON c.membership_plan_id = m.plan_id INNER JOIN Booking b ON c.client_id = b.client_id WHERE m.is_unlimited = FALSE AND b.booking_status IN ('Booked', 'Attended') AND DATE_FORMAT(b.booking_date, '%Y-%m') = '2026-10' GROUP BY c.client_id, client_name, m.plan_name, m.classes_per_month HAVING COUNT(b.booking_id) <= m.classes_per_month ORDER BY current_month_bookings DESC;"),
    ("Query 10: Class Type Performance & Attendance Rate Breakdown", 
    "SELECT pc.class_name, COUNT(b.booking_id) AS total_bookings_recorded, SUM(CASE WHEN b.booking_status = 'Attended' THEN 1 ELSE 0 END) AS total_attended, SUM(CASE WHEN b.booking_status = 'Cancelled' THEN 1 ELSE 0 END) AS total_cancelled, SUM(CASE WHEN b.booking_status = 'No-show' THEN 1 ELSE 0 END) AS total_noshow, ROUND((SUM(CASE WHEN b.booking_status = 'Attended' THEN 1 ELSE 0 END) / COUNT(b.booking_id)) * 100, 2) AS attendance_rate_percentage FROM PilatesClass pc INNER JOIN Session s ON pc.class_id = s.class_id INNER JOIN Booking b ON s.session_id = b.session_id GROUP BY pc.class_id, pc.class_name ORDER BY attendance_rate_percentage DESC;")
    ]

#Requesting DB connection info from user.
def connectDb():
    """Establish secure connection to MySQL database."""
    host= input ("Enter MySQL host (default: localhost): ") or "localhost"
    user= input ("Enter MySQL username (default: root): ") or "root"
    password= getpass.getpass ("Enter MySQL password: ")
    dbName= input ("Enter database name (default: pilates_studio_db): ") or "pilates_studio_db"

#Establishing connection to the MySQL database.
    try: 
        conn= mysql.connector.connect (
            host= host,
            user= user,
            password= password,
            database= dbName
        )
        #Checking for connection success.
        if conn.is_connected ():
            print (f"Connected successfully to '{dbName}'!")
            logging.info (f"Connected to {dbName} as {user}")
            return conn

    #MySQL Connection error handling. 
    except Error as err:
        print (f"Connection failed: {err}")
        logging.error (f"Connection failed: {err})")
    return None

#Executing all queries and saving their results. 
def executeAllQueries (conn):
    cursor= conn.cursor() #allows SQL statemts to be executed. 

    #Writing query execution results to textfile.
    try:
        with open ("pilates_output.txt", "w") as f: 
            for title, query in queries:
                print(f"\n[EXECUTING] {title}")
                f.write(f"\n--- {title} ---\n")

                try:
                    cursor.execute (query)
                    results= cursor.fetchall()
                    headers= [desc[0] for desc in cursor.description]

                    #Formatting results into table format.
                    tableStr= tabulate (results, headers=headers, tablefmt= "grid")
                    print (tableStr)
                    f.write (tableStr + "\n")
                    logging.info (f"Successfully executed: {title}")

                #SQL query error handling.
                except Error as err:
                    errorMsg= f"Error executing {title}: {err}"
                    print (errorMsg)
                    logging.error (errorMsg)

    #Closing cursor and db connection to save resources
    finally:
        cursor.close()
        conn.close()

    print("\nAll queries executed successfully. Results saved to 'pilates_output.txt'.")

# Main execution block
if __name__ == "__main__":
    print("DEBUG: Main block reached.")
    connection = connectDb()
if connection:
    executeAllQueries(connection)
else:
    print("DEBUG: Connection returned None.")

             



