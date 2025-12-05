CREATE OR REPLACE VIEW vw_agenda_completa AS
SELECT 
    c.id_consulta,
    DATE_FORMAT(c.data_hora, '%d/%m/%Y %H:%i') as data_formatada,
    c.status,
    p.nome_paciente,
    m.nome_medico,
    e.nome_especialidade,
    co.nome_convenio
FROM consulta c
JOIN paciente p ON c.id_paciente = p.id_paciente
JOIN medico m ON c.id_medico = m.id_medico
JOIN especialidade e ON c.id_especialidade = e.id_especialidade
JOIN convenio co ON p.id_convenio = co.id_convenio
ORDER BY c.data_hora;