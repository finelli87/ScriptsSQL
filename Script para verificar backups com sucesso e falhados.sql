CREATE PROCEDURE sp_backupsf
AS
BEGIN
    -- Parte 1: Seleciona execu��es bem-sucedidas nos �ltimos 7 dias
    SELECT 
        j.name AS 'Nome do Job',
        'SUCESSO' AS 'Status de Execu��o',
        h.run_date AS 'Data da Execu��o',
        h.run_duration AS 'Dura��o da Execu��o (segundos)'
    FROM 
        dbo.sysjobs j
        INNER JOIN dbo.sysjobhistory h ON j.job_id = h.job_id
    WHERE 
        j.name LIKE '%Backup%'  
        AND h.run_status = 1
        AND h.run_date >= CONVERT(INT, CONVERT(VARCHAR, GETDATE() - 7, 112));

    -- Parte 2: Seleciona execu��es com falha nos �ltimos 7 dias
    SELECT 
        j.name AS 'Nome do Job',
        'FALHOU' AS 'Status de Execu��o',
        h.run_date AS 'Data da Execu��o',
        h.run_duration AS 'Dura��o da Execu��o (segundos)'
    FROM 
        dbo.sysjobs j
        INNER JOIN dbo.sysjobhistory h ON j.job_id = h.job_id
    WHERE 
        j.name LIKE '%Backup%'  
        AND h.run_status <> 1
        AND h.run_date >= CONVERT(INT, CONVERT(VARCHAR, GETDATE() - 7, 112));
END;

exec sp_backupsf
drop procedure sp_backupsf