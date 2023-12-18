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
  name VARCHAR NOT NULL
);

CREATE TABLE airports (
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  city VARCHAR NOT NULL,
  country VARCHAR NOT NULL
);

CREATE TABLE luggage_fees (
  id SERIAL,
  weight INTEGER NOT NULL,
  fee INTEGER NOT NULL,
  airline_id INTEGER NOT NULL REFERENCES airline(id),
  PRIMARY KEY(weight, airline_id),
  FOREIGN KEY(airline_id)
);

CREATE TABLE seat_luxury_fees (
  id SERIAL,
  luxury VARCHAR NOT NULL,
  fee INTEGER NOT NULL,
  airline_id INTEGER NOT NULL REFERENCES airline(id),
  PRIMARY KEY(luxury, airline_id),
  FOREIGN KEY(airline_id)
);

CREATE TABLE flights (
  id SERIAL,
  airline_id INTEGER NOT NULL REFERENCES airline(id),
  origin_id INTEGER NOT NULL REFERENCES airports(id),
  destination_id INTEGER NOT NULL REFERENCES airports(id),
  duration INTEGER NOT NULL,
  departure_date timestamp NOT NULL,
  arrival_date timestamp NOT NULL,
  PRIMARY KEY(id, airline_id),
  FOREIGN KEY(airline_id)
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
  id SERIAL,
  dni VARCHAR NOT NULL UNIQUE,
  gender VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  surnames VARCHAR NOT NULL,
  email VARCHAR NOT NULL,
  phone VARCHAR NOT NULL,
  PRIMARY KEY(id, dni)
);

CREATE TABLE clients_bonifications (
  id SERIAL,
  client_id INTEGER REFERENCES clients(id),
  bonification_id INTEGER REFERENCES bonifications(id),
  PRIMARY KEY (client_id, bonification_id)
);

CREATE TABLE seats (
  row INTEGER NOT NULL,
  col VARCHAR NOT NULL,
  price INTEGER NOT NULL,
  flight_id INTEGER NOT NULL REFERENCES flights(id),
  client_id INTEGER REFERENCES clients(id),
  luxury_id INTEGER NOT NULL REFERENCES seat_luxury_fees(id),
  airline_id INTEGER NOT NULL REFERENCES seat_luxury_fees(airline_id),
  client_info jsonb NOT NULL,
  PRIMARY KEY (row, col, flight_id)
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  client_id INTEGER NOT NULL REFERENCES clients(id),
  seats_id INTEGER[] NOT NULL,
  luggage_id INTEGER[] NOT NULL,
  price INTEGER NOT NULL,
  date VARCHAR NOT NULL,
  payment_status VARCHAR NOT NULL
);

CREATE TABLE cargo (
  id SERIAL,
  flight_id INTEGER NOT NULL REFERENCES flights(id),
  booking_id INTEGER NOT NULL REFERENCES bookings(id),
  airline_id INTEGER NOT NULL REFERENCES flights(airline_id),
  weight INTEGER,
  price DECIMAL(7,2),
  PRIMARY KEY (id, flight_id, airline_id, booking_id)
);

CREATE TABLE cancelations (
  id SERIAL PRIMARY KEY,
  booking_id INTEGER NOT NULL REFERENCES bookings(id),
  date VARCHAR NOT NULL
);
