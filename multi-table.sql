-- 1
SELECT s.name, s.surname, h.name
FROM student_hobby sh,
student s,
hobby h
WHERE s.id=sh.student_id AND sh.hobby_id=h.id

-- 2
SELECT s.* 
FROM student_hobby sh, student s
WHERE (sh.date_end - sh.date_start) = (SELECT MAX(sh.date_end - sh.date_start)
									   FROM student_hobby sh)
									   AND s.id=sh.student_id
LIMIT 1

-- 3
SELECT s.id, comm.name, comm.surname, comm.birthday, comm.comm_risk
FROM student s
INNER JOIN (SELECT s.id, s.name, s.surname, s.birthday, sh.date_end, SUM(h.risk) AS comm_risk
			FROM student s,
				student_hobby sh,
				hobby h
			WHERE s.id=sh.student_id AND h.id=sh.hobby_id AND sh.date_end IS NULL
			GROUP BY s.id, sh.date_end) comm on comm.id=s.id
WHERE s.score>(SELECT AVG(s.score)
			  FROM student s) AND comm.comm_risk>0.9

-- 4
SELECT  s.surname, s.name, s.birthday, h.name, 12 * extract(year from age(sh.date_end, sh.date_start))
FROM student s,
	hobby h,
	student_hobby sh
WHERE s.id=sh.student_id AND h.id=sh.hobby_id

-- 5
SELECT s.id, s.name, s.surname, s.birthday
FROM student s,
	 hobby h,
	 student_hobby sh
WHERE s.id=sh.student_id AND h.id=sh.hobby_id AND extract(year from age(s.birthday))>10
GROUP BY s.id

-- 6
SELECT s.n_group, AVG(s.score)
FROM student s
WHERE s.id IN (SELECT s.id
FROM student s,
	 hobby h,
	 student_hobby sh
WHERE s.id=sh.student_id AND h.id=sh.hobby_id 
GROUP BY s.id)
GROUP BY s.n_group

-- 7
SELECT s.id AS id_st, h.name, h.risk, comm.month_hobby
FROM student s,
	 hobby h,
	 student_hobby sh,
	(SELECT s.id AS s_id, h.id AS h_id, MAX(12 * extract(year from age(sh.date_start))) AS month_hobby
	FROM student s,
		 hobby h,
		 student_hobby sh
	WHERE s.id=sh.student_id AND h.id=sh.hobby_id AND sh.date_end IS NULL
	GROUP BY s.id, h.id
	ORDER BY month_hobby DESC
	LIMIT 1) comm
WHERE comm.s_id=s.id AND comm.h_id=h.id AND sh.student_id=s.id AND sh.hobby_id=h.id

-- 8
SELECT DISTINCT h.name
FROM student s,
	 hobby h,
	 student_hobby sh
WHERE s.id=sh.student_id AND h.id=sh.hobby_id AND sh.date_end IS NULL AND s.score=(SELECT MAX(score)
FROM student)

-- 9
SELECT h.name 
FROM student s,
	 hobby h,
	 student_hobby sh
WHERE s.id=sh.student_id AND h.id=sh.hobby_id AND sh.date_end IS NULL AND substr(s.n_group::varchar, 1, 1)='2'
AND s.score>=2.5 AND s.score<=3.5

-- 10
SELECT positive.course
FROM 
(SELECT DISTINCT substr(s.n_group::varchar, 1, 1) AS course, COUNT(DISTINCT s.id)
FROM student s,
	 hobby h,
	 student_hobby sh
WHERE s.id IN
(SELECT sh.student_id
FROM student_hobby sh
GROUP BY sh.student_id
HAVING COUNT(sh.student_id)>=2) AND s.id=sh.student_id AND h.id=sh.hobby_id
GROUP BY course) positive,
(SELECT course, COUNT(course) 
FROM (SELECT substr(s.n_group::varchar, 1, 1) AS course
	 FROM student s) comm
GROUP BY course) common
WHERE positive.course=common.course AND positive.count>=common.count*0.5

-- 11
SELECT positive.n_group
FROM
(SELECT s.n_group, COUNT(s.score)
FROM student s
WHERE s.score>4
GROUP BY s.n_group) positive,
(SELECT s.n_group, COUNT(s.id)
FROM student s
GROUP BY s.n_group) common
WHERE positive.n_group=common.n_group AND positive.count>common.count * 0.6

-- 12
SELECT DISTINCT substr(s.n_group::varchar, 1, 1) AS course, COUNT(DISTINCT h.name) AS hobbies
FROM student s,
hobby h,
student_hobby sh
WHERE s.id=sh.student_id AND h.id=sh.hobby_id AND sh.date_end IS NULL
GROUP BY course

-- 13
SELECT s.*
FROM student_hobby sh
RIGHT JOIN student s ON s.id = sh.student_id
WHERE sh.id IS NULL AND s.score >= 4.5

-- 14
CREATE OR REPLACE VIEW Students_V1 AS
SELECT DISTINCT s.*
FROM student s
LEFT JOIN student_hobby sh on s.id = sh.student_id
WHERE sh.date_finish IS NULL AND extract(year from age(now()::date, sh.date_start)) >= 5;

-- 15
SELECT h.name as hobby_name,
	   COUNT(s.id) as count_students
FROM 
	hobby h,
	student s,
	student_hobby sh
WHERE s.id = sh.student_id and h.id = sh.hobby_id
GROUP BY hobby_name;

