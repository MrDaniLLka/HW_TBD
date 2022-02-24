CREATE TABLE student(
	id SERIAL PRIMARY KEY,
	name varchar(255) NOT NULL,
	surname varchar(255),
	address varchar(255),
	score REAL CHECK (score >=2 AND  score<=5),
	n_group INT CHECK (n_group>=1000 AND n_group<=9999)
);

CREATE TABLE hobby(
	id SERIAL PRIMARY KEY,
	name varchar(255) NOT NULL,
	risk NUMERIC(3, 2) NOT NULL
);

CREATE TABLE student_hobby(
	id SERIAL PRIMARY KEY,
	student_id INT NOT NULL REFERENCES student(id),
	hobby_id INT NOT NULL REFERENCES hobby(id),
	date_start TIMESTAMP NOT NULL,
	date_end DATE
);


INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (5, 1, '2010-01-07 12:03:59', '2011-03-13');
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (2, 2, '2019-01-05 12:12:59', '2021-02-12');
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (4, 4, '2015-08-08 09:14:59', null);
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (5, 2, '2017-12-12 14:32:59', null);
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (15, 1, '2018-06-05 12:14:59', null);
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (10, 2, '2018-03-04 14:14:59', '2008-11-01');
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (10, 3, '2019-03-05 11:11:59', '2019-9-03');
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (8, 2, '2020-03-11 13:13:59', null);
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (2, 3, '2022-12-01 12:14:59', null);
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (3, 2, '2012-01-01 12:15:59', '2022-12-12');
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (3, 1, '2012-01-01 12:15:59', '2022-12-12');
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (3, 4, '2011-12-12 10:14:59', '2012-02-01');

INSERT INTO hobby (name, risk) VALUES ('танцы', 0.4);
INSERT INTO hobby (name, risk) VALUES ('бег', 0.6);
INSERT INTO hobby (name, risk) VALUES ('спортивное-программирование', 0.1);
INSERT INTO hobby (name, risk) VALUES ('дайвинг', 0.8);


INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (5, 1, '07-01-2010 12:03:59', '13-03-2011'
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (2, 2, '05-01-2019 12:12:59', '12-02-2021');
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (4, 4, '08-08-2015 09:14:59', null);
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (5, 2, '12-12-2017 14:32:59', null);
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (15, 1, '05-06-2018 12:14:59', null);
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (10, 2, '03-04-2018 14:14:59', '15-01-2008');
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (10, 3, '03-05-2019 11:11:59', '15-03-2019');
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (8, 2, '03-11-2020 13:13:59', null);
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (2, 3, '12-01-2022 12:14:59', null);
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (3, 2, '01-01-2012 12:15:59', '12-12-2022');
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (3, 1, '01-01-2012 12:15:59', '12-12-2022');
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_end) VALUES (3, 4, '12-12-2011 10:14:59', '02-01-2012');
