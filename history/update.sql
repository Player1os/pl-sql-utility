-- Assuming we have a generic table and have already created a historified table for it as described in the 'definition.sql' script.

-- Set the previous day's datestamp as the end_datestamp of every historified table record where:
-- - No record with matching key values is found in the generic table.
-- - A record with matching key values is found in the generic table with at least one mismatch in the rest of its values.

UPDATE
	"table_history" h
SET
	h."end_datestamp" = TO_CHAR(SYSDATE - 1, 'YYYYMMDD')
WHERE
	h."end_datestamp" = 99991231
	AND (
		NOT EXISTS (
			SELECT /*+ PARALLEL USE_HASH */
				t.*
			FROM
				"table" t
			WHERE
				(
					(t."key_1" = h."key_1")
					OR (
						(t."key_1" IS NULL)
						AND (h."key_1" IS NULL)
					)
				)
				AND (
					(t."key_2" = h."key_2")
					OR (
						(t."key_2" IS NULL)
						AND (h."key_2" IS NULL)
					)
				)
				-- ...
				AND (
					(t."key_n" = h."key_n")
					OR (
						(t."key_n" IS NULL)
						AND (h."key_n" IS NULL)
					)
				)
		)
		OR EXISTS (
			SELECT /*+ PARALLEL USE_HASH */
				t.*
			FROM
				"table" t
			WHERE
				(
					(t."key_1" = h."key_1")
					OR (
						(t."key_1" IS NULL)
						AND (h."key_1" IS NULL)
					)
				)
				AND (
					(t."key_2" = h."key_2")
					OR (
						(t."key_2" IS NULL)
						AND (h."key_2" IS NULL)
					)
				)
				-- ...
				AND (
					(t."key_n" = h."key_n")
					OR (
						(t."key_n" IS NULL)
						AND (h."key_n" IS NULL)
					)
				)
				AND NOT (
					(
						(t."x_1" = h."x_1")
						OR (
							(t."x_1" IS NULL)
							AND (h."x_1" IS NULL)
						)
					)
					AND (
						(t."x_2" = h."x_2")
						OR (
							(t."x_2" IS NULL)
							AND (h."x_2" IS NULL)
						)
					)
					-- ...
					AND (
						(t."x_m" = h."x_m")
						OR (
							(t."x_m" IS NULL)
							AND (h."x_m" IS NULL)
						)
					)
				)
		)
	)
;

-- Insert a new record to the historified table with the current day's datestamp its start_datestamp for every generic table record where:
-- - No current (i.e. with a default max value as the end_datestamp) record with matching key values is found in the historified table.
-- - A current (i.e. with a default max value as the end_datestamp) record with matching key values is found in the historified table with at least one mismatch in the rest of its values.

INSERT /*+ APPEND */ INTO "table_history"
SELECT /*+ PARALLEL USE_HASH */
	t.*,
	TO_CHAR(SYSDATE, 'YYYYMMDD'),
	99991231
FROM
	"table" t
	LEFT JOIN "table_history" h
		ON (
			h."end_datestamp" = 99991231
			AND (
				(t."key_1" = h."key_1")
				OR (
					(t."key_1" IS NULL)
					AND (h."key_1" IS NULL)
				)
			)
			AND (
				(t."key_2" = h."key_2")
				OR (
					(t."key_2" IS NULL)
					AND (h."key_2" IS NULL)
				)
			)
			-- ...
			AND (
				(t."key_n" = h."key_n")
				OR (
					(t."key_n" IS NULL)
					AND (h."key_n" IS NULL)
				)
			)
		)
WHERE
	h."start_datestamp" IS NULL
	OR NOT (
		(
			(t."x_1" = h."x_1")
			OR (
				(t."x_1" IS NULL)
				AND (h."x_1" IS NULL)
			)
		)
		AND (
			(t."x_2" = h."x_2")
			OR (
				(t."x_2" IS NULL)
				AND (h."x_2" IS NULL)
			)
		)
		-- ...
		AND (
			(t."x_m" = h."x_m")
			OR (
				(t."x_m" IS NULL)
				AND (h."x_m" IS NULL)
			)
		)
	)
;

-- The case when a full match between all values (key and otherwise) is found in the generic table and the historified table requires no action.
