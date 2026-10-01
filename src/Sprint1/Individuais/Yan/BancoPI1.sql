CREATE DATABASE monitoramento_vacinas;
USE monitoramento_vacinas;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE temperaturas (
    id_temperatura INT AUTO_INCREMENT PRIMARY KEY,
    valor_temperatura DECIMAL(5,2) NOT NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO usuarios (nome_completo, cpf, email, senha) VALUES
('Ana Silva', '12345678901', 'ana.silva@email.com', '$2a$12$eImiTXuWVxfM37uY4JANjOL.eTYR.k7Yx1z3x.a4aG4q5g5a5a5a5'),
('Carlos Eduardo', '98765432100', 'carlos.eduardo@email.com', '$2a$12$eImiTXuWVxfM37uY4JANjOL.eTYR.k7Yx1z3x.a4aG4q5g5a5a5a5'),
('Mariana Costa', '45678912300', 'mariana.costa@email.com', '$2a$12$eImiTXuWVxfM37uY4JANjOL.eTYR.k7Yx1z3x.a4aG4q5g5a5a5a5');


SELECT * FROM usuarios;
UPDATE usuarios SET senha = '12345678' WHERE id_usuario BETWEEN 1 AND 3;

INSERT INTO temperaturas (valor_temperatura, data_hora) VALUES
(4.10, '2026-09-03 08:00:00'),
(4.30, '2026-09-03 09:00:00'),
(5.80, '2026-09-03 10:00:00'),
(9.20, '2026-09-03 11:00:00'),
(3.50, '2026-09-03 12:00:00');

SELECT * FROM temperaturas;


INSERT INTO temperaturas (valor_temperatura, data_hora) VALUE
(5.43, NOW());

SELECT * FROM temperaturas;
