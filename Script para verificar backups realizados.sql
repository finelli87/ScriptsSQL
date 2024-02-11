CREATE PROCEDURE sp_backupsf
    @numeroDias INT
AS
BEGIN
    -- Parte 1: Seleciona execuções bem-sucedidas nos últimos @numeroDias dias
    SELECT 
        j.name AS 'Nome do Job',
        'SUCESSO' AS 'Status de Execução',
        h.run_date AS 'Data da Execução',
        h.run_duration AS 'Duração da Execução (segundos)'
    FROM 
        dbo.sysjobs j
        INNER JOIN dbo.sysjobhistory h ON j.job_id = h.job_id
    WHERE 
        j.name LIKE '%Backup%'  
        AND h.run_status = 1
        AND h.run_date >= CONVERT(INT, CONVERT(VARCHAR, GETDATE() - @numeroDias, 112));

    -- Parte 2: Seleciona execuções com falha nos últimos @numeroDias dias
    SELECT 
        j.name AS 'Nome do Job',
        'FALHOU' AS 'Status de Execução',
        h.run_date AS 'Data da Execução',
        h.run_duration AS 'Duração da Execução (segundos)'
    FROM 
        dbo.sysjobs j
        INNER JOIN dbo.sysjobhistory h ON j.job_id = h.job_id
    WHERE 
        j.name LIKE '%Backup%'  
        AND h.run_status <> 1
        AND h.run_date >= CONVERT(INT, CONVERT(VARCHAR, GETDATE() - @numeroDias, 112));
END;

drop procedure sp_backupsf


USE msdb
GO
EXEC sp_backupsf @numerodias = 3
GO