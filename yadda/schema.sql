DROP SCHEMA IF EXISTS yadda CASCADE;

CREATE SCHEMA yadda;
  CREATE TABLE yadda.breweries (
    brewery_id SERIAL PRIMARY KEY,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    name varchar(40) NOT NULL, 
    address text, 
    description text, 
    year integer
  );
  CREATE TABLE yadda.styles (
    style_id SERIAL PRIMARY KEY,
    name varchar(40) NOT NULL
  );
  CREATE TABLE yadda.beers (
    beer_id SERIAL PRIMARY KEY,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    name varchar(40) NOT NULL, 
    description text, 
    year integer,
    style_id integer REFERENCES yadda.styles(style_id),
    brewery_id integer REFERENCES yadda.breweries(brewery_id)
  );
  CREATE TABLE yadda.users (
    user_id SERIAL PRIMARY KEY,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    name varchar(40) NOT NULL
  );
  CREATE TABLE yadda.ratings (
    rating_id SERIAL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    score integer NOT NULL,
    beer_id integer REFERENCES yadda.beers(beer_id),
    user_id integer REFERENCES yadda.users(user_id)
  );

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_beers_modtime BEFORE UPDATE
  ON yadda.beers FOR EACH ROW EXECUTE PROCEDURE
  update_updated_at_column();
CREATE TRIGGER update_breweries_modtime BEFORE UPDATE
  ON yadda.breweries FOR EACH ROW EXECUTE PROCEDURE
  update_updated_at_column();
CREATE TRIGGER update_users_modtime BEFORE UPDATE
  ON yadda.users FOR EACH ROW EXECUTE PROCEDURE
  update_updated_at_column();
CREATE TRIGGER update_ratings_modtime BEFORE UPDATE
  ON yadda.ratings FOR EACH ROW EXECUTE PROCEDURE
  update_updated_at_column();
