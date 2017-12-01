-- List all tables within the current user's schema.
SELECT DISTINCT
	object_name
FROM
	user_objects
WHERE
	object_type = 'TABLE'
;
