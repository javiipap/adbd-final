-- Inserción de datos en la tabla airlines
INSERT INTO airlines (icao, name) VALUES
('ICAO001', 'Airline One'),
('ICAO002', 'Airline Two'),
('ICAO003', 'Airline Three'),
('ICAO004', 'Airline Four');

-- Inserción de datos en la tabla airports
INSERT INTO airports (iata, name, city, country) VALUES
('AAA', 'Airport A', 'City A', 'Country A'),
('BBB', 'Airport B', 'City B', 'Country B'),
('CCC', 'Airport C', 'City C', 'Country C'),
('DDD', 'Airport D', 'City D', 'Country D');

-- Inserción de datos en la tabla luggage_fees
INSERT INTO luggage_fees (weight, fee, airline_id) VALUES
(20, 50.00, 1),
(30, 75.00, 2),
(25, 60.00, 3),
(35, 90.00, 4);

-- Inserción de datos en la tabla seat_luxury_fees
INSERT INTO seat_luxury_fees (luxury_type, fee, description, airline_id) VALUES
('FirstClass', 150.00, 'Luxurious first-class seating', 1),
('BusinessClass', 100.00, 'Comfortable business-class seating', 2),
('PremiumEconomy', 80.00, 'Spacious premium economy seating', 3),
('Economy', 50.00, 'Standard economy seating', 4);

-- Inserción de datos en la tabla flights
INSERT INTO flights (flight_number, base_price, airline_id, origin_id, destination_id, duration, departure_date, arrival_date, max_cargo_load) VALUES
(101, 200.00, 1, 1, 2, 120, '2023-01-01 08:00:00', '2023-01-01 10:00:00', 500),
(202, 250.00, 2, 2, 3, 180, '2023-01-02 12:00:00', '2023-01-02 15:00:00', 600),
(303, 180.00, 3, 3, 4, 150, '2023-01-03 16:00:00', '2023-01-03 18:30:00', 450),
(404, 220.00, 4, 4, 1, 200, '2023-01-04 20:00:00', '2023-01-05 00:00:00', 550);

-- Inserción de datos en la tabla bonifications
INSERT INTO bonifications (name, description, value, type) VALUES
('Discount10', '10% Discount', 10, 'percent'),
('Fixed20', 'Fixed $20 Discount', 20, 'fixed'),
('Fixed30', 'Fixed $30 Discount', 30, 'fixed'),
('Discount5', '5% Discount', 5, 'percent');

-- Inserción de datos en la tabla users
INSERT INTO users (dni, gender, name, surnames, email, phone) VALUES
('123456789A', 'Male', 'John', 'Doe', 'john.doe@example.com', '+123456789'),
('987654321B', 'Female', 'Jane', 'Smith', 'jane.smith@example.com', '+987654321'),
('555555555C', 'Non-Binary', 'Alex', 'Johnson', 'alex.johnson@example.com', '+555555555'),
('111111111D', 'Male', 'Chris', 'Lee', 'chris.lee@example.com', '+111111111');

-- Inserción de datos en la tabla users_bonifications
INSERT INTO users_bonifications (user_id, bonification_id) VALUES
('123456789A', 1),
('987654321B', 2),
('555555555C', 3),
('111111111D', 4);

-- Inserción de datos en la tabla seats
INSERT INTO seats (row, col, price, flight_number, airline_id, luxury_type, user_info) VALUES
(1, 'A', 100.00, 101, 1,'FirstClass', '{"seat_preference": "window"}'),
(2, 'B', 80.00, 202, 2, 'BusinessClass', '{"seat_preference": "aisle"}'),
(3, 'C', 60.00, 303, 3, 'PremiumEconomy', '{"seat_preference": "middle"}'),
(4, 'D', 40.00, 404, 4, 'Economy', '{"seat_preference": "window"}');

-- Inserción de datos en la tabla bookings
INSERT INTO bookings (user_id, seat_id, date, payment_status) VALUES
('123456789A', 1, '2023-01-01', 'fulfilled'),
('987654321B', 2, '2023-01-02', 'fulfilled'),
('555555555C', 3, '2023-01-03', 'pending'),
('111111111D', 4, '2023-01-04', 'fulfilled');

-- Inserción de datos en la tabla cargo
INSERT INTO cargo (flight_number, airline_id, seat_id, weight, price) VALUES
(101, 1, 1, 15, 30.00),
(202, 2, 2, 20, 40.00),
(303, 3, 3, 25, 50.00),
(404, 4, 4, 30, 60.00);

-- Inserción de datos en la tabla cancelations
INSERT INTO cancelations (booking_id, date) VALUES
(1, '2023-01-02'),
(3, '2023-01-04');
