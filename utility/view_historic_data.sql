-- View data from a historic version of a table.
SELECT /*+ PARALLEL X USE_HASH */
	*
FROM
	"&table_name"
AS OF
	TIMESTAMP(SYSDATE() - &offset)
