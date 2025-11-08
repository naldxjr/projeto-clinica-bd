INSERT INTO convenio (nome_convenio) VALUES
('Unimed Pleno'),
('Bradesco Saúde Top'),
('SulAmérica Executivo'),
('Particular');

INSERT INTO especialidade (nome_especialidade) VALUES
('Cardiologia'),
('Dermatologia'),
('Ortopedia'),
('Clínica Geral');

INSERT INTO medico (nome_medico, crm) VALUES
('Dr. House', 'SP123456'),
('Dra. Meredith Grey', 'RJ654321'),
('Dr. Derek Shepherd', 'MG789012');

INSERT INTO paciente (nome_paciente, cpf, data_nascimento, id_convenio) VALUES
('João da Silva', '11122233344', '1980-05-15', 1),
('Maria Oliveira', '22233344455', '1992-11-30', 2),
('Carlos Pereira', '33344455566', '1975-02-10', 1),
('Ana Souza', '44455566677', '2001-08-22', 4),
('Bruno Costa', '55566677788', '1988-07-12', 2);

INSERT INTO medico_especialidade (id_medico, id_especialidade) VALUES
(1, 1), -- House (Cardio)
(1, 4), -- House (Clínica)
(2, 2), -- Grey (Derma)
(3, 3); -- Shepherd (Orto)

INSERT INTO medico_convenio (id_medico, id_convenio) VALUES
(1, 1), -- House (Unimed)
(1, 2), -- House (Bradesco)
(2, 1), -- Grey (Unimed)
(2, 3), -- Grey (SulAmérica)
(3, 4); -- Shepherd (Particular)

INSERT INTO consulta (id_paciente, id_medico, id_especialidade, data_hora, status) VALUES
(1, 1, 1, '2025-11-10 09:00:00', 'AGENDADA'),
(2, 1, 1, '2025-11-10 10:00:00', 'CONFIRMADA'),
(4, 3, 3, '2025-11-11 14:00:00', 'AGENDADA'),
(1, 2, 2, '2025-11-12 11:00:00', 'REALIZADA'),
(3, 1, 4, '2025-11-10 11:00:00', 'CANCELADA');