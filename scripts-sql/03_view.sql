DROP VIEW IF EXISTS vw_agenda_completa;

CREATE VIEW vw_agenda_completa AS
SELECT 
    c.id_consulta,
    c.data_hora,
    c.status,
    m.id_medico,
    m.nome_medico,
    m.crm,
    e.nome_especialidade,
    p.id_paciente,
    p.nome_paciente,
    p.cpf AS cpf_paciente,
    co.nome_convenio
FROM 
    consulta c
JOIN 
    medico m ON c.id_medico = m.id_medico
JOIN 
    paciente p ON c.id_paciente = p.id_paciente
JOIN 
    especialidade e ON c.id_especialidade = e.id_especialidade
JOIN 
    convenio co ON p.id_convenio = co.id_convenio
ORDER BY
    c.data_hora;


SELECT 
    data_hora,
    status,
    nome_paciente,
    nome_convenio
FROM 
    vw_agenda_completa
WHERE 
    id_medico = 1 
    AND data_hora::date = '2025-11-10';