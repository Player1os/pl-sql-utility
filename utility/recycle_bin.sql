-- Restore table from recycle bin.
FLASHBACK TABLE &table_name TO BEFORE DROP
;

-- List object in the recycle bin.
SELECT /*+ PARALLEL USE_HASH */
	*
FROM
	RECYCLEBIN
;

-- Remove a specific item from the recycle bin.
DELETE FROM
	RECYCLEBIN
WHERE
	object_name = '&table_name'
;

-- Empty the recycle bin.
PURGE RECYCLEBIN
