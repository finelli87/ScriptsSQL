-- Criado por Gabriel Finelli DBA SQL SERVER
CREATE PROCEDURE sp_DBAExpertMonitoring
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        dbschemas.[name] AS 'Esquema', 
        dbtables.[name] AS 'Tabela', 
        dbindexes.[name] AS 'Indice',
        indexstats.avg_fragmentation_in_percent AS 'PercentualMedioFragmentacao',
        indexstats.page_count AS 'ContagemPaginas'
    FROM 
        sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
    INNER JOIN 
        sys.tables dbtables ON dbtables.[object_id] = indexstats.[object_id]
    INNER JOIN 
        sys.schemas dbschemas ON dbtables.[schema_id] = dbschemas.[schema_id]
    INNER JOIN 
        sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
        AND indexstats.index_id = dbindexes.index_id
    WHERE 
        indexstats.database_id = DB_ID()
        AND indexstats.avg_fragmentation_in_percent > 30
    ORDER BY 
        indexstats.avg_fragmentation_in_percent DESC;

    SELECT TOP 10 
        qs.total_elapsed_time / qs.execution_count / 1000000.0 AS 'SegundosMedios',
        qs.total_elapsed_time / 1000000.0 AS 'SegundosTotais',
        qs.execution_count AS 'ContagemExecucao',
        SUBSTRING(qt.text, qs.statement_start_offset / 2, 
            (CASE 
                WHEN qs.statement_end_offset = -1 
                THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2 
                ELSE qs.statement_end_offset 
                END - qs.statement_start_offset) / 2) AS 'ConsultaIndividual',
        qp.query_plan AS 'PlanoConsulta'
    FROM 
        sys.dm_exec_query_stats qs
    CROSS APPLY 
        sys.dm_exec_sql_text(qs.sql_handle) AS qt
    CROSS APPLY 
        sys.dm_exec_query_plan(qs.plan_handle) AS qp
    ORDER BY 
        'SegundosMedios' DESC;

    SELECT 
        tl.request_session_id AS 'IDRequisicaoSessao',
        tl.resource_type AS 'TipoRecurso',
        tl.resource_database_id AS 'IDBancoDadosRecurso',
        tl.resource_associated_entity_id AS 'IDEntidadeAssociadaRecurso',
        tl.request_mode AS 'ModoRequisicao',
        tl.request_status AS 'StatusRequisicao',
        st.text AS 'TextoConsulta'
    FROM 
        sys.dm_tran_locks AS tl
    INNER JOIN 
        sys.dm_exec_requests AS er ON tl.request_session_id = er.session_id
    OUTER APPLY 
        sys.dm_exec_sql_text(er.sql_handle) AS st
    WHERE 
        tl.resource_database_id = DB_ID()
    ORDER BY 
        tl.request_session_id;

    SELECT 
        type AS 'Tipo',
        pages_kb / 1024.0 AS 'PaginasMB',
        virtual_memory_committed_kb / 1024.0 AS 'MemoriaVirtualComprometidaMB',
        shared_memory_committed_kb / 1024.0 AS 'MemoriaCompartilhadaComprometidaMB'
    FROM 
        sys.dm_os_memory_clerks 
    ORDER BY 
        pages_kb DESC;

 SELECT 
    DB_NAME(database_id) AS 'NomeBancoDados',
    file_id AS 'IDArquivo',
    io_stall_read_ms AS 'IOEsperaLeituraMS',
    num_of_reads AS 'NumeroLeituras',
    CAST(io_stall_read_ms / (1.0 + num_of_reads) AS NUMERIC(10, 1)) AS 'MediaEsperaLeituraMS',
    io_stall_write_ms AS 'IOEsperaEscritaMS',
    num_of_writes AS 'NumeroEscritas',
    CAST(io_stall_write_ms / (1.0 + num_of_writes) AS NUMERIC(10, 1)) AS 'MediaEsperaEscritaMS',
    io_stall_read_ms + io_stall_write_ms AS 'TotalIOEsperas',
    num_of_reads + num_of_writes AS 'TotalIO',
    CAST((io_stall_read_ms + io_stall_write_ms) / (1.0 + num_of_reads + num_of_writes) AS NUMERIC(10, 1)) AS 'MediaIOEsperaMS'
FROM 
    sys.dm_io_virtual_file_stats(NULL, NULL)
ORDER BY 
    io_stall_read_ms + io_stall_write_ms DESC;

    SET NOCOUNT OFF;
END;
GO


