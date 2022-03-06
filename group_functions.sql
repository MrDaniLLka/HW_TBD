-- 1
SELECT n_group, COUNT(n_group)
FROM student
GROUP BY n_group;

-- 2
SELECT n_group, MAX(score), AVG(score)
FROM student
GROUP BY n_group;

-- 3
SELECT surname, COUNT(surname)
FROM student
GROUP BY surname;

-- 4
SELECT EXTRACT(YEAR FROM student.birthday), COUNT(EXTRACT(YEAR FROM student.birthday))
FROM student
GROUP BY EXTRACT(YEAR FROM student.birthday);

-- 5
SELECT substr(student.n_group::varchar, 1, 1) AS course, AVG(score)
FROM student
GROUP BY course;

-- 6
SELECT n_group
FROM student
WHERE substr(student.n_group::varchar, 1, 1)='2'
GROUP BY n_group
ORDER BY MAX(score) DESC
LIMIT 1;

-- 7
SELECT substr(student.n_group::varchar, 1, 1) AS course, AVG(score)
FROM student
GROUP BY course
HAVING AVG(score) <= 3.5
ORDER BY AVG(score);

-- 8
SELECT n_group, COUNT(n_group), MAX(score), AVG(score), MIN(score)
FROM student
GROUP BY n_group;

-- 9 
SELECT *
FROM student
WHERE n_group='1181' AND score=(SELECT MAX(score)
				FROM student
				WHERE n_group='1181');

-- 10
SELECT *
FROM student
WHERE (n_group, score) IN
	(SELECT n_group, MAX(score)
	FROM
		student
	GROUP BY n_group);


