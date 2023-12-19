DROP TABLE IF EXISTS cancelations;
DROP TABLE IF EXISTS cargo;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS users_bonifications;
DROP TABLE IF EXISTS bonifications;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS seat_luxury_fees;
DROP TABLE IF EXISTS luggage_fees;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS airlines;
DROP TYPE IF EXISTS bonification_type;
DROP TYPE IF EXISTS payment_status;

CREATE TABLE airlines (
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
  id SERIAL NOT NULL UNIQUE,
  weight INTEGER NOT NULL,
  fee DECIMAL(7, 2) NOT NULL,
  airline_id INTEGER NOT NULL REFERENCES airlines(id) ON DELETE CASCADE,
  PRIMARY KEY(weight, airline_id)
);

CREATE TABLE seat_luxury_fees (
  id SERIAL NOT NULL UNIQUE,
  luxury_type VARCHAR NOT NULL,
  fee DECIMAL(7, 2) NOT NULL,
  description VARCHAR NOT NULL,
  airline_id INTEGER NOT NULL REFERENCES airlines(id) ON DELETE CASCADE,
  PRIMARY KEY(luxury_type, airline_id)
);

CREATE TABLE flights (
  id VARCHAR NOT NULL UNIQUE,
  flight_number INTEGER NOT NULL,
  base_price DECIMAL(7,2) NOT NULL,
  airline_id INTEGER NOT NULL REFERENCES airlines(id) ON DELETE CASCADE,
  origin_id INTEGER NOT NULL REFERENCES airports(id) ON DELETE CASCADE,
  destination_id INTEGER NOT NULL REFERENCES airports(id) ON DELETE CASCADE,
  duration INTEGER NOT NULL,
  departure_date timestamp NOT NULL,
  arrival_date timestamp NOT NULL,
  max_cargo_load INTEGER NOT NULL,
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

CREATE TABLE users (
  dni VARCHAR NOT NULL PRIMARY KEY,
  gender VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  surnames VARCHAR NOT NULL,
  email VARCHAR NOT NULL,
  phone VARCHAR NOT NULL
);

CREATE TABLE users_bonifications (
  user_id VARCHAR NOT NULL REFERENCES users(dni) ON DELETE CASCADE,
  bonification_id INTEGER NOT NULL REFERENCES bonifications(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, bonification_id)
);

CREATE TABLE seats (
  id SERIAL UNIQUE,
  row INTEGER NOT NULL,
  col VARCHAR NOT NULL,
  price DECIMAL(7, 2) NOT NULL,
  flight_number INTEGER NOT NULL,
  airline_id INTEGER NOT NULL,
  user_id VARCHAR REFERENCES users(dni) ON DELETE SET NULL,
  luxury_type VARCHAR,
  user_info jsonb NOT NULL DEFAULT '{}'::jsonb,
  PRIMARY KEY (row, col, flight_number, airline_id),
  FOREIGN KEY (flight_number, airline_id) REFERENCES flights(flight_number, airline_id) ON DELETE CASCADE,
  FOREIGN KEY (luxury_type, airline_id) REFERENCES seat_luxury_fees(luxury_type, airline_id) ON DELETE SET NULL
);

CREATE TYPE payment_status AS ENUM ('pending', 'fulfilled', 'canceled');

CREATE TABLE bookings (
  id SERIAL UNIQUE,
  user_id VARCHAR NOT NULL REFERENCES users(dni) ON DELETE CASCADE,
  seat_id INTEGER NOT NULL REFERENCES seats(id) ON DELETE CASCADE,
  date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  payment_status payment_status NOT NULL DEFAULT 'pending',
  PRIMARY KEY (id, user_id, seat_id)
);

CREATE TABLE cargo (
  id SERIAL PRIMARY KEY,
  flight_number INTEGER NOT NULL,
  airline_id INTEGER NOT NULL,
  seat_id INTEGER NOT NULL REFERENCES seats(id) ON DELETE CASCADE,
  weight INTEGER,
  price DECIMAL(7,2),
  FOREIGN KEY (flight_number, airline_id) REFERENCES flights(flight_number, airline_id) ON DELETE CASCADE
);

CREATE TABLE cancelations (
  id SERIAL PRIMARY KEY,
  booking_id INTEGER NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
