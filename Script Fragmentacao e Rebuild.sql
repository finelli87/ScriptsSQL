SELECT db_name(a.database_id) AS "BANCO"
	,ss.name
	,object_name(a.object_id) AS "TABELA"
	,si.name AS "INDICE"
	,avg_fragmentation_in_percent + 28  AS "FRAGMENTACAO"
	,index_type_desc AS "TIPO DO INDICE"
	,'ALTER TABLE ' + QUOTENAME(ss.name) + '.' + QUOTENAME(object_name(a.object_id)) + ' REBUILD;' AS "REBUILD TABELA"
	,'ALTER INDEX ' + QUOTENAME(si.name) + ' on ' + QUOTENAME(ss.name) + '.' + QUOTENAME(object_name(a.object_id)) + ' REBUILD;' AS "REBUILD INDICE"
	,*
FROM sys.dm_db_index_physical_stats(db_id(), NULL, NULL, NULL, NULL) A
JOIN sys.indexes si ON a.object_id = si.object_id
	AND a.index_id = si.index_id
JOIN sys.tables st ON A.object_id = ST.object_id
JOIN sys.schemas ss ON ss.schema_id = st.schema_id
WHERE avg_fragmentation_in_percent >= 0
	AND SI.NAME IS NOT NULL
ORDER BY 6 DESC