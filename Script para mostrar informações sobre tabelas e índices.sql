-- Mostrar informações sobre tabelas e índices
-- Selecionar o banco antes
SELECT 
    t.name AS 'Nome da Tabela',
    i.name AS 'Nome do Índice',
    p.rows AS 'Número de Linhas',
    SUM(ps.reserved_page_count) * 8 AS 'Tamanho (KB)',
    au.type_desc AS 'Tipo de Alocação',
    i.type_desc AS 'Tipo de Índice'
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


