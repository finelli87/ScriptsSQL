-- Cria��o da tabela Empresas
CREATE TABLE Empresas (
    ID INT PRIMARY KEY IDENTITY(1,1),
    NomeEmpresa VARCHAR(100),
    Estado VARCHAR(50)
);

-- Cria��o ta tabela Estados
CREATE TABLE Estados (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nome VARCHAR(50)
);
-- Preenchimento da tabela Estados
INSERT INTO Estados (Nome) VALUES
    ('Acre'),
    ('Alagoas'),
    ('Amap�'),
    ('Amazonas'),
    ('Bahia'),
    ('Cear�'),
    ('Distrito Federal'),
    ('Esp�rito Santo'),
    ('Goi�s'),
    ('Maranh�o'),
    ('Mato Grosso'),
    ('Mato Grosso do Sul'),
    ('Minas Gerais'),
    ('Par�'),
    ('Para�ba'),
    ('Paran�'),
    ('Pernambuco'),
    ('Piau�'),
    ('Rio de Janeiro'),
    ('Rio Grande do Norte'),
    ('Rio Grande do Sul'),
    ('Rond�nia'),
    ('Roraima'),
    ('Santa Catarina'),
    ('S�o Paulo'),
    ('Sergipe'),
    ('Tocantins');



-- Inserir 1000 registros aleat�rios na tabela Empresas
DECLARE @i INT = 1;
WHILE @i <= 100000
BEGIN
    INSERT INTO Empresas (NomeEmpresa, Estado)
    VALUES
        ('Quitanda' + CAST(@i AS VARCHAR), (SELECT TOP 1 Nome FROM Estados ORDER BY NEWID()));
    SET @i = @i + 1;
END;

-- Consulta
select * from empresas



