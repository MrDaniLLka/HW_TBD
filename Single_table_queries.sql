-- 1
SELECT * FROM student
WHERE score >= 4 AND score <=4.5;

SELECT * FROM student WHERE score BETWEEN 4 AND 4.5;

-- 2
SELECT *
FROM student
WHERE n_group::varchar LIKE '2%';

-- 3
SELECT *
FROM student
ORDER BY n_group DESC, name  ASC;

-- 4
SELECT *
FROM student
WHERE score > 4
ORDER BY score DESC;

-- 5
SELECT name, risk
FROM hobby
WHERE name = 'танцы' OR name = 'бег';

-- 6 
SELECT student_id, hobby_id
FROM student_hobby
WHERE date_end < NOW();

-- 7
SELECT *
FROM student
WHERE score >= 4.5
ORDER BY score DESC;

-- 8 
SELECT *
FROM student
WHERE score >= 4.5
ORDER BY score DESC
LIMIT 5;

-- 9 
SELECT
CASE 
WHEN risk>=0.8 THEN 'очень высокий'
WHEN risk>=0.6 AND risk<=0.8 THEN 'высокий'
WHEN risk>=0.4 AND risk<=0.6 THEN 'средний'
WHEN risk>=0.2 AND risk<=0.4 THEN 'низкий'
WHEN risk<0.2 THEN 'очень низкий'
END
FROM hobby;