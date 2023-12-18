-- Insertar datos en la tabla airline
INSERT INTO airline (icao, name) VALUES
  ('DAL', 'Delta Airlines'),
  ('UAL', 'United Airlines'),
  ('ACA', 'Air Canada'),
  ('IBE', 'Iberia'),
  ('AEA', 'Air Europa'),
  ('BNT', 'Binter Canarias'),
  ('VUE', 'Vueling'),
  ('NOR', 'Norwegian');

-- Insertar datos en la tabla airports
INSERT INTO airports (iata, name, city, country) VALUES
  ('JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
  ('LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA'),
  ('YYZ', 'Toronto Pearson International Airport', 'Toronto', 'Canada'),
  ('TFN', 'Tenerife North Airport', 'Tenerife', 'Spain'),
  ('LPA', 'Gran Canaria Airport', 'Gran Canaria', 'Spain'),
  ('ACE', 'Lanzarote Airport', 'Lanzarote', 'Spain'),
  ('FUE', 'Fuerteventura Airport', 'Fuerteventura', 'Spain'),
  ('SPC', 'La Palma Airport', 'La Palma', 'Spain');
  
-- Insertar datos en la tabla luggage_fees
INSERT INTO luggage_fees (weight, fee, airline_id) VALUES
  (15, 20, 1),
  (25, 30, 1),
  (30, 35, 1),
  (20, 25, 2),
  (35, 40, 2),
  (23, 28, 3),
  (30, 35, 3),
  (22, 28, 4),
  (26, 32, 4),
  (30, 38, 4),
  (20, 25, 5),
  (24, 28, 5),
  (28, 32, 5),
  (18, 22, 6),
  (26, 30, 6),
  (25, 30, 7),
  (30, 35, 7),
  (35, 40, 7),
  (22, 28, 8),
  (32, 36, 8);


-- Insertar datos en la tabla seat_luxury_fees
INSERT INTO seat_luxury_fees (luxury, fee, airline_id) VALUES
  ('Business Class', 50, 1),
  ('First Class', 100, 1),
  ('Economy Plus', 25, 2),
  ('Business Class', 60, 2),
  ('First Class', 120, 2),
  ('Premium Economy', 30, 3),
  ('Business Class', 40, 3),
  ('Business Class', 60, 4),
  ('First Class', 110, 4),
  ('Business Class', 58, 5),
  ('First Class', 115, 5),
  ('Business Class', 35, 6),
  ('Economy Plus', 28, 7),
  ('Business Class', 65, 7),
  ('First Class', 140, 8);

-- Insertar datos en la tabla flights
INSERT INTO flights (airline_id, origin_id, destination_id, duration, departure_date, arrival_date) VALUES
  (1, 1, 2, 300, '2023-01-01 08:00:00', '2023-01-01 13:00:00'),
  (2, 2, 3, 360, '2023-01-02 10:00:00', '2023-01-02 16:00:00'),
  (3, 3, 1, 240, '2023-01-03 12:00:00', '2023-01-03 16:00:00'),
  (3, 3, 1, 240, '2023-02-01 12:00:00', '2023-02-01 16:00:00'),
  (3, 3, 2, 210, '2023-02-04 14:00:00', '2023-02-04 17:30:00'),
  (4, 4, 2, 300, '2023-02-02 08:00:00', '2023-02-02 13:00:00'),
  (4, 4, 1, 270, '2023-02-05 16:00:00', '2023-02-05 20:30:00'),
  (5, 5, 3, 180, '2023-02-03 10:00:00', '2023-02-03 13:00:00'),
  (6, 2, 1, 250, '2023-03-16 09:30:00', '2023-03-16 14:10:00'),
  (6, 3, 1, 260, '2023-03-17 16:20:00', '2023-03-17 21:40:00'),
  (6, 1, 2, 300, '2023-03-18 12:40:00', '2023-03-18 17:30:00'),
  (7, 1, 3, 280, '2023-03-19 11:15:00', '2023-03-19 15:35:00'),
  (7, 2, 1, 320, '2023-03-20 17:45:00', '2023-03-20 22:15:00'),
  (8, 3, 1, 290, '2023-03-22 10:25:00', '2023-03-22 15:15:00'),
  (8, 1, 3, 330, '2023-03-23 18:35:00', '2023-03-23 23:05:00'),
  (8, 2, 1, 300, '2023-03-24 14:45:00', '2023-03-24 19:55:00');

-- Insertar datos en la tabla bonifications
INSERT INTO bonifications (name, description, value, type) VALUES
  ('Frequent Flyer Discount', '10% off for frequent flyers', 10, 'percent'),
  ('Early Booking Discount', '15% off for early bookings', 15, 'percent'),
  ('Holiday Special', 'Fixed $20 discount for holidays', 20, 'fixed'),
  ('Last Minute Deal', '20% off for last-minute bookings', 20, 'percent'),
  ('Family Discount', 'Fixed $30 discount for family bookings', 30, 'fixed'),
  ('Weekend Special', '10% off for weekend flights', 10, 'percent'),
  ('Senior Citizen Discount', '15% off for senior citizens', 15, 'percent'),
  ('Round-trip Bonus', 'Fixed $25 discount for round-trip bookings', 25, 'fixed');

-- Insertar datos en la tabla clients
INSERT INTO clients (dni, gender, name, surnames, email, phone) VALUES
  ('123456789', 'Male', 'John', 'Doe', 'john.doe@example.com', '123-456-789'),
  ('987654321', 'Female', 'Jane', 'Smith', 'jane.smith@example.com', '987-654-321'),
  ('111222333', 'Male', 'Pedro', 'Gomez', 'pedro.gomez@example.com', '111-222-333'),
  ('444555666', 'Female', 'Maria', 'Rodriguez', 'maria.rodriguez@example.com', '444-555-666'),
  ('777888999', 'Male', 'Luis', 'Hernandez', 'luis.hernandez@example.com', '777-888-999'),
  ('123456789', 'Female', 'Ana', 'Fernandez', 'ana.fernandez@example.com', '123-456-789'),
  ('987654321', 'Male', 'David', 'Martinez', 'david.martinez@example.com', '987-654-321');

-- Insertar datos en la tabla clients_bonifications
INSERT INTO clients_bonifications (client_id, bonification_id) VALUES
  (1, 1),
  (2, 2),
  (2, 3);

-- Insertar datos en la tabla seats
INSERT INTO seats (row, col, price, flight_id, client_id, luxury_id, airline_id, client_info) VALUES
  (1, 'A', 100, 1, 1, 1, 1, '{"seat_preference": "Window"}'),
  (2, 'B', 150, 2, 2, 2, 2, '{"seat_preference": "Aisle"}'),
  (3, 'C', 120, 6, 6, 6, 3, '{"seat_preference": "Aisle"}'),
  (1, 'A', 100, 7, 7, 7, 4, '{"seat_preference": "Window"}'),
  (2, 'B', 150, 8, 8, 8, 5, '{"seat_preference": "Aisle"}'),
  (3, 'D', 110, 9, 9, 6, 3, '{"seat_preference": "Window"}'),
  (2, 'C', 160, 10, 10, 7, 4, '{"seat_preference": "Aisle"}');

-- Insertar datos en la tabla bookings
INSERT INTO bookings (client_id, seats_id, luggage_id, price, date, payment_status) VALUES
  (1, ARRAY[1], ARRAY[1], 100, '2023-01-01', 'Paid'),
  (2, ARRAY[2], ARRAY[2], 180, '2023-01-02', 'Paid'),
  (6, ARRAY[11], ARRAY[11], 90, '2023-02-01', 'Paid'),
  (7, ARRAY[12], ARRAY[12], 140, '2023-02-02', 'Paid'),
  (8, ARRAY[13], ARRAY[13], 120, '2023-02-03', 'Paid'),
  (9, ARRAY[14], ARRAY[14], 100, '2023-02-04', 'Paid'),
  (10, ARRAY[15], ARRAY[15], 180, '2023-02-05', 'Paid');

-- Insertar datos en la tabla cargo
INSERT INTO cargo (flight_id, booking_id, airline_id, weight, price) VALUES
  (1, 1, 1, 500, 200.00),
  (2, 2, 2, 700, 300.00),
  (6, 11, 3, 550, 220.00),
  (7, 12, 4, 750, 320.00),
  (8, 13, 5, 600, 250.00),
  (9, 14, 3, 500, 200.00),
  (10, 15, 4, 700, 300.00);

-- Insertar datos en la tabla cancelations
INSERT INTO cancelations (booking_id, date) VALUES
  (1, '2023-01-01'),
  (2, '2023-01-02');
