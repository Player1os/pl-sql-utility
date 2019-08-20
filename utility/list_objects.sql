-- Compute the space currently occupied by the current user's tables.
SELECT /*+ PARALLEL USE_HASH */
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

-- List all tables within the current user's schema.
SELECT /*+ PARALLEL USE_HASH */ DISTINCT
	object_name
FROM
	user_objects
WHERE
	object_type = 'TABLE'
;

-- List all columns visible to the current user.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	all_tab_columns
;

-- List all tables visible to the current user.
SELECT /*+ PARALLEL USE_HASH */
	table_name
FROM
	all_tables
