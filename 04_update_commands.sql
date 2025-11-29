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
