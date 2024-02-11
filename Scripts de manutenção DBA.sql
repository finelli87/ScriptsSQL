-- Definir variáveis

DECLARE @DatabaseName NVARCHAR(255)

SET @DatabaseName = 'NomeDoSeuBancoDeDados'


-- Realizar backup completo do banco de dados

BACKUP DATABASE @DatabaseName TO DISK = 'C:\Caminho\Para\Backup\' + @DatabaseName + '_Backup.bak' WITH INIT


-- Reindexar tabelas e índices

DECLARE @TableName NVARCHAR(255)

DECLARE ReindexCursor CURSOR FOR

    SELECT t.name

    FROM sys.tables t

    INNER JOIN sys.indexes i ON t.object_id = i.object_id

    WHERE i.index_id < 2


OPEN ReindexCursor

FETCH NEXT FROM ReindexCursor INTO @TableName


WHILE @@FETCH_STATUS = 0

BEGIN

    EXEC('ALTER INDEX ALL ON ' + @DatabaseName + '.' + @TableName + ' REBUILD')

    FETCH NEXT FROM ReindexCursor INTO @TableName

END


CLOSE ReindexCursor

DEALLOCATE ReindexCursor


-- Atualizar estatísticas

EXEC sp_updatestats


-- Limpar o histórico de backup antigo (opcional)

DECLARE @BackupRetentionDays INT

SET @BackupRetentionDays = 7


EXEC sp_delete_backuphistory @oldest_date = N'1/1/2023', @devtype = 1


-- Compactar o banco de dados (opcional)(cuidado, pois compactar demais e sempre, pode trazer problemas)

DBCC SHRINKDATABASE (@DatabaseName)


-- Registrar informações de manutenção

INSERT INTO MaintenanceLog (DatabaseName, MaintenanceDate)

VALUES (@DatabaseName, GETDATE())



