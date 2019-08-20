-- Create a table.
CREATE TABLE "table_1"
	NOLOGGING
	PCTFREE 0 -- Use only if the table in question will be read-only and will not be updated with new values.
	COMPRESS -- May be contraproductive if the data size cannot be significantly reduced.
(
	"column_1" CHAR(1 BYTE) NOT NULL, -- Boolean.
	"column_2" NUMBER(8) NOT NULL, -- Integer.
	"column_3" NUMBER(8, 4) NOT NULL, -- Decimal.
	"column_4" DOUBLE PRECISION NOT NULL, -- Float.
	-- ...
	"column_n" VARCHAR2(256) -- String.
)
;

-- Create a table from a select query.
CREATE TABLE "table_1"
	NOLOGGING
	PCTFREE 0 -- Use only if the table in question will be read-only and will not be updated with new values.
	COMPRESS -- May be contraproductive if the data size cannot be significantly reduced.
	PARALLEL
AS (
	SELECT -- ...
)
;

-- Create a primary key constraint.
ALTER TABLE "table_1"
	ADD CONSTRAINT "table_1_pk"
	PRIMARY KEY (
		"column_1",
		-- ...
		"column_n"
	)
;

-- Create a foreign key constraint.
ALTER TABLE "table_1"
	ADD CONSTRAINT "table_1_fk1"
	FOREIGN KEY (
		"column_1",
		-- ...
		"column_n"
	)
	REFERENCES "table_2" (
		"column_1",
		-- ...
		"column_n"
	)
;

-- Create a unique constraint.
ALTER TABLE "table"
	ADD CONSTRAINT "table_unq1"
	UNIQUE (
		"column_1",
		-- ...
		"column_n"
	)
;

-- Create an index.
CREATE INDEX "table_1_idx1"
	ON "table_1" (
		"column_1",
		-- ...
		"column_n"
	)
;

-- Drop an index.
-- It is less expensive to drop the index before and rebuild it after a large batch operation that alters the table's contents.
DROP INDEX "table_1_idx1"
;

-- Load data from a table.
SELECT /*+ PARALLEL USE_HASH */ DISTINCT -- The Distinct clasue is, of course, optional.
	*
FROM
	"table_1"
;

-- Insert data into a table from select.
-- Use the APPEND hint only on tables whose rows are only incremented and are not deleted.
INSERT /*+ APPEND */ INTO "table_1e" ( -- Optional if a subset of the columns is to be filled.
	"column_1",
	-- ...
	"column_n"
)
VALUES (
	"value_1",
	-- ...
	"value_n"
)
;

-- Insert data into a table from a select query.
-- Use the APPEND hint only on tables whose rows are only incremented and are not deleted.
INSERT /*+ APPEND */ INTO "table_1"
(
	SELECT -- ...
)
;

-- Empty a table's contents.
TRUNCATE TABLE "table_1"
;

-- Drop a table.
DROP TABLE "table_1" PURGE
