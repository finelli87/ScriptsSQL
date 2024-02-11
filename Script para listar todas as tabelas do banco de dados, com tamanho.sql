CREATE TABLE #AllTables (
    DatabaseName NVARCHAR(128),
    TableName NVARCHAR(128),
    SizeMB DECIMAL(18, 2),
    CompressionType NVARCHAR(50)
);

DECLARE @DbName NVARCHAR(128);
DECLARE @TableName NVARCHAR(128);
DECLARE @SqlQuery NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE database_id > 0; -- Ignora bancos de sistema

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DbName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SqlQuery = '
        USE ' + QUOTENAME(@DbName) + ';
        INSERT INTO #AllTables (DatabaseName, TableName, SizeMB, CompressionType)
        SELECT
            ''' + @DbName + ''' AS DatabaseName,
            t.name AS TableName,
            (SUM(reserved_page_count) * 8.0) / 1024 AS SizeMB,
            CASE WHEN OBJECTPROPERTYEX(t.object_id, ''TableHasPageCompressed'') = 1 THEN ''PAGE'' ELSE ''NONE'' END AS CompressionType
        FROM
            sys.tables t
            INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
            INNER JOIN sys.dm_db_partition_stats ps ON t.object_id = ps.object_id
        WHERE
            s.name + ''.'' + t.name NOT LIKE ''sys%''
        GROUP BY
            t.name, ps.reserved_page_count, t.object_id;
    ';

    EXEC sp_executesql @SqlQuery;

    FETCH NEXT FROM db_cursor INTO @DbName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;

-- Exibir os resultados
SELECT * FROM #AllTables
ORDER BY SizeMB DESC

-- Remover tabela temporária
DROP TABLE #AllTables;
