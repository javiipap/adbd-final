DROP TRIGGER IF EXISTS update_flight_id ON flights;
DROP FUNCTION IF EXISTS update_flight_id();

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
