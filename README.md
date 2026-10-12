# Pilates Studio Management System
### Database Project by CacheInjectors

## 1. Project Overview

The Pilates Studio Management System is a database project developed using Python and MySQL. It is designed to help a Pilates studio manage its clients, membership plans, instructors, class types, scheduled sessions, and bookings.

The system supports different Pilates classes, including Reformer, Mat, and Beginner Pilates. It stores session schedules, instructor assignments, maximum class capacities, booking information, and attendance outcomes.

The project demonstrates relational database design, entity-relationship modelling, normalisation, SQL queries, database constraints, testing, and Python-MySQL integration.

## 2. Project Objectives

The main objectives of this project are to:

- Design and implement a relational database for a Pilates studio.
- Manage client information and membership plans.
- Store Pilates class types, instructors, and scheduled sessions.
- Record client bookings and their statuses.
- Use SQL queries to retrieve and analyse studio information.
- Connect a Python application to a MySQL database.
- Test database constraints, query results, and application error handling.

## 3. Technologies Used

- **Python 3:** Application development and query execution.
- **MySQL:** Relational database management.
- **SQL:** Database creation, data manipulation, querying, and constraints.
- **MySQL Connector/Python:** Connecting the Python application to MySQL.
- **Tabulate:** Formatting query results into readable tables.
- **GitHub:** Source code management and project submission.

## 4. Database Design

The database is named `pilates_studio_db` and contains six main entities.

| Entity | Description |
|---|---|
| `Client` | Stores registered client information and membership references. |
| `MembershipPlan` | Stores membership options, monthly class allowances, and unlimited-plan information. |
| `Instructor` | Stores instructor details. |
| `PilatesClass` | Stores Pilates class types, including Reformer, Mat, and Beginner. |
| `Session` | Stores scheduled classes, dates, times, instructors, and maximum capacities. |
| `Booking` | Connects clients to sessions and records booking statuses. |

The database uses primary keys, foreign keys, unique constraints, and check constraints to maintain data integrity and reduce duplication.

The schema was designed and normalised to Third Normal Form (3NF).

## 5. SQL Queries and Functionality

The project includes ten SQL queries organised into three levels of complexity.

### Simple Queries
1. Alphabetical Client Directory
2. High-Capacity Session Filtering

### Medium Queries
3. Client Membership Tier Mapping
4. Complete Class Schedule Overview
5. Overall Booking Status Summary
6. Dynamic Client Age Calculation

### Complex Queries
7. Popular Sessions Identification
8. Session Capacity and Available Spots Calculation
9. Monthly Client Booking Allocation Audit
10. Class Type Performance and Attendance Rate Breakdown

These queries demonstrate filtering, sorting, joins, aggregation, grouping, conditional calculations, and derived attributes.

They provide information that can assist the studio in monitoring bookings, reviewing attendance, checking membership usage, and understanding class demand.

## 6. Python Application

The Python application, `pilates_app.py`, connects to the MySQL database and executes the ten SQL queries.

Its main features include:

- Requesting database connection details at runtime.
- Connecting to the `pilates_studio_db` database.
- Executing SQL queries and retrieving results.
- Displaying formatted results in the terminal.
- Saving query results to an output text file.
- Recording application events and errors in a log file.
- Handling connection and query errors.
- Closing database resources after execution.

The application is designed to demonstrate database connectivity and query execution. It retrieves and displays information rather than providing a complete booking-management interface.

## 7. Project Files

| File | Purpose |
|---|---|
| `DB_PRAC2 FINAL.sql` | SQL script for creating and setting up the database. |
| `pilates_app.py` | Python application for connecting to MySQL and executing queries. |
| `pilates_log.txt` | Log file for application events and errors. |
| `pilates_output.txt` | File containing saved query results. |
| `requirements.txt` | Lists the Python packages required by the application. |

## 8. Installation and Setup

### Prerequisites

Ensure that the following are installed:

- Python
