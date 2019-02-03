-- Assuming we have a generic table and have already created a historified table for it as described in the 'definition.sql' script
-- and that the &1 parameter contains the datestamp we wish to view:

SELECT
	h.*,
	h.rowid
FROM
	"table_history" h
WHERE
	&1 BETWEEN h."start_datestamp" AND h."end_datestamp"
;
