CREATE DATABASE clinica_odontologica;
USE clinica_odontologica;

-- =========================
-- Tabela: Paciente
-- =========================
CREATE TABLE Paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(120) UNIQUE,
    data_nascimento DATE,
    INDEX idx_nome_paciente (nome)
);

-- =========================
-- Tabela: Dentista
-- =========================
CREATE TABLE Dentista (
    id_dentista INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    especialidade VARCHAR(80),
    INDEX idx_especialidade (especialidade)
);

-- =========================
-- Tabela: Usuario
-- =========================
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    tipo ENUM('ADMIN','ATENDENTE') DEFAULT 'ATENDENTE'
);

-- =========================
-- Tabela: Procedimento
-- =========================
CREATE TABLE Procedimento (
    id_procedimento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    duracao_min INT NOT NULL,
    valor DECIMAL(10,2),
    INDEX idx_nome_proc (nome)
);

-- =========================
-- Tabela: Agendamento
-- =========================
CREATE TABLE Agendamento (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL,
    status ENUM('AGENDADO','CANCELADO','REALIZADO') DEFAULT 'AGENDADO',
    id_paciente INT,
    id_dentista INT,
    id_procedimento INT,
    id_usuario INT,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_dentista) REFERENCES Dentista(id_dentista),
    FOREIGN KEY (id_procedimento) REFERENCES Procedimento(id_procedimento),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    INDEX idx_data (data_hora),
    INDEX idx_status (status)
);

-- =========================
-- Tabela: Consulta
-- =========================
CREATE TABLE Consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_agendamento INT UNIQUE,
    notas TEXT,
    FOREIGN KEY (id_agendamento) REFERENCES Agendamento(id_agendamento)
);

-- =========================
-- Tabela: Notificacao
-- =========================
CREATE TABLE Notificacao (
    id_notificacao INT AUTO_INCREMENT PRIMARY KEY,
    id_agendamento INT,
    data_envio DATETIME NOT NULL,
    tipo ENUM('EMAIL','SMS') DEFAULT 'EMAIL',
    FOREIGN KEY (id_agendamento) REFERENCES Agendamento(id_agendamento)
);

-- =========================
-- Tabela: Disponibilidade
-- =========================
CREATE TABLE Disponibilidade (
    id_disponibilidade INT AUTO_INCREMENT PRIMARY KEY,
    id_dentista INT,
    dia_semana ENUM('SEG','TER','QUA','QUI','SEX','SAB'),
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    FOREIGN KEY (id_dentista) REFERENCES Dentista(id_dentista)
);

-- =========================
-- Tabela: Historico
-- =========================
CREATE TABLE Historico (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    id_consulta INT,
    observacoes TEXT,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta)
);

SELECT * FROM Consulta;

-- Pacientes
INSERT INTO Paciente (nome, telefone, email, data_nascimento) VALUES
('Maria Fernanda Silva', '11986554432', 'maria.fernanda@gmail.com', '1990-05-22'),
('João Pedro Farias', '11997778822', 'joao.p.farias@hotmail.com', '1985-09-14'),
('Roberta Andrade', '11981112233', 'roberta.andrade@yahoo.com', '1997-03-10');

-- Dentistas
INSERT INTO Dentista (nome, especialidade) VALUES
('Dr. Carlos Alberto', 'Ortodontia'),
('Dra. Helena Marques', 'Implantodontia'),
('Dr. Felipe Tavares', 'Clínico Geral');

-- Usuários
INSERT INTO Usuario (nome, tipo) VALUES
('Ana Souza', 'ATENDENTE'),
('Ricardo Lima', 'ADMIN');

-- Procedimentos
INSERT INTO Procedimento (nome, duracao_min, valor) VALUES
('Limpeza completa', 40, 150.00),
('Clareamento dental', 90, 850.00),
('Extração simples', 45, 220.00);

-- Agendamentos
INSERT INTO Agendamento (data_hora, status, id_paciente, id_dentista, id_procedimento, id_usuario)
VALUES
('2025-03-10 10:00:00', 'AGENDADO', 1, 3, 1, 1),
('2025-03-11 14:30:00', 'AGENDADO', 2, 1, 3, 1),
('2025-03-12 09:00:00', 'REALIZADO', 3, 2, 2, 2);

