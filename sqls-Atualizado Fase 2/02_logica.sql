DELIMITER $$

CREATE FUNCTION fn_verificar_disponibilidade(p_id_medico INT, p_data_hora DATETIME) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_existe INT;
    SELECT COUNT(*) INTO v_existe
    FROM consulta
    WHERE id_medico = p_id_medico 
      AND data_hora = p_data_hora
      AND status <> 'CANCELADA';
    IF v_existe > 0 THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END$$

CREATE FUNCTION fn_faturamento_medico(p_id_medico INT) 
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT SUM(valor) INTO v_total
    FROM consulta
    WHERE id_medico = p_id_medico 
      AND status = 'REALIZADA';
    RETURN IFNULL(v_total, 0.00);
END$$

CREATE TRIGGER trg_validar_convenio_medico
BEFORE INSERT ON consulta
FOR EACH ROW
BEGIN
    DECLARE v_aceita INT;
    DECLARE v_convenio_paciente INT;
    SELECT id_convenio INTO v_convenio_paciente 
    FROM paciente WHERE id_paciente = NEW.id_paciente;
    SELECT COUNT(*) INTO v_aceita
    FROM medico_convenio
    WHERE id_medico = NEW.id_medico 
      AND id_convenio = v_convenio_paciente;
    IF v_aceita = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Este médico não atende o convênio do paciente.';
    END IF;
END$$

CREATE TRIGGER trg_log_auditoria
AFTER UPDATE ON consulta
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO auditoria_consulta (id_consulta, status_anterior, status_novo, usuario_responsavel)
        VALUES (NEW.id_consulta, OLD.status, NEW.status, 'Sistema/Backend');
    END IF;
END$$

CREATE PROCEDURE prc_agendar_consulta(
    IN p_id_paciente INT,
    IN p_id_medico INT,
    IN p_id_especialidade INT,
    IN p_data_hora DATETIME,
    IN p_valor DECIMAL(10,2)
)
BEGIN
    DECLARE v_livre BOOLEAN;
    SET v_livre = fn_verificar_disponibilidade(p_id_medico, p_data_hora);
    IF v_livre = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Horário indisponível na agenda do médico.';
    ELSE
        INSERT INTO consulta (id_paciente, id_medico, id_especialidade, data_hora, valor)
        VALUES (p_id_paciente, p_id_medico, p_id_especialidade, p_data_hora, p_valor);
    END IF;
END$$

DELIMITER ;