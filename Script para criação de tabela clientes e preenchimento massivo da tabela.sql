Select * from cliente

CREATE TABLE cliente (
    CPF VARCHAR(11), -- Assumindo que o CPF ser� armazenado como uma string de tamanho fixo de 11 caracteres
    NOME VARCHAR(100), -- Assumindo que o nome ter� no m�ximo 100 caracteres
    IDADE INT, -- Assumindo que a idade ser� armazenada como um n�mero inteiro
    PROFISSAO VARCHAR(50), -- Assumindo que a profiss�o ter� no m�ximo 50 caracteres
    SALARIO DECIMAL(10, 2), -- Assumindo que o sal�rio ser� armazenado como um n�mero decimal com at� 10 d�gitos, sendo 2 deles para a parte decimal
    DATANASC DATE -- Assumindo que a data de nascimento ser� armazenada como um tipo de dado de data
);

INSERT INTO cliente (CPF, NOME, IDADE, PROFISSAO, SALARIO, DATANASC)
VALUES ('12345678900', 'Jo�o Silva', 30, 'Engenheiro', 5000.00, '1992-05-15');


BEGIN TRAN
    INSERT INTO cliente (CPF, NOME, IDADE, PROFISSAO, SALARIO, DATANASC)
    VALUES ('98735400020', 'Mardaa Junior', 25, 'M�dica', 8000.00, '1997-10-20');
COMMIT TRANSACTION;
Rollback 

Select * from cliente
WHERE nome LIKE 'Mario%'

-- Gerar e inserir 50 dados aleat�rios na tabela cliente
-- Gerar e inserir 50 dados aleat�rios na tabela cliente
DECLARE @counter INT = 1;

WHILE @counter <= 10000
BEGIN
    INSERT INTO cliente (CPF, NOME, IDADE, PROFISSAO, SALARIO, DATANASC)
    VALUES (
        CAST(ABS(CHECKSUM(NEWID())) % 10000000000 AS VARCHAR(11)), -- CPF aleat�rio de at� 11 d�gitos
        'Nome' + CAST(@counter AS VARCHAR), -- Nome aleat�rio
        CAST(RAND() * 100 AS INT), -- Idade aleat�ria entre 0 e 100 anos
        'Profiss�o' + CAST(@counter AS VARCHAR), -- Profiss�o aleat�ria
        ROUND(RAND() * 10000 + 1000, 2), -- Sal�rio aleat�rio entre 1000 e 11000
        DATEADD(DAY, -CAST(RAND() * 365 * 50 AS INT), GETDATE()) -- Data de nascimento aleat�ria at� 50 anos atr�s
    );

    SET @counter = @counter + 1;
END
GO