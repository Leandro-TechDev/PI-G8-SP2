CREATE DATABASE IF NOT EXISTS monitoramento_vacinas_nicolas;
USE monitoramento_vacinas_nicolas;

-- 1. Tabela de Empresas / Unidades de Saúde
CREATE TABLE empresas (
    id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    cnpj CHAR(14) NOT NULL UNIQUE,
    nome_empresa VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL
);

-- 2. Tabela de Usuários (vinculados a uma empresa/unidade)
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL, -- Mantém tamanho adequado para bcrypt/argon2
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    fk_empresa INT NOT NULL,
    FOREIGN KEY (fk_empresa) REFERENCES empresas(id_empresa)
);

-- 3. Tabela de Equipamentos / Geladeiras
CREATE TABLE geladeiras (
    id_geladeira INT AUTO_INCREMENT PRIMARY KEY,
    nome_geladeira VARCHAR(100) NOT NULL,
    localizacao VARCHAR(100),
    fk_empresa INT NOT NULL,
    FOREIGN KEY (fk_empresa) REFERENCES empresas(id_empresa)
);

-- 4. Tabela de Sensores (1 para 1 com a geladeira)
CREATE TABLE sensores (
    id_sensor INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    fk_geladeira INT NOT NULL UNIQUE,
    FOREIGN KEY (fk_geladeira) REFERENCES geladeiras(id_geladeira)
);

-- 5. Tabela de Vacinas (Vinculadas à Geladeira onde estão armazenadas)
CREATE TABLE vacinas (
    id_vacina INT AUTO_INCREMENT PRIMARY KEY,
    nome_vacina VARCHAR(100) NOT NULL,
    lote VARCHAR(50) NOT NULL,
    fk_geladeira INT NOT NULL,
    FOREIGN KEY (fk_geladeira) REFERENCES geladeiras(id_geladeira)
);

-- 6. Tabela de Temperaturas (Atrelada ao Sensor)
CREATE TABLE temperaturas (
    id_temperatura INT AUTO_INCREMENT PRIMARY KEY,
    valor_temperatura DECIMAL(5,2) NOT NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_sensor INT NOT NULL,
    FOREIGN KEY (fk_sensor) REFERENCES sensores(id_sensor)
);

-- Inserindo Empresas
INSERT INTO empresas (cnpj, nome_empresa, email) VALUES
('12345678000199', 'Hospital Central Amestris', 'contato@amestris.gov'),
('98765432000188', 'Agência de Saúde WISE', 'contato@wise.gov');

-- Inserindo Usuários (Com Hash bcrypt fictício mantido)
INSERT INTO usuarios (nome_completo, cpf, email, senha, fk_empresa) VALUES
('Edward Elric', '11122233301', 'edward.elric@amestris.com', '$amoalquimiadasilva', 1),
('Loid Forger', '22233344402', 'loid.forger@wise.gov', '$amoespiõesdossantos', 2),
('Winry Rockbell', '33344455503', 'winry.rockbell@automail.com', '$baterbaterbatersocar', 1),
('Shota Aizawa', '44455566604', 'aizawa.shota@ua.edu.br', '$olharapagarolharapagar', 2);

-- Inserindo Geladeiras
INSERT INTO geladeiras (nome_geladeira, localizacao, fk_empresa) VALUES
('Geladeira Principal', 'Sala de Vacinação A', 1),
('Freezer Especial', 'Depósito Central', 2);

-- Inserindo Sensores
INSERT INTO sensores (modelo, fk_geladeira) VALUES
('LM35', 1),
('LM35', 2);

-- Inserindo Vacinas
INSERT INTO vacinas (nome_vacina, lote, fk_geladeira) VALUES
('Covid-19 Bivalente', 'LOTE-CV12', 1),
('Febre Amarela', 'LOTE-FA99', 2);

-- Inserindo Leituras de Temperatura
INSERT INTO temperaturas (valor_temperatura, data_hora, fk_sensor) VALUES
(4.10, '2026-09-03 08:00:00', 1),
(4.30, '2026-09-03 09:00:00', 1),
(1.50, '2026-09-03 10:00:00', 1), -- Temperatura muito baixa
(9.20, '2026-09-03 11:00:00', 2), -- Alerta crítico
(3.50, '2026-09-03 12:00:00', 2),
(5.43, NOW(), 1);

-- Relatório de Unidade de Saude, Equipamento, Temperatura, Data & Hora e Status do Alerta
SELECT 
    e.nome_empresa AS 'Unidade de Saúde',
    g.nome_geladeira AS 'Equipamento',
    t.valor_temperatura AS 'Temperatura (ºC)',
    t.data_hora AS 'Data/Hora Leitura',
    CASE 
        WHEN t.valor_temperatura < 2.00 THEN CONCAT('ALERTA: Temperatura muito baixa - ', t.valor_temperatura, 'ºC')
        WHEN t.valor_temperatura > 8.00 THEN CONCAT('ALERTA CRÍTICO: Temperatura elevada - ', t.valor_temperatura, 'ºC')
        ELSE CONCAT('Normal: Temperatura adequada - ', t.valor_temperatura, 'ºC')
    END AS 'Status do Alerta'
FROM temperaturas t, sensores s, geladeiras g, empresas e
WHERE t.fk_sensor = s.id_sensor
  AND s.fk_geladeira = g.id_geladeira
  AND g.fk_empresa = e.id_empresa
ORDER BY t.data_hora DESC;

-- Relatório de Vacinas e Onde Estão Guardadas
SELECT 
    v.nome_vacina AS 'Nome da Vacina',
    v.lote AS 'Lote',
    g.nome_geladeira AS 'Equipamento',
    e.nome_empresa AS 'Unidade de Saúde'
FROM vacinas v, geladeiras g, empresas e
WHERE v.fk_geladeira = g.id_geladeira
  AND g.fk_empresa = e.id_empresa;

-- Relatório de Uusuários por Empresa
SELECT 
    u.nome_completo AS 'Nome do Usuário',
    u.email AS 'E-mail de Contato',
    e.nome_empresa AS 'Instituição / Empresa'
FROM usuarios u, empresas e
WHERE u.fk_empresa = e.id_empresa
ORDER BY u.nome_completo ASC;