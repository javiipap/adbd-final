-- Inserción de datos en la tabla airline
INSERT INTO airline (icao, name) VALUES
('ICAO001', 'Airline1'),
('ICAO002', 'Airline2'),
('ICAO003', 'Airline3'),
('ICAO004', 'Airline4');

-- Inserción de datos en la tabla airports
INSERT INTO airports (iata, name, city, country) VALUES
('AAA', 'Airport1', 'City1', 'Country1'),
('BBB', 'Airport2', 'City2', 'Country2'),
('CCC', 'Airport3', 'City3', 'Country3'),
('DDD', 'Airport4', 'City4', 'Country4');

-- Inserción de datos en la tabla luggage_fees
INSERT INTO luggage_fees (weight, fee, airline_id) VALUES
(20, 50.00, 1),
(30, 75.00, 2),
(25, 60.00, 3),
(35, 90.00, 4);

-- Inserción de datos en la tabla seat_luxury_fees
INSERT INTO seat_luxury_fees (luxury, fee, description, airline_id) VALUES
('FirstClass', 150.00, 'FirstClass', 1),
('BusinessClass', 100.00, 'BusinessClass', 2),
('PremiumEconomy', 80.00, 'PremiumEconomy', 3),
('Economy', 50.00, 'Economy', 4);

-- Inserción de datos en la tabla flights
INSERT INTO flights (flight_number, airline_id, origin_id, destination_id, duration, departure_date, arrival_date) VALUES
(101, 1, 1, 2, 120, '2023-01-01 08:00:00', '2023-01-01 10:00:00'),
(202, 2, 2, 3, 180, '2023-01-02 12:00:00', '2023-01-02 15:00:00'),
(303, 3, 3, 4, 150, '2023-01-03 16:00:00', '2023-01-03 18:30:00'),
(404, 4, 4, 1, 200, '2023-01-04 20:00:00', '2023-01-05 00:00:00');

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
INSERT INTO seats (row, col, price, flight_number, user_id, luxury_type, airline_id, user_info) VALUES
(1, 'A', 100.00, 101, '123456789A', 'FirstClass', 1, '{"name": "Carlos", "dni": "51351315x"}'),
(2, 'B', 80.00, 101, '987654321B', 'FirstClass', 1, '{"name": "José", "dni": "5168463fs"}'),
(3, 'C', 60.00, 202, '555555555C', 'BusinessClass', 2, '{"name": "Julián", "dni": "135832165f"}'),
(4, 'D', 40.00, 303, '111111111D', 'PremiumEconomy', 3, '{"name": "Andrés", "dni": "65168341f"}');

-- Inserción de datos en la tabla bookings
INSERT INTO bookings (user_id, seat_id, date, payment_status) VALUES
('123456789A', 1, '2023-01-01', 'Paid'),
('987654321B', 2, '2023-01-02', 'Paid'),
('555555555C', 3, '2023-01-03', 'Pending'),
('111111111D', 4, '2023-01-04', 'Paid');

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
