-- View data from a historic version of the table.
SELECT
	*
FROM
	${TABLE_NAME}
AS OF
	TIMESTAMP(SYSDATE() - ${TIME_OFFSET})
;
