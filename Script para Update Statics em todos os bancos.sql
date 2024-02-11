-- Script para rodar update Statics sem precisar abrir banco a banco
DECLARE @SqlCommand NVARCHAR(MAX) = ''
SELECT @SqlCommand += 'EXEC ' + QUOTENAME(name) + '.dbo.sp_updatestats;' + CHAR(13) + CHAR(10)
FROM sys.databases
WHERE database_id > 0; -- Se colocar > 4 ira excluir da lista os bancos Master, Model, MSDB, TEMPDB
PRINT @SqlCommand
-- Execute o comando dinâmico (descomente a linha abaixo para realmente executar)
EXEC sp_executesql @SqlCommand;


EXEC [DWDiagnostics].dbo.sp_updatestats;
EXEC [DWConfiguration].dbo.sp_updatestats;
EXEC [DWQueue].dbo.sp_updatestats;
EXEC [AdventureWorks2022].dbo.sp_updatestats;
EXEC [AdventureWorksDW2017].dbo.sp_updatestats;
EXEC [AdventureWorksDW2019].dbo.sp_updatestats;