-- Consulta
INSERT INTO Consulta (id_agendamento, notas)
VALUES
(3, 'Paciente respondeu bem ao clareamento. Retorno em 30 dias.');

-- Notificações
INSERT INTO Notificacao (id_agendamento, data_envio, tipo) VALUES
(1, '2025-03-09 18:00:00', 'EMAIL'),
(2, '2025-03-10 18:00:00', 'SMS');

-- Disponibilidade
INSERT INTO Disponibilidade (id_dentista, dia_semana, hora_inicio, hora_fim)
VALUES
(1, 'SEG', '08:00', '12:00'),
(1, 'QUA', '13:00', '18:00'),
(2, 'TER', '09:00', '17:00');

-- Histórico
INSERT INTO Historico (id_paciente, id_consulta, observacoes)
VALUES
(3, 1, 'Tratamento estético realizado com sucesso.');

SELECT * FROM Agendamento;

DELIMITER //

CREATE TRIGGER tg_validar_agendamento
BEFORE INSERT ON Agendamento
FOR EACH ROW
BEGIN
    DECLARE conflito INT;

    SELECT COUNT(*) INTO conflito
    FROM Agendamento
    WHERE id_dentista = NEW.id_dentista
      AND data_hora = NEW.data_hora
      AND status = 'AGENDADO';

    IF conflito > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Dentista já possui um compromisso nesse horário.';
    END IF;
END //

DELIMITER ;


DROP TRIGGER IF EXISTS tg_validar_agendamento;

SHOW triggers;

CREATE INDEX idx_agendamento_paciente ON Agendamento (id_paciente);
CREATE INDEX idx_agendamento_dentista ON Agendamento (id_dentista);
CREATE INDEX idx_agendamento_procedimento ON Agendamento (id_procedimento);
CREATE INDEX idx_consulta_agendamento ON Consulta (id_agendamento);
CREATE INDEX idx_historico_paciente ON Historico (id_paciente);

select * FROM AGENDAMENTO;

SELECT nome, telefone, email
FROM PACIENTE
where id_paciente = 1;

-- 1. Listar todos os pacientes ordenados por nome
SELECT id_paciente, nome, telefone, email
FROM Paciente
ORDER BY nome;

-- 2. Buscar os agendamentos de um dentista específico
SELECT A.id_agendamento, A.data_hora, P.nome AS paciente
FROM Agendamento A
JOIN Paciente P ON A.id_paciente = P.id_paciente
WHERE A.id_dentista = 1;

-- 3. Listar as consultas com informações completas
SELECT C.id_consulta, A.data_hora, D.nome AS dentista, P.nome AS paciente
FROM Consulta C
JOIN Agendamento A ON C.id_agendamento = A.id_agendamento
JOIN Paciente P ON A.id_paciente = P.id_paciente
JOIN Dentista D ON A.id_dentista = D.id_dentista;

-- 4. Selecionar procedimentos mais caros que 200 reais
SELECT nome, valor
FROM Procedimento
WHERE valor > 200;

-- 5. Limitar resultados: próximos 2 agendamentos
SELECT *
FROM Agendamento
ORDER BY data_hora
LIMIT 2;

-- 1. Atualizar telefone de um paciente
UPDATE Paciente
SET telefone = '11977776666'
WHERE id_paciente = 1;

-- 2. Atualizar status de um agendamento
UPDATE Agendamento
SET status = 'REALIZADO'
WHERE id_agendamento = 1;

-- 3. Ajustar valor de um procedimento
UPDATE Procedimento
SET valor = valor + 50
WHERE id_procedimento = 2;

-- 1. Excluir uma notificação antiga
DELETE FROM Notificacao
WHERE id_notificacao = 1;

-- 2. Excluir disponibilidade de um dentista
DELETE FROM Disponibilidade
WHERE id_dentista = 2 AND dia_semana = 'TER';

-- 3. Excluir histórico de um paciente
DELETE FROM Historico
WHERE id_historico = 1;

