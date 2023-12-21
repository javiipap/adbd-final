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
  price := (SELECT COALESCE(base_price, 0) FROM flights WHERE (flight_number = NEW.flight_number AND airline_id = NEW.airline_id));
  price := price + (SELECT COALESCE((SELECT fee FROM seat_luxury_fees WHERE (luxury_type = NEW.luxury_type AND airline_id = NEW.airline_id)), 0));
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
	NEW.price := (SELECT COALESCE((SELECT fee FROM luggage_fees WHERE (weight = cargo_weight AND NEW.airline_id = airline_id)), 0));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_cargo_price
BEFORE INSERT OR UPDATE ON cargo
FOR EACH ROW EXECUTE FUNCTION cargo_price();


CREATE OR REPLACE FUNCTION calculate_booking_price(booking_id INTEGER)
RETURNS DECIMAL(7, 2) AS $$
DECLARE
  price DECIMAL(7, 2) := 0.0;
BEGIN
  price := (SELECT seats.price FROM seats
            INNER JOIN bookings ON bookings.seat_id = seats.id
            WHERE bookings.id = booking_id);
  price := price + (SELECT SUM(cargo.price) 
                    FROM cargo
                    INNER JOIN seats ON seats.id = cargo.seat_id
                    INNER JOIN bookings ON bookings.seat_id = seats.id
                    WHERE bookings.id = booking_id);
  RETURN price;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_discounted_booking_price(booking_id INTEGER)
RETURNS DECIMAL(7, 2) AS $$
DECLARE
  price DECIMAL(7, 2) := 0.0;
  userr VARCHAR := 0;
BEGIN
  userr := (SELECT bookings.user_id FROM bookings WHERE id = booking_id LIMIT 1);
  price := (SELECT "calculate_booking_price"(booking_id));
  price := price - (SELECT COALESCE(SUM(value), 0)
                    FROM bonifications
                    INNER JOIN users_bonifications ON bonifications.id = users_bonifications.bonification_id
                    AND users_bonifications.user_id = userr
                    WHERE bonifications.type = 'fixed');
  price := price - (SELECT COALESCE(SUM(price * (bonifications.value / 100.0)), 0)
                    FROM bonifications
                    INNER JOIN users_bonifications ON bonifications.id = users_bonifications.bonification_id
                    AND users_bonifications.user_id = userr
                    WHERE bonifications.type = 'percent');
  RETURN price;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION remove_luggage()
RETURNS TRIGGER AS $$
BEGIN
  DELETE FROM cargo WHERE seat_id = OLD.seat_id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER remove_luggage
AFTER DELETE ON bookings
FOR EACH ROW EXECUTE PROCEDURE remove_luggage();

CREATE OR REPLACE FUNCTION prevent_luggage_overload()
RETURNS TRIGGER AS $$
DECLARE
  cargo_weight INTEGER := 0;
  _max_cargo_load INTEGER := 0;
BEGIN
  cargo_weight := (SELECT COALESCE(SUM(weight), 0) FROM cargo WHERE seat_id = NEW.seat_id);
  _max_cargo_load := (SELECT max_cargo_load FROM flights
                      WHERE flight_number = (SELECT flight_number FROM seats WHERE id = NEW.seat_id)
                      AND airline_id = (SELECT airline_id FROM seats WHERE id = NEW.seat_id));
  IF (cargo_weight + NEW.weight) > _max_cargo_load THEN
    RAISE EXCEPTION 'Cargo overload';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_luggage_overload
BEFORE INSERT ON cargo
FOR EACH ROW EXECUTE FUNCTION prevent_luggage_overload();

CREATE OR REPLACE FUNCTION prevent_luggage_on_unbooked_seat()
RETURNS TRIGGER AS $$
DECLARE
  booked BOOLEAN := FALSE;
BEGIN
  booked := (SELECT EXISTS(SELECT * FROM bookings WHERE seat_id = NEW.seat_id));
  IF booked = FALSE THEN
    RAISE EXCEPTION 'Cannot add luggage to unbooked seat';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_luggage_on_unbooked_seat
BEFORE INSERT ON cargo
FOR EACH ROW EXECUTE FUNCTION prevent_luggage_on_unbooked_seat();

CREATE OR REPLACE FUNCTION set_cancelation_info()
RETURNS TRIGGER AS $$
BEGIN
  NEW.seat_id = (SELECT seat_id FROM bookings WHERE id = NEW.booking_id LIMIT 1);
  NEW.user_id = (SELECT user_id FROM bookings WHERE id = NEW.booking_id LIMIT 1);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_cancelation_info
BEFORE INSERT ON cancelations
FOR EACH ROW EXECUTE FUNCTION set_cancelation_info();
