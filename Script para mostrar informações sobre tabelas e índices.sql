-- Mostrar informa��es sobre tabelas e �ndices
-- Selecionar o banco antes
SELECT 
    t.name AS 'Nome da Tabela',
    i.name AS 'Nome do �ndice',
    p.rows AS 'N�mero de Linhas',
    SUM(ps.reserved_page_count) * 8 AS 'Tamanho (KB)',
    au.type_desc AS 'Tipo de Aloca��o',
    i.type_desc AS 'Tipo de �ndice'
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.object_id = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units au ON p.partition_id = au.container_id
LEFT JOIN 
    sys.dm_db_partition_stats ps ON t.object_id = ps.object_id AND i.index_id = ps.index_id
GROUP BY 
    t.name, i.object_id, i.index_id, i.name, p.rows, au.type_desc, i.type_desc
ORDER BY 
    t.name, i.index_id;


