-- Alterar banco de dados  MASTER (Apos rodar o codigo, configurar as pastas no Configuration Manager, mover os arquivos para a pasta indicada e reiniciar o servidor).
ALTER DATABASE master 
MODIFY FILE (NAME = master, FILENAME = 'XXXX:\Master\Data\master.mdf');
GO
ALTER DATABASE master 
MODIFY FILE (NAME = mastlog, FILENAME = 'XXXX:\Master\Data\mastlog.ldf');
GO

-- Verificar em qual local esta alocado um banco de dados (Selecionar o banco de dados na aba superior)
SELECT name, physical_name AS CurrentLocation, state_desc  
FROM sys.master_files  
WHERE database_id = DB_ID('master');  
go

-- Mover MSDB e Model (Apos rodar o codigo, mover os arquivos e reiniciar o servidor).
ALTER DATABASE msdb   
    MODIFY FILE ( NAME = MSDBData,   
                  FILENAME = 'XXXX:/msdb/MSDBData.mdf');  
GO
ALTER DATABASE msdb   
    MODIFY FILE ( NAME = MSDBLog,   
                  FILENAME = 'XXXX:/msdb/MSDBLog.ldf');  
GO

-- Mover Model (Apos rodar o codigo, mover os arquivos e reiniciar o servidor).
ALTER DATABASE model   MODIFY FILE ( NAME = modeldev,   
    FILENAME = 'XXXX:/model/model.mdf');  
GO
ALTER DATABASE model   
MODIFY FILE ( NAME = modellog,   
    FILENAME = 'XXXX:/model/modellog.ldf');  
GO

-- Comando para verificar em qual pasta o banco esta alocado
SELECT NAME           [Nome],
        type_desc     [Tipo],
        physical_name [Local]
FROM   sys.database_files



sp_configure -- Exibir configuracoes
sp_configure 'show advanced options', 1 -- exibir configuracoes avancadas
reconfigure -- aplicar configuracoes
sp_configure 'show advanced options', 0 -- desligar configuracoes avancadas
reconfigure -- aplicar configuracoes

go
sp_configure 'optimize for ad hoc workloads', 1 -- Otimiza consultas que sao realizadas em tempo real na query. Reaproveitamento de consultas em tempo real
go
reconfigure
go
sp_configure 'remote admin connections', 1 -- Habilita conexoes remotas de admins
go
reconfigure
go
sp_configure 'tempdb metadata memory-optimized', 1 --Otimiza o desempenho e escalabilidade do tempetb
go
reconfigure






--Verificar se o Instant File Initialization esta habilitado
select instant_file_initialization_enabled ,* from sys.dm_server_services
where servicename like 'SQL Server%'

-- VErificar estado das bases de dados (Finelli)
SELECT name as 'Nome',
 state_desc as 'Estado',
 recovery_model_desc as 'Modelo de recovery',
 log_reuse_wait_desc as 'Log reuse',
 collation_name as 'Collation'
FROM sys.databases;

-- Verificar todas as configuracoes das bases de dados.
Select * from sys.databases

-- Verificar o tamanho das tabelas de uma base de dados. Necessario selecionar a base de dados.
SELECT 
    t.name AS 'Nome da Tabela',
    i.name as 'Nome do Indice',
    sum(p.rows) as 'Contagem de colunas',
    sum(a.total_pages) as 'Paginas totais', 
    sum(a.used_pages) as 'Paginas usadas', 
    sum(a.data_pages) as 'Paginas de data',
    (sum(a.total_pages) * 8) / 1024 as 'Tamanho total MB', 
    (sum(a.used_pages) * 8) / 1024 as 'Espaco Usado MB', 
    (sum(a.data_pages) * 8) / 1024 as 'Espaco da DATA MG'
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.object_id = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    t.name NOT LIKE 'dt%' AND
    i.object_id > 255 AND  
    i.index_id <= 1
GROUP BY 
    t.name, i.object_id, i.index_id, i.name 
ORDER BY 
  SUM(a.total_pages) DESC
--object_name(i.object_id) 
--SUM(a.total_pages) DESC
--SUM(p.rows) DESC

optimize for ad hoc workloads
remote admin connections
tempdb metadata memory-optimized