-- Listar comandos para dar shirink em todos os LOGS do servidor.
DECLARE @ShrinkCommands NVARCHAR(MAX) = '';
SELECT @ShrinkCommands += 
    'USE [' + name + '];' +
    'DBCC SHRINKFILE (' + CAST(name + '_log' AS NVARCHAR(MAX)) + ', 1);' + CHAR(13) + CHAR(10)
FROM sys.databases
WHERE database_id > 4 AND state_desc = 'ONLINE'; -- Excluindo bancos de sistema e offline
-- Imprimir os comandos gerados (opcional)
PRINT @ShrinkCommands;
-- Copie e cole o resultado para executar os comandos de SHRINK


----------------------------------------------------------------------------------------------------


--Consultar todos os logs de todos os bancos
DECLARE @Query NVARCHAR(MAX) = '';
SELECT @Query += 
    'USE [' + name + '];' +
    'SELECT
        ''' + name + ''' AS DatabaseName,
        name AS LogicalFileName,
        size * 8 / 1024 AS LogSizeMB
    FROM
        sys.master_files
    WHERE
        type_desc = ''LOG'';' + CHAR(13) + CHAR(10)
FROM sys.databases
WHERE database_id > 4 AND state_desc = 'ONLINE'; -- Excluindo bancos de sistema e offline
-- Imprimir os comandos gerados (opcional)
-- PRINT @Query;
-- Executar os comandos gerados
EXEC sp_executesql @Query;

