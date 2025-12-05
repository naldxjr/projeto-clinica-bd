INSERT INTO usuario (login, senha, perfil) VALUES
('admin', 'admin123', 'ADMIN'),
('house', 'medico123', 'MEDICO'),
('grey', 'medico123', 'MEDICO'),
('shepherd', 'medico123', 'MEDICO'),
('joao.silva', 'pac123', 'PACIENTE'),
('maria.souza', 'pac123', 'PACIENTE');

INSERT INTO convenio (nome_convenio) VALUES 
('Unimed'),
('Bradesco Saúde'),
('Particular');

INSERT INTO especialidade (nome_especialidade) VALUES 
('Cardiologia'),
('Dermatologia'),
('Neurologia'),
('Ortopedia');

INSERT INTO medico (nome_medico, crm, id_usuario) VALUES
('Dr. Gregory House', 'SP-12345', 2),
('Dra. Meredith Grey', 'RJ-98765', 3),
('Dr. Derek Shepherd', 'MG-11122', 4);

INSERT INTO paciente (nome_paciente, cpf, data_nascimento, id_convenio, id_usuario) VALUES
('João da Silva', '111.111.111-00', '1980-05-20', 1, 5),
('Maria Souza', '222.222.222-00', '1995-10-10', 3, 6);

INSERT INTO medico_especialidade (id_medico, id_especialidade) VALUES 
(1, 1), (1, 3),
(2, 2),
(3, 3);

INSERT INTO medico_convenio (id_medico, id_convenio) VALUES 
(1, 1), (1, 3),
(2, 1), (2, 2), (2, 3),
(3, 3);

INSERT INTO consulta (id_paciente, id_medico, id_especialidade, data_hora, status, valor) VALUES
(1, 1, 1, '2025-12-10 10:00:00', 'AGENDADA', 200.00),
(2, 3, 3, '2025-12-10 11:00:00', 'REALIZADA', 500.00);