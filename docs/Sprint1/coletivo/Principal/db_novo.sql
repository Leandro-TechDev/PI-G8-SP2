CREATE DATABASE safelab;
USE safelab;

-- Tabela da Empresa
CREATE TABLE empresa (
id_empresa INT PRIMARY KEY AUTO_INCREMENT,
cnpj CHAR(14) NOT NULL UNIQUE,
nome VARCHAR(50) NOT NULL,
codigo CHAR(7) NOT NULL,
cep CHAR(8) NOT NULL UNIQUE,
numero INT NOT NULL
);

-- Tabela do Funcionário
CREATE TABLE funcionario (
id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
cpf CHAR(11) NOT NULL UNIQUE,
nome VARCHAR(50) NOT NULL,
email VARCHAR(60) NOT NULL,
senha VARCHAR(100) NOT NULL,
dt_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
permicoes TINYINT NOT NULL, -- 0: apenas visualização, 1: analisar dados sensiveis, 2: 
fk_empresa INT NOT NULL,
CONSTRAINT ChkFkEmpresa FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

-- Tabela do Sensor - para localizarmos cada sensor
CREATE TABLE refrigerador (
id_refrigerador INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50),
fk_empresa INT NOT NULL,
CONSTRAINT Chk_Fk_Empresa FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

-- Tabela das temperaturas
CREATE TABLE medida_temperatura (
id_medida INT PRIMARY KEY AUTO_INCREMENT,
temperatura DECIMAL(4, 1),
dt_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
fk_refrigerador INT NOT NULL,
CONSTRAINT ChkFkRefrigerador FOREIGN KEY (fk_refrigerador) REFERENCES refrigerador(id_refrigerador)
);