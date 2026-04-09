CREATE DATABASE hotel_db;
USE hotel_db;

-- 1. Core reference tables

CREATE TABLE room_types (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    price_per_night DECIMAL(10,2) NOT NULL,
    CHECK (price_per_night > 0)
);

CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    type_id INT NOT NULL,
    status ENUM('Available', 'Occupied', 'Cleaning', 'Maintenance') NOT NULL DEFAULT 'Available',
    FOREIGN KEY (type_id) REFERENCES room_types(type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    booking_status ENUM('Confirmed', 'CheckedIn', 'CheckedOut', 'Cancelled') NOT NULL DEFAULT 'Confirmed',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (check_out > check_in),
    CHECK (total_price >= 0)
);

-- 2. Indexing strategy
CREATE INDEX idx_bookings_guest_id ON bookings(guest_id);
CREATE INDEX idx_bookings_room_id ON bookings(room_id);
CREATE INDEX idx_bookings_dates ON bookings(check_in, check_out);
CREATE INDEX idx_rooms_status ON rooms(status);

-- 3. Sample data

INSERT INTO room_types (type_name, price_per_night) VALUES
('Single', 55.00),
('Double', 90.00),
('Deluxe Suite', 165.00),
('Penthouse', 320.00);

INSERT INTO rooms (room_number, type_id, status) VALUES
('101', 1, 'Available'),
('102', 1, 'Cleaning'),
('201', 2, 'Available'),
('301', 3, 'Occupied'),
('401', 4, 'Maintenance');

INSERT INTO guests (first_name, last_name, email, phone) VALUES
('Hannah', 'Muller', 'hannah.muller@example.com', '+49-170-1234567'),
('Stephen', 'Smith', 'stephen.smith@example.com', '+49-207-9460000'),
('Alice', 'Dubois', 'alice.dubois@example.com', '+49-178-23456789');

INSERT INTO bookings (guest_id, room_id, check_in, check_out, total_price, booking_status) VALUES
(1, 3, '2026-04-10', '2026-04-15', 450.00, 'Confirmed'),
(2, 4, '2026-05-01', '2026-05-03', 330.00, 'Confirmed'),
(3, 1, '2026-04-05', '2026-04-06', 55.00, 'CheckedOut');

SHOW TABLES;
-- Basic verification query
SELECT
    b.booking_id,
    g.first_name,
    g.last_name,
    r.room_number,
    rt.type_name,
    b.check_in,
    b.check_out,
    b.total_price,
    b.booking_status
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
JOIN rooms r ON b.room_id = r.room_id
JOIN room_types rt ON r.type_id = rt.type_id
ORDER BY b.booking_id;