USE hotel_db;

-- CREATE operations
INSERT INTO guests (first_name, last_name, email, phone)
VALUES ('Priya', 'Kapoor', 'priya.kapoor@example.com', '+49-151-11111111');

INSERT INTO bookings (guest_id, room_id, check_in, check_out, total_price, booking_status)
VALUES (4, 2, '2026-06-01', '2026-06-04', 165.00, 'Confirmed');

-- READ operations

SELECT
    b.booking_id,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    r.room_number,
    rt.type_name,
    rt.price_per_night,
    b.check_in,
    b.check_out,
    DATEDIFF(b.check_out, b.check_in) AS nights,
    b.total_price,
    b.booking_status
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
JOIN rooms r ON b.room_id = r.room_id
JOIN room_types rt ON r.type_id = rt.type_id
ORDER BY b.check_in;

--  Available rooms by type
SELECT
    rt.type_name,
    COUNT(*) AS available_rooms
FROM rooms r
JOIN room_types rt ON r.type_id = rt.type_id
WHERE r.status = 'Available'
GROUP BY rt.type_name
ORDER BY available_rooms DESC;

-- UPDATE operations

-- Mark a room as occupied after check-in
UPDATE rooms
SET status = 'Occupied'
WHERE room_id = 2;

-- Update booking status
UPDATE bookings
SET booking_status = 'CheckedIn'
WHERE booking_id = 1;

-- DELETE operations

-- Example cancellation: remove a booking
DELETE FROM bookings
WHERE booking_id = 2;


