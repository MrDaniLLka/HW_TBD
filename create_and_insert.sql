CREATE TABLE student(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	surname VARCHAR(255),
	address VARCHAR(255),
	num_group INT,
	score REAL
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


INSERT INTO student (name, surname, address, n_group, score) VALUES ('Владислав', 'Березуцкий', 'Москва', 5412, 3.3);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Иван', 'Брагин', 'Москва', 2241, 4.4);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Степан', 'Мельник', 'Кимры', 1181, 3.3);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Иван', 'Дуров', 'Кимры', 1221, 4.8);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Дмитрий', 'Сидоров', 'Удачный', 2155, 4.1);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Марина', 'Михалева', 'Кимры', 5215, 3.0);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Виктор', 'Авксеньтьев', 'Одесса', 3132, 3.1);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Михаил', 'Круг', 'Дубна', 3412, 3.5);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Дмитрий', 'Мирская', 'Дубна', 1525, 3.9);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Вера', 'Штатская', 'Дубна', 1283, 4.1);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Данила', 'Мякотин', 'Дубна', 3472, 3.5);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Александра', 'Солидная', 'Москва', 3273, 2.2);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Евгений', 'Олегов', 'Москва', 1372, 3.9);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Андрей', 'Дъяконов', 'Москва', 2363, 5.7);
INSERT INTO student (name, surname, address, n_group, score) VALUES ('Андрей', 'Смирнов', 'Дубна', 2384, 5.3);


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
