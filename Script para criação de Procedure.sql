CREATE PROCEDURE sp_info -- Cria��o de uma PROCEDURE com o nome sp_info (pode escolher o nome).
AS -- Sendo essa procedure, o bloco iniciado abaixo.
BEGIN -- In�cio do bloco.
	SELECT @@VERSION AS 'Informations' -- Neste exemplo utilizo um `SELECT @@VERSION` para buscar informa��es do servidor.
		,SERVERPROPERTY('ProductLevel') AS 'ProductLevel' -- O `SERVERPROPERTY` traz diversas informa��es do servidor, de forma organizada.
		,SERVERPROPERTY('MachineName') AS 'Nome da M�quina' -- Voc� pode customizar os nomes de cada coluna utilizando o `AS`.
		,SERVERPROPERTY('Edition') AS 'Edi��o do SQL Server'
		,SERVERPROPERTY('ProductVersion') AS 'Vers�o do SQL Server'
		,SERVERPROPERTY('Collation') AS 'Cola��o do Servidor'
		,SERVERPROPERTY('BuildClrVersion') AS 'Vers�o CLR'
		,SERVERPROPERTY('BuildNumber') AS 'N�mero da Compila��o'
		,SERVERPROPERTY('ProcessID') AS 'ID do Processo SQL Server'
		,SERVERPROPERTY('IsClustered') AS 'Clusterizado'
		,SERVERPROPERTY('IsFullTextInstalled') AS 'Instalado Full Text'
		,SERVERPROPERTY('IsIntegratedSecurityOnly') AS 'Apenas Seguran�a Integrada'
		,SERVERPROPERTY('IsHadrEnabled') AS 'HADR Habilitado';

	EXEC sp_helpdb -- Por �ltimo, adicionei um sp_helpdb para me trazer as informa��es dos meus bancos de dados.
		-- Voc� pode adicionar um Stored Procedure dentro de outro.
END;    -- Fim do bloco de comandos a serem adicionados na STORED PROCEDURE.

DROP PROCEDURE sp_info

EXEC sp_info
