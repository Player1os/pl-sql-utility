-- Assuming we have a generic table and have already created a historified table for it as described in the 'definition.sql' script.

-- Set the previous day's datestamp as the end_datestamp of every historified table record where:
-- - No record with matching key values is found in the generic table.
-- - A record with matching key values is found in the generic table with at least one mismatch in the rest of its values.

UPDATE
	"table_history" h
SET
	h."end_datestamp" = TO_CHAR(SYSDATE - 1, 'YYYYMMDD')
WHERE
	h."end_datestamp" IS NULL
	AND (
		NOT EXISTS (
			SELECT
				t.*
			FROM
				"table" t
			WHERE
				DECODE(t."key_1", h."key_1", 1, 0) = 1     -- t."key_1" = h."key_1" even if NULL
				AND DECODE(t."key_2", h."key_2", 1, 0) = 1 -- AND t."key_2" = h."key_2" even if NULL
				-- ...
				AND DECODE(t."key_n", h."key_n", 1, 0) = 1 -- AND t."key_n" = h."key_n" even if NULL
		)
		OR EXISTS (
			SELECT
				t.*
			FROM
				"table" t
			WHERE
				DECODE(t."key_1", h."key_1", 1, 0) = 1     -- t."key_1" = h."key_1" even if NULL
				AND DECODE(t."key_2", h."key_2", 1, 0) = 1 -- AND t."key_2" = h."key_2" even if NULL
				-- ...
				AND DECODE(t."key_n", h."key_n", 1, 0) = 1 -- AND t."key_n" = h."key_n" even if NULL
				AND NOT (
					DECODE(t."x_1", h."x_1", 1, 0) = 1     -- t."x_1" = h."x_1" even if NULL
					AND DECODE(t."x_2", h."x_2", 1, 0) = 1 -- AND t."x_2" = h."x_2" even if NULL
					-- ...
					AND DECODE(t."x_m", h."x_m", 1, 0) = 1 -- AND t."x_m" = h."x_m" even if NULL
				)
		)
	)
;

-- Insert a new record to the historified table with the current day's datestamp its start_datestamp for every generic table record where:
-- - No current (i.e. with NULL as the end_datestamp) record with matching key values is found in the historified table.
-- - A current (i.e. with NULL as the end_datestamp) record with matching key values is found in the historified table with at least one mismatch in the rest of its values.

INSERT INTO "table_history"
SELECT
	t.*,
	TO_CHAR(SYSDATE, 'YYYYMMDD'),
	NULL
FROM
	"table" t
	LEFT JOIN "table_history" h
		ON (
			h."end_datestamp" IS NULL
			AND DECODE(t."key_1", h."key_1", 1, 0) = 1 -- t."key_1" = h."key_1" even if NULL
			AND DECODE(t."key_2", h."key_2", 1, 0) = 1 -- AND t."key_2" = h."key_2" even if NULL
			-- ...
			AND DECODE(t."key_n", h."key_n", 1, 0) = 1 -- AND t."key_n" = h."key_n" even if NULL
		)
WHERE
	h."start_datestamp" IS NULL
	OR NOT (
		DECODE(t."x_1", h."x_1", 1, 0) = 1     -- t."x_1" = h."x_1" even if NULL
		AND DECODE(t."x_2", h."x_2", 1, 0) = 1 -- AND t."x_2" = h."x_2" even if NULL
		-- ...
		AND DECODE(t."x_m", h."x_m", 1, 0) = 1 -- AND t."x_m" = h."x_m" even if NULL
	)
;

-- The case when a full match between all values (key and otherwise) is found in the generic table and the historified table requires no action.
