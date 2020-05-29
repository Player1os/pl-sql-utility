-- Count the number of rows of a given object.
SELECT /*+ PARALLEL(X) */
	COUNT(*)
		AS row_count
FROM
	"&object_name"
;

-- List the total number of distinct values of a given column of a given object.
SELECT /*+ PARALLEL(X) */
	(
		COUNT(DISTINCT "&column_name")
		+ COUNT(DISTINCT CASE WHEN "&column_name" IS NULL THEN 1 END)
	)
		AS distinct_value_count
FROM
	"&object_name"
;

-- List the distinct values of a given column of a given object sorted in descening order of frequency.
SELECT /*+ PARALLEL(X) */
	COUNT(*)
		AS row_count,
	"&column_name"
FROM
	"&object_name"
GROUP BY
	"&column_name"
ORDER BY
	1 DESC
