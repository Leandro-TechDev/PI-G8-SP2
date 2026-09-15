CREATE DATABASE projeto_sprint_vacinas;
USE projeto_sprint_vacinas;

CREATE TABLE unidade_saude (
    idUnidade INT PRIMARY KEY AUTO_INCREMENT,
    nome_unidade VARCHAR(60) NOT NULL,
    cnpj CHAR(14),
    cidade VARCHAR(50)
);

CREATE TABLE equipamento (
    idEquipamento INT PRIMARY KEY AUTO_INCREMENT,
    identificacao VARCHAR(50) NOT NULL,
    modelo_sensor VARCHAR(30),
    capacidade_litros INT
);

CREATE TABLE estoque_vacina (
    idEstoque INT PRIMARY KEY AUTO_INCREMENT,
    nome_vacina VARCHAR(50) NOT NULL,
    lote VARCHAR(30) NOT NULL,
    quantidade INT,
    valor_unitario DECIMAL(10,2),
    local_armazenado VARCHAR(50)
);

CREATE TABLE registro_temperatura (
    idRegistro INT PRIMARY KEY AUTO_INCREMENT,
    local_leitura VARCHAR(50) NOT NULL,
    temperatura DECIMAL(4,1),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE registro_descarte (
    idDescarte INT PRIMARY KEY AUTO_INCREMENT,
    lote_perdido VARCHAR(30),
    motivo VARCHAR(60),
    quantidade_perdida INT,
    prejuizo_total DECIMAL(10,2),
    data_descarte DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO unidade_saude (nome_unidade, cnpj, cidade) VALUES
('UBS Central', '11222333000144', 'São Paulo'),
('Posto de Saúde Esperança', '55666777000188', 'Campinas');

INSERT INTO equipamento (identificacao, modelo_sensor, capacidade_litros) VALUES
('Geladeira 01 - UBS Central', 'Arduino LM35', 300),
('Câmara Fria A - Esperança', 'Arduino DHT22', 500);

INSERT INTO estoque_vacina (nome_vacina, lote, quantidade, valor_unitario, local_armazenado) VALUES
('H1N1 (Gripe)', 'LT-H1N1-2023', 500, 25.50, 'Geladeira 01 - UBS Central'),
('Tríplice Viral', 'LT-TRP-990', 200, 45.00, 'Câmara Fria A - Esperança');

INSERT INTO registro_temperatura (local_leitura, temperatura) VALUES
('Geladeira 01 - UBS Central', 5.0),
('Geladeira 01 - UBS Central', 4.5),
('Câmara Fria A - Esperança', 8.5),
('Câmara Fria A - Esperança', 9.2);

INSERT INTO registro_descarte (lote_perdido, motivo, quantidade_perdida, prejuizo_total) VALUES
('LT-TRP-990', 'Exposição a temperatura acima de 8ºC', 200, 9000.00);

SELECT 
    local_leitura AS 'Equipamento',
    data_hora AS 'Horário da Leitura',
    temperatura AS 'Temperatura (ºC)',
    CASE 
        WHEN temperatura < 2.0 THEN 'Risco Congelamento (< 2ºC)'
        WHEN temperatura > 8.0 THEN 'Risco Perda de Eficácia (> 8ºC)'
        ELSE 'Temperatura Ideal'
    END AS 'Status Atual'
FROM registro_temperatura;

SELECT 
    lote_perdido AS 'Lote Descartado',
    motivo AS 'Motivo da Perda',
    quantidade_perdida AS 'Qtd. Frascos',
    CONCAT('R$ ', prejuizo_total) AS 'Prejuízo Financeiro'
FROM registro_descarte;

SELECT  
    nome_vacina AS 'Vacina',
    lote AS 'Lote',
    quantidade AS 'Quantidade em Estoque',
    local_armazenado AS 'Onde está Guardado'
FROM estoque_vacina;
