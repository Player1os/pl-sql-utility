-- Compute the space currently occupied by the current user's tables.
SELECT
	tablespace_name,
	segment_name
		AS table_name,
	SUM(bytes) / (1024 * 1024)
		AS table_size_mb
FROM
	user_extents
WHERE
	segment_type = 'TABLE'
	AND segment_name LIKE '%'
GROUP BY
	tablespace_name,
	segment_name
ORDER BY
	3 DESC
;
