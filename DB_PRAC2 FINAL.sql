
DROP DATABASE IF EXISTS pilates_studio_db;
CREATE DATABASE pilates_studio_db;
USE pilates_studio_db;

CREATE TABLE MembershipPlan (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(50) NOT NULL UNIQUE,
    classes_per_month INT NULL,
    is_unlimited BOOLEAN NOT NULL
);

CREATE TABLE Instructor (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(30) NOT NULL CHECK (type IN ('Reformer', 'Mat', 'Beginner', 'General')),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NULL
);

CREATE TABLE PilatesClass (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT NULL
);

CREATE TABLE Client (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NULL,
    date_of_birth DATE NULL,
    registration_date DATE NOT NULL,
    membership_plan_id INT NOT NULL,
    CONSTRAINT fk_client_membership_plan FOREIGN KEY (membership_plan_id) 
        REFERENCES MembershipPlan(plan_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Session (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL,
    instructor_id INT NOT NULL,
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    max_capacity INT NOT NULL CHECK (max_capacity > 0),
    CONSTRAINT fk_session_pilates_class FOREIGN KEY (class_id) 
        REFERENCES PilatesClass(class_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_session_instructor_person FOREIGN KEY (instructor_id) 
        REFERENCES Instructor(instructor_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Booking (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    session_id INT NOT NULL,
    booking_status VARCHAR(20) NOT NULL CHECK (booking_status IN ('Booked', 'Attended', 'Cancelled', 'No-show')),
    booking_date DATE NULL,
    CONSTRAINT fk_booking_client_user FOREIGN KEY (client_id) 
        REFERENCES Client(client_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_booking_session_event FOREIGN KEY (session_id) 
        REFERENCES Session(session_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_client_session UNIQUE (client_id, session_id)
);


INSERT INTO MembershipPlan (plan_name, classes_per_month, is_unlimited) VALUES
('4 Classes per Month', 4, FALSE),
('8 Classes per Month', 8, FALSE),
('Unlimited', NULL, TRUE);

INSERT INTO Instructor (type, first_name, last_name, email, phone) VALUES
('Reformer', 'Sarah', 'Jenkins', 'sarah.j@pilatesstudio.com', '0821112233'),
('General', 'David', 'Miller', 'david.m@pilatesstudio.com', '0834445566');

INSERT INTO PilatesClass (class_name, description) VALUES
('Reformer Pilates', 'Dynamic workout using reformer machines for resistance training.'),
('Mat Pilates', 'Core-strengthening floor exercises using mats and small equipment.'),
('Beginner Pilates', 'Introductory class focusing on fundamental techniques and form.');

INSERT INTO Client (first_name, last_name, email, phone, date_of_birth, registration_date, membership_plan_id) VALUES
('Emma', 'Watson', 'emma.w@gmail.com', '0711234567', '1995-04-15', '2026-01-10', 1),
('Liam', 'Smith', 'liam.s@gmail.com', '0722345678', '1990-08-22', '2026-02-01', 2),
('Olivia', 'Brown', 'olivia.b@gmail.com', '0733456789', '1998-12-05', '2026-02-15', 3),
('Noah', 'Davis', 'noah.d@gmail.com', '0744567890', '1988-03-30', '2026-03-01', 2);

INSERT INTO Session (class_id, instructor_id, session_date, start_time, max_capacity) VALUES
(1, 1, '2026-10-12', '08:00:00', 10),
(1, 1, '2026-10-12', '17:00:00', 10),
(1, 2, '2026-10-14', '17:00:00', 10),
(1, 2, '2026-10-17', '09:00:00', 10),
(2, 1, '2026-10-13', '10:00:00', 15),
(3, 2, '2026-10-15', '18:00:00', 12);

INSERT INTO Booking (client_id, session_id, booking_status, booking_date) VALUES
(1, 1, 'Attended', '2026-10-08'),
(2, 1, 'Attended', '2026-10-08'),
(3, 1, 'Cancelled', '2026-10-08'),
(4, 1, 'No-show', '2026-10-08'),
(1, 2, 'Booked', '2026-10-09'),
(2, 3, 'Attended', '2026-10-09'),
(3, 4, 'Booked', '2026-10-10');

-- 4. VERIFICATION QUERIES FOR REPORT SCREENSHOTS
SELECT * FROM MembershipPlan;
SELECT * FROM Instructor;
SELECT * FROM PilatesClass;
SELECT * FROM Client;
SELECT * FROM Session;
SELECT * FROM Booking;

-- eg1 simple
SELECT client_id, first_name, last_name, email, phone 
FROM Client 
ORDER BY last_name ASC, first_name ASC;


-- eg2 simple
SELECT session_id, session_date, start_time, max_capacity 
FROM Session 
WHERE max_capacity > 10 
ORDER BY session_date ASC;

-- eg3 medium
SELECT 
    c.client_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS client_name, 
    m.plan_name, 
    m.classes_per_month, 
    m.is_unlimited 
FROM Client c 
INNER JOIN MembershipPlan m ON c.membership_plan_id = m.plan_id 
ORDER BY c.client_id ASC;


-- eg4 medium
SELECT 
    s.session_id, 
    pc.class_name, 
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name, 
    s.session_date, 
    s.start_time, 
    s.max_capacity 
FROM Session s 
INNER JOIN PilatesClass pc ON s.class_id = pc.class_id 
INNER JOIN Instructor i ON s.instructor_id = i.instructor_id 
ORDER BY s.session_date ASC, s.start_time ASC;

-- eg5 medium
SELECT 
    booking_status, 
    COUNT(*) AS total_bookings 
FROM Booking 
GROUP BY booking_status 
ORDER BY total_bookings DESC;

-- eg6 medium
SELECT 
    client_id, 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    date_of_birth, 
    TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age 
FROM Client 
ORDER BY age DESC;

-- eg7 complex
SELECT 
    s.session_id, 
    pc.class_name, 
    s.session_date, 
    s.start_time, 
    COUNT(b.booking_id) AS active_booking_count 
FROM Session s 
INNER JOIN PilatesClass pc ON s.class_id = pc.class_id 
INNER JOIN Booking b ON s.session_id = b.session_id 
WHERE b.booking_status IN ('Booked', 'Attended') 
GROUP BY s.session_id, pc.class_name, s.session_date, s.start_time 
HAVING COUNT(b.booking_id) >= 2;


-- eg8 complex
SELECT 
    s.session_id, 
    pc.class_name, 
    s.session_date, 
    s.start_time, 
    s.max_capacity, 
    COUNT(CASE WHEN b.booking_status IN ('Booked', 'Attended') THEN 1 END) AS active_bookings, 
    (s.max_capacity - COUNT(CASE WHEN b.booking_status IN ('Booked', 'Attended') THEN 1 END)) AS available_spots 
FROM Session s 
INNER JOIN PilatesClass pc ON s.class_id = pc.class_id 
LEFT JOIN Booking b ON s.session_id = b.session_id 
GROUP BY s.session_id, pc.class_name, s.session_date, s.start_time, s.max_capacity 
ORDER BY s.session_id ASC;


-- eg9 complex
SELECT 
    c.client_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS client_name, 
    m.plan_name, 
    m.classes_per_month, 
    COUNT(b.booking_id) AS current_month_bookings 
FROM Client c 
INNER JOIN MembershipPlan m ON c.membership_plan_id = m.plan_id 
INNER JOIN Booking b ON c.client_id = b.client_id 
WHERE m.is_unlimited = FALSE 
  AND b.booking_status IN ('Booked', 'Attended') 
  AND DATE_FORMAT(b.booking_date, '%Y-%m') = '2026-10' 
GROUP BY c.client_id, client_name, m.plan_name, m.classes_per_month 
HAVING COUNT(b.booking_id) <= m.classes_per_month 
ORDER BY current_month_bookings DESC;


-- eg 10 complex
SELECT 
    pc.class_name, 
    COUNT(b.booking_id) AS total_bookings_recorded, 
    SUM(CASE WHEN b.booking_status = 'Attended' THEN 1 ELSE 0 END) AS total_attended, 
    SUM(CASE WHEN b.booking_status = 'Cancelled' THEN 1 ELSE 0 END) AS total_cancelled, 
    SUM(CASE WHEN b.booking_status = 'No-show' THEN 1 ELSE 0 END) AS total_noshow, 
    ROUND(
        (SUM(CASE WHEN b.booking_status = 'Attended' THEN 1 ELSE 0 END) / COUNT(b.booking_id)) * 100, 
        2
    ) AS attendance_rate_percentage 
FROM PilatesClass pc 
INNER JOIN Session s ON pc.class_id = s.class_id 
INNER JOIN Booking b ON s.session_id = b.session_id 
GROUP BY pc.class_id, pc.class_name 
ORDER BY attendance_rate_percentage DESC;

