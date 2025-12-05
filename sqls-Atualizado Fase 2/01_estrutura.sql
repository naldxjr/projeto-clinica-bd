SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS auditoria_consulta;
DROP TABLE IF EXISTS consulta;
DROP TABLE IF EXISTS medico_convenio;
DROP TABLE IF EXISTS medico_especialidade;
DROP TABLE IF EXISTS paciente;
DROP TABLE IF EXISTS medico;
DROP TABLE IF EXISTS especialidade;
DROP TABLE IF EXISTS convenio;
DROP TABLE IF EXISTS usuario;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL, 
    perfil ENUM('ADMIN', 'MEDICO', 'PACIENTE') NOT NULL
);

CREATE TABLE convenio (
    id_convenio INT AUTO_INCREMENT PRIMARY KEY,
    nome_convenio VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE especialidade (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome_especialidade VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome_medico VARCHAR(100) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome_paciente VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    id_convenio INT NOT NULL,
    id_usuario INT,
    FOREIGN KEY (id_convenio) REFERENCES convenio(id_convenio),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE medico_especialidade (
    id_medico INT NOT NULL,
    id_especialidade INT NOT NULL,
    PRIMARY KEY (id_medico, id_especialidade),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade)
);

CREATE TABLE medico_convenio (
    id_medico INT NOT NULL,
    id_convenio INT NOT NULL,
    PRIMARY KEY (id_medico, id_convenio),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    FOREIGN KEY (id_convenio) REFERENCES convenio(id_convenio)
);

CREATE TABLE consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    id_especialidade INT NOT NULL,
    data_hora DATETIME NOT NULL,
    status ENUM('AGENDADA', 'CONFIRMADA', 'REALIZADA', 'CANCELADA') DEFAULT 'AGENDADA',
    valor DECIMAL(10,2),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade),
    FOREIGN KEY (id_medico, id_especialidade) REFERENCES medico_especialidade(id_medico, id_especialidade),
    UNIQUE KEY uq_medico_horario (id_medico, data_hora),
    UNIQUE KEY uq_paciente_horario (id_paciente, data_hora)
);

CREATE TABLE auditoria_consulta (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    status_anterior VARCHAR(20),
    status_novo VARCHAR(20),
    data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_responsavel VARCHAR(50) DEFAULT 'Sistema'
);