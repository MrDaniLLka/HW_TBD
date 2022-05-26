-- create

CREATE TABLE client(
	id SERIAL PRIMARY KEY,
	name varchar(255) NOT NULL,
	surname varchar(255) NOT NULL,
	pasword varchar(255) NOT NULL,
	personal_data varchar(255) NOT NULL,
	admin BOOLEAN DEFAULT FALSE
);

CREATE TABLE ticket(
	id SERIAL PRIMARY KEY,
	name varchar(255) NOT NULL,
	description varchar(255) NOT NULL,
	low_price real NOT NULL,
	high_price real NOT NULL,
	time timestamp  NOT NULL,
	industry varchar(255) NOT NULL,
	company varchar(255) NOT NULL,
	marketCap real NOT NULL,
	income real NOT NULL
);

CREATE TABLE client_ticket(
	id SERIAL PRIMARY KEY,
	id_user INT NOT NULL REFERENCES client(id),
	id_ticket INT NOT NULL REFERENCES ticket(id),
	count INT NOT NULL
);

CREATE TABLE history_client(
	id SERIAL PRIMARY KEY,
	id_user INT NOT NULL REFERENCES client(id),
	id_ticket INT NOT NULL REFERENCES ticket(id),
	count INT NOT NULL,
	price real NOT NULL,
	commission real NOT NULL,
	time timestamp  NOT NULL,
	sell BOOLEAN,
	status INT,
	CHECK (status >= -1 AND status <= 1)
);

-- requests

--  Добавление нового тикера с информацией, к какой отрасли относится
INSERT INTO ticket VALUES
    ('name', 'description', 105, 106, '1999-01-08 04:05:06', 'Films', 'Picture', 100, 21);

--  Просмотр тикера и информации о компании, а также показатели и отчёты.
SELECT description, company, marketCap, income, industry FROM ticket


-- Поиск компании по заданным показателям, цифрам из отчёта с пагинацией и сортировкой по атрибутам
SELECT name, description, company  FROM ticket
WHERE industry='Films' 

SELECT name, description, company FROM ticket
ORDER BY income ASC

SELECT name, description, company FROM ticket 
ORDER BY marketCap ASC

SELECT name, description, company FROM ticket 
ORDER BY low_price ASC
LIMIT 1

SELECT name, description, company FROM ticket 
ORDER BY low_price ASC

SELECT name, description, company  FROM ticket 
ORDER BY high_price ASC
LIMIT 1

SELECT name, description, company FROM ticket 
ORDER BY high_price ASC



-- портфель
SELECT t.name, count FROM client_ticket AS ct
JOIN ticket AS t ON ct.id_ticket = t.id 
JOIN client AS c ON ct.id_ticket = c.id 

--  Просмотр своих сделок
SELECT t.name, count, price, commission, hc.time, status FROM history_client AS hc
JOIN ticket AS t ON hc.id_ticket = t.id
WHERE hc.time BETWEEN '1999-01-08 04:05:06' AND '2000-01-08 04:05:06'

SELECT t.name, count, price, commission, hc.time, status  FROM history_client AS hc
JOIN ticket AS t ON hc.id_ticket = t.id
WHERE t.name = 'APPL'

