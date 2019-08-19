-- Create a table.
CREATE TABLE &table_name
	NOLOGGING
	PCTFREE 0 -- Use only if the table in question will be read-only and will not be updated with new values.
	COMPRESS -- May be contraproductive if the data size cannot be significantly reduced.
	PARALLEL -- Use only if the table in question will be created from a select.
AS (
	-- ...
)
;

-- Load data from a table.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	&table_name
;

-- Insert data into a table.
-- Use the APPEND hint only on tables whose rows are only incremented and are not deleted.
INSERT /*+ APPEND */ INTO &table_name
-- ...
;

-- Empty a table's contents.
TRUNCATE TABLE &table_name;

-- Drop a table.
DROP TABLE &table_name PURGE;
