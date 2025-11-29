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
