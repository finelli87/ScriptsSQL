USE msdb;
GO

CREATE PROCEDURE sp_backupcheck
AS
BEGIN
    DECLARE @StartDate DATETIME = DATEADD(HOUR, -48, GETDATE());
    DECLARE @EndDate DATETIME = GETDATE();

    -- Consulta para verificar os backups realizados nas últimas 48 horas
    SELECT
        bs.database_name AS 'Nome do Banco de Dados',
        bs.backup_start_date AS 'Data e Hora do Início do Backup',
        bs.backup_finish_date AS 'Data e Hora do Fim do Backup',
        bs.[type] AS 'Tipo de Backup',
        bmf.physical_device_name AS 'Caminho do Dispositivo Físico',
        CAST(bs.backup_size / 1024 / 1024 AS INT) AS   'Tamanho do Backup (MB)'
    FROM
        msdb.dbo.backupset bs
    JOIN
        msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
    WHERE
        bs.backup_start_date BETWEEN @StartDate AND @EndDate
    ORDER BY
        bs.backup_start_date DESC;
END;
GO

exec sp_backupcheck
drop procedure sp_backupcheck
