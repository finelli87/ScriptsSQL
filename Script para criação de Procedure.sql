CREATE PROCEDURE sp_info -- Criação de uma PROCEDURE com o nome sp_info (pode escolher o nome).
AS -- Sendo essa procedure, o bloco iniciado abaixo.
BEGIN -- Início do bloco.
	SELECT @@VERSION AS 'Informations' -- Neste exemplo utilizo um `SELECT @@VERSION` para buscar informações do servidor.
		,SERVERPROPERTY('ProductLevel') AS 'ProductLevel' -- O `SERVERPROPERTY` traz diversas informações do servidor, de forma organizada.
		,SERVERPROPERTY('MachineName') AS 'Nome da Máquina' -- Você pode customizar os nomes de cada coluna utilizando o `AS`.
		,SERVERPROPERTY('Edition') AS 'Edição do SQL Server'
		,SERVERPROPERTY('ProductVersion') AS 'Versão do SQL Server'
		,SERVERPROPERTY('Collation') AS 'Colação do Servidor'
		,SERVERPROPERTY('BuildClrVersion') AS 'Versão CLR'
		,SERVERPROPERTY('BuildNumber') AS 'Número da Compilação'
		,SERVERPROPERTY('ProcessID') AS 'ID do Processo SQL Server'
		,SERVERPROPERTY('IsClustered') AS 'Clusterizado'
		,SERVERPROPERTY('IsFullTextInstalled') AS 'Instalado Full Text'
		,SERVERPROPERTY('IsIntegratedSecurityOnly') AS 'Apenas Segurança Integrada'
		,SERVERPROPERTY('IsHadrEnabled') AS 'HADR Habilitado';

	EXEC sp_helpdb -- Por último, adicionei um sp_helpdb para me trazer as informações dos meus bancos de dados.
		-- Você pode adicionar um Stored Procedure dentro de outro.
END;    -- Fim do bloco de comandos a serem adicionados na STORED PROCEDURE.

DROP PROCEDURE sp_info

EXEC sp_info
