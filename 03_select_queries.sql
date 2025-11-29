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

