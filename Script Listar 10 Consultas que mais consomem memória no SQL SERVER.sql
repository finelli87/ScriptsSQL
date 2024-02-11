SELECT TOP 10 OBJECT_NAME(qt.objectid) AS 'SP Name', 
       SUBSTRING(qt.text, (qs.statement_start_offset / 2) + 1, ((CASE qs.statement_end_offset
                                      WHEN -1
                                      THEN DATALENGTH(qt.text)
                                      ELSE qs.statement_end_offset
                                    END - qs.statement_start_offset) / 2) + 1) AS statement_text, 
       total_logical_reads, 
       qs.execution_count AS 'Execution Count', 
       total_logical_reads / qs.execution_count AS 'AvgLogicalReads', 
       qs.execution_count / DATEDIFF(minute, qs.creation_time, GETDATE()) AS 'Calls/minute', 
       qs.total_worker_time / qs.execution_count AS 'AvgWorkerTime', 
       qs.total_worker_time AS 'TotalWorkerTime', 
       qs.total_elapsed_time / qs.execution_count AS 'AvgElapsedTime', 
       qs.total_logical_writes, 
       qs.max_logical_reads, 
       qs.max_logical_writes, 
       qs.total_physical_reads, 
       qt.dbid, 
       qp.query_plan
FROM sys.dm_exec_query_stats AS qs
   CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
   OUTER APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE qt.dbid = DB_ID() -- Filter by current database 
ORDER BY total_logical_reads DESC;
