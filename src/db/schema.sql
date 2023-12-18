DROP TABLE IF EXISTS cancelations;
DROP TABLE IF EXISTS cargo;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS clients_bonifications;
DROP TABLE IF EXISTS bonifications;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS seat_luxury_fees;
DROP TABLE IF EXISTS luggage_fees;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS airline;
DROP TYPE IF EXISTS bonification_type;

CREATE TABLE airline (
  id SERIAL PRIMARY KEY,
  icao VARCHAR NOT NULL,
  name VARCHAR NOT NULL
);

CREATE TABLE airports (
  id SERIAL PRIMARY KEY,
  iata VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  city VARCHAR NOT NULL,
  country VARCHAR NOT NULL
);

CREATE TABLE luggage_fees (
  weight INTEGER NOT NULL,
  fee DECIMAL(2, 7) NOT NULL,
  airline_id INTEGER NOT NULL REFERENCES airline(id) ON DELETE CASCADE,
  PRIMARY KEY(weight, airline_id)
);

CREATE TABLE seat_luxury_fees (
  luxury VARCHAR NOT NULL,
  fee DECIMAL(2, 7) NOT NULL,
  airline_id INTEGER NOT NULL REFERENCES airline(id) ON DELETE CASCADE,
  PRIMARY KEY(luxury, airline_id)
);

CREATE TABLE flights (
  flight_number INTEGER NOT NULL,
  airline_id INTEGER NOT NULL REFERENCES airline(id) ON DELETE CASCADE,
  origin_id INTEGER NOT NULL REFERENCES airports(id) ON DELETE CASCADE,
  destination_id INTEGER NOT NULL REFERENCES airports(id) ON DELETE CASCADE,
  duration INTEGER NOT NULL,
  departure_date timestamp NOT NULL,
  arrival_date timestamp NOT NULL,
  PRIMARY KEY (flight_number, airline_id)
);

CREATE TYPE bonification_type AS ENUM ('percent', 'fixed');

CREATE TABLE bonifications (
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  description VARCHAR NOT NULL,
  value INTEGER NOT NULL,
  type bonification_type NOT NULL
);

CREATE TABLE clients (
  dni VARCHAR NOT NULL PRIMARY KEY,
  gender VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  surnames VARCHAR NOT NULL,
  email VARCHAR NOT NULL,
  phone VARCHAR NOT NULL
);

CREATE TABLE clients_bonifications (
  client_id VARCHAR NOT NULL REFERENCES clients(dni) ON DELETE CASCADE,
  bonification_id INTEGER NOT NULL REFERENCES bonifications(id) ON DELETE CASCADE,
  PRIMARY KEY (client_id, bonification_id)
);

CREATE TABLE seats (
  id SERIAL UNIQUE,
  row INTEGER NOT NULL,
  col VARCHAR NOT NULL,
  price DECIMAL(7, 2) NOT NULL,
  flight_id INTEGER NOT NULL,
  client_id VARCHAR REFERENCES clients(dni) ON DELETE SET NULL,
  luxury_type VARCHAR,
  airline_id INTEGER NOT NULL,
  client_info jsonb NOT NULL,
  PRIMARY KEY (row, col, flight_id),
  FOREIGN KEY (luxury_type, airline_id) REFERENCES seat_luxury_fees(luxury, airline_id) ON DELETE SET NULL,
  FOREIGN KEY (flight_id, airline_id) REFERENCES flights(flight_number, airline_id) ON DELETE CASCADE
);

CREATE TABLE bookings (
  id SERIAL UNIQUE,
  client_id VARCHAR NOT NULL REFERENCES clients(dni) ON DELETE CASCADE,
  seat_id INTEGER NOT NULL REFERENCES seats(id) ON DELETE CASCADE,
  date VARCHAR NOT NULL,
  payment_status VARCHAR NOT NULL,
  PRIMARY KEY (id, client_id, seat_id)
);

CREATE TABLE cargo (
  id SERIAL,
  flight_id INTEGER NOT NULL,
  airline_id INTEGER NOT NULL,
  seat_id INTEGER NOT NULL REFERENCES seats(id) ON DELETE CASCADE,
  weight INTEGER,
  price DECIMAL(7,2),
  PRIMARY KEY (id, flight_id),
  FOREIGN KEY (flight_id, airline_id) REFERENCES flights(flight_number, airline_id) ON DELETE CASCADE
);

CREATE TABLE cancelations (
  id SERIAL PRIMARY KEY,
  booking_id INTEGER NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  date VARCHAR NOT NULL
);
