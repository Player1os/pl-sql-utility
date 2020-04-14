-- Create a table.
CREATE TABLE "&table_name" (
	"&column_name_1" CHAR(1 BYTE) NOT NULL, -- Boolean.
	"&column_name_2" NUMBER(8) NOT NULL, -- Integer.
	"&column_name_3" NUMBER(8, 4) NOT NULL, -- Decimal.
	"&column_name_4" DOUBLE PRECISION NOT NULL, -- Float.
	-- ...
	"&column_name_N" VARCHAR2(256) -- String.
)
	NOLOGGING
	COMPRESS -- May be contraproductive if the data size cannot be significantly reduced.
;

-- Create a table from a select query.
CREATE TABLE "&table_name"
	NOLOGGING
	PCTFREE 0 -- Use only if the table in question will be read-only and will not be updated with new values.
	COMPRESS -- May be contraproductive if the data size cannot be significantly reduced.
	PARALLEL
AS
	SELECT -- ...
;

-- Create a primary key constraint.
ALTER TABLE "&table_name"
	ADD CONSTRAINT "&primary_key_name" -- pk suffix
	PRIMARY KEY (
		"&column_name_1",
		-- ...
		"&column_name_N"
	)
;

-- Create a foreign key constraint.
ALTER TABLE "&primary_table_name"
	ADD CONSTRAINT "&foreign_key_constraint_name" -- fkM suffix
	FOREIGN KEY (
		"&column_name_1",
		-- ...
		"&column_name_N"
	)
	REFERENCES "&secondary_table_name" (
		"&column_name_1",
		-- ...
		"&column_name_N"
	)
;

-- Create a unique constraint.
ALTER TABLE "&table_name"
	ADD CONSTRAINT "&unique_constraint_name" -- unqM suffix
	UNIQUE (
		"&column_name_1",
		-- ...
		"&column_name_N"
	)
;

-- Create an index.
CREATE INDEX "index_name" -- idxM suffix
	ON "&table_name" (
		"&column_name_1",
		-- ...
		"&column_name_N"
	)
;

-- Drop an index.
-- It is less expensive to drop the index before and rebuild it after a large batch operation that alters the table's contents.
DROP INDEX "&table_index_name" -- idxM suffix
;

-- Load data from a table.
SELECT /*+ PARALLEL USE_HASH */ DISTINCT -- The Distinct clasue is, of course, optional.
	*
FROM
	"&table_name"
;

-- Load data from a table with subqueries.
WITH
	".&subquery_name_1" AS (
		SELECT -- ...
	),
	-- ...
	".&subquery_name_N" AS (
		SELECT -- ...
	)
SELECT -- ...
;

-- Insert data into a table.
-- Use the APPEND hint only on tables whose rows are only incremented and are not deleted.
INSERT /*+ APPEND */ INTO "&table_name" ( -- Optional if a subset of the columns is to be filled.
	"&column_name_1",
	-- ...
	"&column_name_N"
)
VALUES (
	"&value_1",
	-- ...
	"&value_N"
)
;

-- Insert data into a table from a select query.
-- Use the APPEND hint only on tables whose rows are only incremented and are not deleted.
INSERT /*+ APPEND */ INTO "&table_name"
	SELECT -- ...
;

-- Update data in a table.
UPDATE "&table_name"
SET
	"&column_name_1" = 'value_1',
	-- ...
	"&column_name_N" = 'value_N'
WHERE
	-- ...
;

DELETE FROM "&table_name"
WHERE
	-- ...
;

-- Empty a table's contents.
TRUNCATE TABLE "&table_name"
;

-- Drop a table.
DROP TABLE "&table_name" PURGE
