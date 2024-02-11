Select * from cliente

CREATE TABLE cliente (
    CPF VARCHAR(11), -- Assumindo que o CPF será armazenado como uma string de tamanho fixo de 11 caracteres
    NOME VARCHAR(100), -- Assumindo que o nome terá no máximo 100 caracteres
    IDADE INT, -- Assumindo que a idade será armazenada como um número inteiro
    PROFISSAO VARCHAR(50), -- Assumindo que a profissão terá no máximo 50 caracteres
    SALARIO DECIMAL(10, 2), -- Assumindo que o salário será armazenado como um número decimal com até 10 dígitos, sendo 2 deles para a parte decimal
    DATANASC DATE -- Assumindo que a data de nascimento será armazenada como um tipo de dado de data
);

INSERT INTO cliente (CPF, NOME, IDADE, PROFISSAO, SALARIO, DATANASC)
VALUES ('12345678900', 'João Silva', 30, 'Engenheiro', 5000.00, '1992-05-15');


BEGIN TRAN
    INSERT INTO cliente (CPF, NOME, IDADE, PROFISSAO, SALARIO, DATANASC)
    VALUES ('98735400020', 'Mardaa Junior', 25, 'Médica', 8000.00, '1997-10-20');
COMMIT TRANSACTION;
Rollback 

Select * from cliente
WHERE nome LIKE 'Mario%'

-- Gerar e inserir 50 dados aleatórios na tabela cliente
-- Gerar e inserir 50 dados aleatórios na tabela cliente
DECLARE @counter INT = 1;

WHILE @counter <= 10000
BEGIN
    INSERT INTO cliente (CPF, NOME, IDADE, PROFISSAO, SALARIO, DATANASC)
    VALUES (
        CAST(ABS(CHECKSUM(NEWID())) % 10000000000 AS VARCHAR(11)), -- CPF aleatório de até 11 dígitos
        'Nome' + CAST(@counter AS VARCHAR), -- Nome aleatório
        CAST(RAND() * 100 AS INT), -- Idade aleatória entre 0 e 100 anos
        'Profissão' + CAST(@counter AS VARCHAR), -- Profissão aleatória
        ROUND(RAND() * 10000 + 1000, 2), -- Salário aleatório entre 1000 e 11000
        DATEADD(DAY, -CAST(RAND() * 365 * 50 AS INT), GETDATE()) -- Data de nascimento aleatória até 50 anos atrás
    );

    SET @counter = @counter + 1;
END
GO