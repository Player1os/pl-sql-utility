-- Compute the space currently occupied by the current user's tables.
SELECT /*+ PARALLEL(X) */
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
SELECT /*+ PARALLEL(X) */ DISTINCT
	object_name
FROM
	user_objects
WHERE
	object_type = 'TABLE'
;

-- List all columns of a given table visible to the current user.
SELECT /*+ PARALLEL(X) */
	column_name,
	(
		data_type
		|| DECODE(
			data_type,
			'NUMBER',
				CASE
					WHEN data_precision IS NULL THEN
						''
					ELSE
						'(' || data_precision || ')'
				END,
			'VARCHAR2', '(' || data_length || ')',
			data_precision || ', ' || data_length
			-- CHAR
			-- CLOB
			-- FLOAT
			-- LONG
			-- NCHAR
			-- RAW
			-- ROWID
			-- TIMESTAMP(3)
			-- TIMESTAMP(6)
			-- TIMESTAMP(6) WITH TIME ZONE
			-- TIMESTAMP(9)
			-- UNDEFINED
		)
		|| DECODE(
			nullable,
			'Y', ' ',
			' NOT '
		)
		|| 'NULLABLE'
	)
		AS data_type
FROM
	all_tab_columns
WHERE
	owner = '&owner'
	AND table_name = '&name'
ORDER BY
	column_id
;

-- List all tables and views visible to the current user with similar names.
WITH
	".objects" AS (
		(
			SELECT /*+ PARALLEL(X) */
				owner
					AS "owner",
				table_name
					AS "name"
			FROM
				all_tables
		) UNION ALL (
			SELECT /*+ PARALLEL(X) */
				owner
					AS "owner",
				view_name
					AS "name"
			FROM
				all_views
		)
	)
SELECT /*+ PARALLEL(X) */
	"owner",
	"name"
FROM
	".objects"
WHERE
	"owner" = '&owner'
	AND LOWER("name") LIKE LOWER('%&name%')
ORDER BY
	1,
	2
