DROP TRIGGER IF EXISTS update_flight_id ON flights;
DROP FUNCTION IF EXISTS update_flight_id();

DROP TRIGGER IF EXISTS trigger_seat_price ON seats;
DROP FUNCTION IF EXISTS seat_price();

DROP TRIGGER IF EXISTS trigger_cargo_price ON cargo;
DROP FUNCTION IF EXISTS cargo_price();

CREATE OR REPLACE FUNCTION update_flight_id()
  RETURNS trigger AS $update_flight_id$
  BEGIN
    NEW.id = (SELECT icao FROM airlines WHERE id = NEW.airline_id) || NEW.flight_number;
    RETURN NEW;
  END;
  $update_flight_id$
  LANGUAGE plpgsql;

CREATE TRIGGER update_flight_id
  BEFORE INSERT ON flights
  FOR EACH ROW
  EXECUTE PROCEDURE update_flight_id();

CREATE OR REPLACE FUNCTION seat_price()
RETURNS TRIGGER AS $$
DECLARE 
price DECIMAL(7, 2) := 0.0;
BEGIN
  price := (SELECT base_price FROM flights WHERE (NEW.flight_number = flight_number AND NEW.airline_id = airline_id));
  price := price + (SELECT fee FROM seat_luxury_fees WHERE (NEW.luxury_type = luxury_type AND NEW.airline_id = airline_id));
  NEW.price = price;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_seat_price
BEFORE INSERT OR UPDATE ON seats
FOR EACH ROW EXECUTE FUNCTION seat_price();

CREATE OR REPLACE FUNCTION cargo_price()
RETURNS TRIGGER AS $$
DECLARE 
cargo_weight DECIMAL(7, 2) := 0.0;
BEGIN
	cargo_weight := (SELECT MIN(weight) FROM luggage_fees WHERE (weight >= NEW.weight AND NEW.airline_id = airline_id));
	NEW.price := (SELECT fee FROM luggage_fees WHERE (weight = cargo_weight AND NEW.airline_id = airline_id));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_cargo_price
BEFORE INSERT OR UPDATE ON cargo
FOR EACH ROW EXECUTE FUNCTION cargo_price();
