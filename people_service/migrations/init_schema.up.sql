BEGIN;

CREATE TABLE people (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO people (name) VALUES ('Danila'), ('Dan'), ('Dmitry');

COMMIT;
