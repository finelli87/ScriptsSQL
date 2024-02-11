Create PROCEDURE sp_m1
AS
Begin
SELECT database_name AS 'Database Name'
	,backup_start_date AS 'Last Backup Date'
	,CASE 
		WHEN TYPE = 'D'
			THEN 'Full'
		WHEN TYPE = 'I'
			THEN 'Differential'
		WHEN TYPE = 'L'
			THEN 'Transaction Log'
		END AS 'Backup Type'
FROM msdb.dbo.backupset;
END;
GO

-- Desempenho
Create Procedure sp_m2
AS
Begin
SELECT qs.execution_count
	,qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time
	,SUBSTRING(qt.TEXT, (qs.statement_start_offset / 2) + 1, (
			(
				CASE qs.statement_end_offset
					WHEN - 1
						THEN DATALENGTH(qt.TEXT)
					ELSE qs.statement_end_offset
					END - qs.statement_start_offset
				) / 2
			) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
ORDER BY avg_elapsed_time DESC;
END;
GO

Create Procedure sp_m3
AS
Begin
-- Buffer
SELECT COUNT(*) AS 'Total Pages in Buffer Pool'
FROM sys.dm_os_buffer_descriptors;
End;
GO

-- Índices
Create Procedure sp_m4
AS
Begin
SELECT OBJECT_NAME(ind.OBJECT_ID) AS 'Table Name'
	,indexstats.index_type_desc AS 'Index Type'
	,indexstats.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats
INNER JOIN sys.indexes ind ON ind.OBJECT_ID = indexstats.OBJECT_ID
	AND ind.index_id = indexstats.index_id
WHERE indexstats.avg_fragmentation_in_percent > 30;
END;
GO

-- Locks
Create Procedure sp_m5
AS
Begin
SELECT resource_type
	,resource_database_id
	,DB_NAME(resource_database_id) AS 'Database Name'
	,request_mode
	,request_type
	,request_session_id
	,request_status
FROM sys.dm_tran_locks
WHERE request_status = 'WAIT';
END;
GO

-- Buffer cache
Create Procedure sp_m6
AS
Begin
SELECT COUNT(*) AS 'Total Buffer Cache Pages'
FROM sys.dm_os_buffer_descriptors;
END;
GO

-- Índice de acerto em pesquisas do banco de dados na memória
Create Procedure sp_m7
AS
Begin
SELECT (COUNT(*) * 1.0 / SUM(user_seeks + user_scans)) * 100 AS 'Cache Hit Ratio'
FROM sys.dm_db_index_usage_stats;
END;
GO

-- Procurar índices não utilizados
Create Procedure sp_m8
AS
Begin
SELECT OBJECT_NAME(s.object_id) AS 'Table Name'
	,i.name AS 'Index Name'
	,s.user_updates
	,s.user_seeks
	,s.user_scans
	,s.user_lookups
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.object_id = i.object_id
	AND s.index_id = i.index_id
WHERE OBJECTPROPERTY(s.object_id, 'IsUserTable') = 1
	AND s.database_id = DB_ID()
	AND (
		s.user_seeks = 0
		AND s.user_scans = 0
		AND s.user_lookups = 0
		);
END;
GO

-- Crescimento de tabela
Create Procedure sp_m9
AS
Begin
SELECT t.NAME AS 'Table Name'
	,p.rows AS 'Row Count'
	,SUM(a.total_pages) * 8 AS 'Total Space (KB)'
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID
	AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
LEFT OUTER JOIN sys.schemas s ON t.schema_id = s.schema_id
GROUP BY t.Name
	,p.Rows
ORDER BY 'Total Space (KB)' DESC;
END;
GO

-- Inclusão de linhas por dia no registro
Create Procedure sp_m10
AS
Begin
SELECT OBJECT_NAME(p.object_id) AS 'Table Name'
	,SUM(p.rows) AS 'Total Rows'
	,DATEDIFF(DAY, MIN(o.create_date), GETDATE()) AS 'Days Since Creation'
	,SUM(p.rows) / DATEDIFF(DAY, MIN(o.create_date), GETDATE()) AS 'Avg Rows Per Day'
FROM sys.partitions p
INNER JOIN sys.objects o ON p.object_id = o.object_id
WHERE p.index_id IN (
		0
		,1
		) -- 0 and 1 represent the HEAP and Clustered Index, respectively
GROUP BY p.object_id
ORDER BY 'Avg Rows Per Day' DESC;
END;
GO


DROP PROCEDURE sp_m1
DROP PROCEDURE sp_m2
DROP PROCEDURE sp_m3
DROP PROCEDURE sp_m4
DROP PROCEDURE sp_m5
DROP PROCEDURE sp_m6
DROP PROCEDURE sp_m7
DROP PROCEDURE sp_m8
DROP PROCEDURE sp_m9
DROP PROCEDURE sp_m10

EXEC sp_m1
EXEC sp_m2
EXEC sp_m3
EXEC sp_m4
EXEC sp_m5
EXEC sp_m6
EXEC sp_m7
EXEC sp_m8
EXEC sp_m9
EXEC sp_m10