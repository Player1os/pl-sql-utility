-- Assuming we have a generic table, similar to this one:
/*

CREATE TABLE "table"
	NOLOGGING
	COMPRESS
(
	"key_1" NUMBER(38),
	"key_2" NUMBER(38),
	-- ...
	"key_n" NUMBER(38),
	"x_1" VARCHAR(256),
	"x_2" VARCHAR(256),
	-- ...
	"x_m" VARCHAR(256)
);

*/
-- With a constraint similar to this:
/*

ALTER TABLE "table"
	ADD CONSTRAINT ["table_pk" | "table_unq1"]
	[PRIMARY KEY | UNIQUE] (
		"key_1",
		"key_2",
		-- ...,
		"key_n"
	)
;

*/
-- The historified table will have the following definition:

CREATE TABLE "table_history"
	NOLOGGING
	COMPRESS
(
	"key_1" NUMBER(38),
	"key_2" NUMBER(38),
	-- ...
	"key_n" NUMBER(38),
	"x_1" VARCHAR(256),
	"x_2" VARCHAR(256),
	-- ...
	"x_m" VARCHAR(256),
	"start_datestamp" NUMBER(8) NOT NULL,
	"end_datestamp" NUMBER(8) NOT NULL
)
;

-- With the following indexes:

CREATE INDEX "table_history_idx1"
	ON "table_history" (
		"key_1",
		"key_2",
		-- ...
		"key_n"
	)
;

CREATE INDEX "table_history_idx2"
	ON "table_history" ("start_datestamp")
;

CREATE INDEX "table_history_idx3"
	ON "table_history" ("end_datestamp")
