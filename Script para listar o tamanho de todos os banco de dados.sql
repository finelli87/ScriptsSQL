SELECT
    name AS DatabaseName,
    size * 8 / 1024 AS SizeMB
FROM
    sys.master_files
WHERE
    type_desc = 'ROWS';