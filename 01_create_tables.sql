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
