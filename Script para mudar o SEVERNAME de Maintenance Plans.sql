-- Script para mudar o nome do LOCAL SERVER CONNECTION para Maintenance Plans travados por conta de mudança no SERVER NAME ou IP
-- Usar msdb
GO
USE msdb
GO
-- Selecionar x.* para buscar o CONNECTION STRING e LOCAL SERVER CONNECTION, ambos no Connection Manager
SELECT  x.*,
        LocalServerConnectionString = cm.value('declare namespace DTS="www.microsoft.com/SqlServer/Dts";DTS:ObjectData[1]/DTS:ConnectionManager[1]/@DTS:ConnectionString', 'varchar(1000)')
FROM (
    SELECT  id, name, packageXML = CAST(CAST(packagedata AS VARBINARY(MAX)) AS XML)
    FROM dbo.sysssispackages
    WHERE id IN (SELECT id FROM dbo.sysmaintplan_plans)
) x
CROSS APPLY packageXML.nodes('declare namespace DTS="www.microsoft.com/SqlServer/Dts";/DTS:Executable/DTS:ConnectionManagers/DTS:ConnectionManager[@DTS:ObjectName="Local server connection"]') p(cm)
GO

-- Copiar o ID do Maintenance Plans que deseja mudar o SERVER NAME.
-- Colocar o SEVER NAME ou IP antigo, com a porta (exemplo: 177.14.58.244,1433) e o SEVER NAME novo, com porta (exemplo: 177.17.18.19,1433) em 
-- OLD SERVER e NEW SERVER

UPDATE dbo.sysssispackages SET packagedata = CAST(CAST(REPLACE(CAST(CAST(packagedata AS VARBINARY(MAX)) AS VARCHAR(MAX)), 'OLD SERVER', 'NEW SERVER') AS XML) AS VARBINARY(MAX))
-- Colar o ID do Maintenance Plans que deseja mudar o SEVER NAME
WHERE id = ''
