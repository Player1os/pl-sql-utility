-- Assuming we have a generic table and have already created a historified table for it as described in the `definition.sql` script
-- and that the &datestamp parameter contains the datestamp we wish to view:

SELECT /*+ PARALLEL USE_HASH */
	h.*,
	h.rowid
FROM
	"table_history" h
WHERE
	&datestamp
		BETWEEN h."start_datestamp"
		AND h."end_datestamp"
;
