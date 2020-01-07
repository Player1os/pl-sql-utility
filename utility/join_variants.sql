-- Initialization.
CREATE TABLE a (x NUMBER)
;
INSERT INTO a VALUES (1)
;
INSERT INTO a VALUES (2)
;
CREATE TABLE b (x NUMBER)
;
INSERT INTO b VALUES (1)
;
INSERT INTO b VALUES (3)
;

-- Cross join: result.
-- 1, 1
-- 1, 3
-- 2, 1
-- 2, 3

-- Cross join: standard variant.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	a
	CROSS JOIN b
;

-- Cross join: oracle variant.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	a,
	b
;

-- Full join: result.
-- 1, 1
-- NULL, 3
-- 2, NULL

-- Full join: standard variant.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	a
	FULL JOIN b
		ON a.x = b.x
;

-- Full join: oracle variant.
(
	SELECT /*+ PARALLEL USE_HASH */
		*
	FROM
		a,
		b
	WHERE
		a.x (+) = b.x
) UNION (
	SELECT /*+ PARALLEL USE_HASH */
		*
	FROM
		a,
		b
	WHERE
		a.x = b.x (+)
)
;

-- Left join: result.
-- 1, 1
-- 2, NULL

-- Left join: standard variant.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	a
	LEFT JOIN b
		ON a.x = b.x
;

-- Left join: oracle variant.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	a,
	b
WHERE
	a.x = b.x (+)
;

-- Right join: result.
-- 1, 1
-- NULL, 3

-- Right join: standard variant.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	a
	RIGHT JOIN b
		ON a.x = b.x
;

-- Right join: oracle variant.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	a,
	b
WHERE
	a.x (+) = b.x
;

-- Join: result.
-- 1, 1

-- Right join: standard variant.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	a
	JOIN b
		ON a.x = b.x
;

-- Right join: oracle variant.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	a,
	b
WHERE
	a.x = b.x
;

-- Termination.
DROP TABLE a PURGE
;
DROP TABLE b PURGE
