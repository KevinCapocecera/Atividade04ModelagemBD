-- 1. Excluir uma notificação antiga
DELETE FROM Notificacao
WHERE id_notificacao = 1;

-- 2. Excluir disponibilidade de um dentista
DELETE FROM Disponibilidade
WHERE id_dentista = 2 AND dia_semana = 'TER';

-- 3. Excluir histórico de um paciente
DELETE FROM Historico
WHERE id_historico = 1;
