CREATE DATABASE ex_aula
GO
USE ex_aula


CREATE TABLE Curso (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Duracao INT
);

INSERT INTO Curso (Codigo, Nome, Duracao) VALUES
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logística', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94, 'Gestão Empresarial', 2600);


CREATE TABLE Disciplinas (
    Codigo VARCHAR(10) PRIMARY KEY,
    Nome VARCHAR(100),
    Carga_Horaria INT
);

INSERT INTO Disciplinas (Codigo, Nome, Carga_Horaria) VALUES
('ALG001', 'Algoritmos', 80),
('ADM001', 'Administração', 80),
('LHW010', 'Laboratório de Hardware', 40),
('LPO001', 'Pesquisa Operacional', 80),
('FIS003', 'Física I', 80),
('FIS007', 'Físico Química', 80),
('CMX001', 'Comércio Exterior', 80),
('MKT002', 'Fundamentos de Marketing', 80),
('INF001', 'Informática', 40),
('ASI001', 'Sistemas de Informação', 80);


CREATE TABLE Disciplina_Curso (
    Codigo_Disciplina VARCHAR(10),
    Codigo_Curso INT,
    FOREIGN KEY (Codigo_Disciplina) REFERENCES Disciplinas(Codigo),
    FOREIGN KEY (Codigo_Curso) REFERENCES Curso(Codigo),
    PRIMARY KEY (Codigo_Disciplina, Codigo_Curso)
);


INSERT INTO Disciplina_Curso (Codigo_Disciplina, Codigo_Curso) VALUES
('ALG001', 48),
('ADM001', 48),
('ADM001', 51),
('ADM001', 73),
('ADM001', 94),
('LHW010', 48),
('LPO001', 51),
('FIS003', 67),
('FIS007', 67),
('CMX001', 51),
('CMX001', 73),
('MKT002', 51),
('MKT002', 94),
('INF001', 51),
('INF001', 73),
('ASI001', 48),
('ASI001', 94);

CREATE FUNCTION fn_disciplina(@codigoC INT)
RETURNS @tabela TABLE (
    codigoD         VARCHAR(10),
    nomeD           VARCHAR(50),
    cargaHoraria    INT,
    nomeCurso       VARCHAR(50)
)
AS
BEGIN
    DECLARE @codigoD        VARCHAR(10),
            @nomeD          VARCHAR(50),
            @cargaHoraria   INT,
            @nomeCurso      VARCHAR(50)
    DECLARE c CURSOR FOR 
        SELECT d.Codigo, d.Nome, d.Carga_Horaria, cr.Nome
        FROM Disciplinas d
        INNER JOIN Disciplina_Curso dc ON dc.Codigo_Disciplina = d.Codigo
        INNER JOIN Curso cr ON cr.Codigo = dc.Codigo_Curso
        WHERE dc.Codigo_Curso = @codigoC -- Adicionando a condição para o código do curso
    OPEN c
    FETCH NEXT FROM c INTO @codigoD, @nomeD, @cargaHoraria, @nomeCurso
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO @tabela VALUES (@codigoD, @nomeD, @cargaHoraria, @nomeCurso)
        FETCH NEXT FROM c INTO @codigoD, @nomeD, @cargaHoraria, @nomeCurso
    END
    CLOSE c
    DEALLOCATE c
    RETURN
END


SELECT * FROM fn_disciplina(48)