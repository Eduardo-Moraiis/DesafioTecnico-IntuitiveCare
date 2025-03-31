-- Database: intuitivecare

-- DROP DATABASE IF EXISTS intuitivecare;

/*
CREATE DATABASE intuitivecare
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt-BR'
    LC_CTYPE = 'pt-BR'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
*/
CREATE TABLE operadoras_de_plano_de_saude_ativas(
    registro_ans VARCHAR(10) PRIMARY KEY,
    cnpj VARCHAR(14) NOT NULL,
    razao_social VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255),
    modalidade VARCHAR(100) NOT NULL,
    logradouro VARCHAR(255),
    numero VARCHAR(20),
    complemento VARCHAR(255),
    bairro VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL,
    cep VARCHAR(10),
    ddd VARCHAR(2),
    telefone VARCHAR(20),
    fax VARCHAR(20),
    endereco_eletronico VARCHAR(255),
    representante VARCHAR(255),
    cargo_representante VARCHAR(255),
    regiao_comercializacao VARCHAR(10),
    data_registro_ans DATE
);

CREATE TABLE demonstracoes_contabeis(
	id SERIAL PRIMARY KEY,
	data DATE,
	reg_ans VARCHAR(10),
	cd_conta_contabil VARCHAR(9),
	descricao VARCHAR(255),
	vl_saldo_inicial VARCHAR(15),
	vl_saldo_final VARCHAR(15)
);


COPY operadoras_de_plano_de_saude_ativas FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/DadosCadastrais/Relatorio_cadop.csv' WITH DELIMITER ';' CSV HEADER;

COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2024/1T2024.csv' WITH DELIMITER ';' CSV HEADER;
COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2024/2T2024.csv' WITH DELIMITER ';' CSV HEADER;
COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2024/3T2024.csv' WITH DELIMITER ';' CSV HEADER;
COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2024/4T2024.csv' WITH DELIMITER ';' CSV HEADER;