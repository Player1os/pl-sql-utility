-- View data from a historic version of a table.
SELECT
	*
FROM
	&table_name
AS OF
	TIMESTAMP(SYSDATE() - &offset)
;