-- 16
SELECT h.id
FROM 
	student_hobby sh
INNER JOIN hobby h on sh.hobby_id = h.id
GROUP BY h.id
ORDER BY count(1) DESC
LIMIT 1;

-- 17
SELECT s.*
FROM student_hobby sh
INNER JOIN student s on s.id = sh.student_id AND sh.hobby_id = 
(
	SELECT h.id
	FROM 
		student_hobby sh
	INNER JOIN hobby h on sh.hobby_id = h.id
	GROUP BY h.id
	ORDER BY count(1) DESC
	LIMIT 1
);

-- 18
SELECT id
FROM hobby
ORDER BY risk DESC
LIMIT 3;

-- 19
SELECT s.*
FROM student_hobby sh
INNER JOIN student s ON sh.student_id = s.id
WHERE sh.date_finish IS NULL 
GROUP BY s.id, sh.date_start
ORDER BY (now() - sh.date_start) DESC
LIMIT 10;

-- 20
SELECT DISTINCT s.n_group
FROM student s
WHERE s.n_group IN
(SELECT s.n_group
FROM student_hobby sh
INNER JOIN student s ON sh.student_id = s.id
WHERE sh.date_finish IS NULL 
GROUP BY s.id, sh.date_start
ORDER BY (now() - sh.date_start) DESC
LIMIT 10);

-- 21
CREATE OR REPLACE VIEW Student_data AS
SELECT s.id, s.name, s.surname
FROM student s
ORDER BY s.score DESC;

--23
CREATE OR REPLACE VIEW vo AS
SELECT hb.NAME, COUNT(*) popularity, hb.risk
FROM student st
RIGHT JOIN student_hobby sh ON sh.student_id = st.id
LEFT JOIN hobby hb ON hb.id = sh.hobby_id
WHERE st.n_group / 1000 = 2
GROUP BY hb.NAME, hb.risk
ORDER BY COUNT(*) DESC, hb.risk DESC
LIMIT 1;

--24
CREATE OR REPLACE VIEW newvwv AS
SELECT st.n_group / 1000 course, COUNT(*), 
CASE
    WHEN tb.Excellentst IS NULL THEN 0
    ELSE tb.Excellentst
END Excellentst 
FROM student st
LEFT JOIN (
    SELECT st.n_group, COUNT(*) Excellentst
    FROM student st
    WHERE st.score >= 4.5
    GROUP BY st.n_group
) tb ON tb.n_group = st.n_group
GROUP BY st.n_group / 1000, tb.Excellentst

--25
SELECT hb.name, COUNT(*) FROM student st
LEFT JOIN student_hobby sh ON st.id = sh.student_id
LEFT JOIN hobby hb ON hb.id = sh.hobby_id
WHERE hb.name IS NOT NULL
GROUP BY hb.name
ORDER BY COUNT(*)
DESC 
LIMIT 1;

--26
CREATE OR REPLACE VIEW updateveiw AS
SELECT * FROM student st
WITH CHECK OPTION;
--27
SELECT LEFT(st.name, 1), MAX(st.score), AVG(st.score), MIN(st.score)
FROM student st
GROUP BY LEFT(st.name, 1)
HAVING MAX(st.score) > 3.6

--28
SELECT st.n_group / 1000 AS course, st.surname,  MAX(st.score), MIN(score)
FROM student st
GROUP BY st.n_group / 1000, st.surname

--29
SELECT EXTRACT(YEAR FROM date_birth), COUNT(*)
FROM student st
LEFT JOIN student_hobby sh ON sh.student_id = st.id
WHERE sh.hobby_id IS NOT NULL
GROUP BY EXTRACT(YEAR FROM date_birth);

--30
SELECT regexp_split_to_table(st.name,''), MIN(hb.risk), MAX(hb.risk)
FROM student st
RIGHT JOIN student_hobby sh ON sh.student_id = st.id
LEFT JOIN hobby hb ON hb.id = sh.hobby_id
GROUP BY regexp_split_to_table(st.name,'');

--31
SELECT EXTRACT(MONTH FROM st.date_birth), AVG(st.score)
FROM student st
RIGHT JOIN student_hobby sh ON sh.student_id = st.id
LEFT JOIN hobby hb ON sh.hobby_id = hb.id
WHERE hb.name LIKE 'Футбол'
GROUP BY EXTRACT(MONTH FROM st.date_birth);

--32
SELECT st.name Имя, st.surname Фамилия, st.n_group Группа
FROM student st
RIGHT JOIN student_hobby sh ON sh.student_id = st.id
LEFT JOIN hobby hb ON sh.hobby_id = hb.id
GROUP BY st.id;

--33
SELECT 
CASE
	WHEN strpos(st.surname, 'ов') != 0 THEN strpos(st.surname, 'ов')::VARCHAR(255)
	ELSE 'Не найдено'
END
FROM student st;

--34
SELECT rpad(st.surname, 10, '#')
FROM student st;

--35
SELECT replace(st.surname, '#', '')
FROM student st;

--36
SELECT  
DATE_PART('days', DATE_TRUNC('month', '2018-04-01'::DATE) 
	+ '1 MONTH'::INTERVAL 
	- '1 DAY'::INTERVAL
) AS days;
--37
SELECT date_trunc('week', current_date)::date + 5 AS sat;

--38
SELECT 
EXTRACT(CENTURY FROM current_date),
EXTRACT(WEEK FROM current_date),
EXTRACT(DOY FROM current_date);