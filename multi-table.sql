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