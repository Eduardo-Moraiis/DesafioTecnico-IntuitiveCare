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

/*
Versão do postgres: PostgreSQL 17.4

Foi utilizado o pgAdmin4 para criar o banco de dados
Creio que seja necessário ajustar o caminho dos arquivos csv,
pois não consegui localiza-los com um caminho relativo
apenas através do caminho absoluto.
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
	data DATE NOT NULL,
	reg_ans VARCHAR(10) NOT NULL,
	cd_conta_contabil VARCHAR(9) NOT NULL,
	descricao VARCHAR(255) NOT NULL,
	vl_saldo_inicial VARCHAR(15) NOT NULL,
	vl_saldo_final VARCHAR(15) NOT NULL
);


COPY operadoras_de_plano_de_saude_ativas FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/DadosCadastrais/Relatorio_cadop.csv' WITH DELIMITER ';' CSV HEADER;


COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2024/1T2024.csv' WITH DELIMITER ';' CSV HEADER;
COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2024/2T2024.csv' WITH DELIMITER ';' CSV HEADER;
COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2024/3T2024.csv' WITH DELIMITER ';' CSV HEADER;
COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2024/4T2024.csv' WITH DELIMITER ';' CSV HEADER;

COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2023/1T2023.csv' WITH DELIMITER ';' CSV HEADER;
COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2023/2T2023.csv' WITH DELIMITER ';' CSV HEADER;
COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2023/3T2023.csv' WITH DELIMITER ';' CSV HEADER;
COPY demonstracoes_contabeis(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial,vl_saldo_final) FROM 'E:/Desafio-IntuitiveCare/TesteBancoDeDados/2023/4T2023.csv' WITH DELIMITER ';' CSV HEADER;


SELECT A.razao_social, B.total_gastos FROM operadoras_de_plano_de_saude_ativas A JOIN 
	(SELECT reg_ans, SUM(CAST(REPLACE(vl_saldo_final, ',', '.') AS DECIMAL(15,2))) AS total_gastos FROM demonstracoes_contabeis 
		WHERE data = '2024-10-01' AND descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR ' 
		GROUP BY reg_ans ORDER BY total_gastos DESC LIMIT 10) B ON A.registro_ans = B.reg_ans ORDER BY B.total_gastos DESC;


SELECT A.razao_social, B.total_gastos FROM operadoras_de_plano_de_saude_ativas A JOIN 
	(SELECT reg_ans, SUM(CAST(REPLACE(vl_saldo_final, ',', '.') AS DECIMAL(15,2))) AS total_gastos FROM demonstracoes_contabeis 
		WHERE EXTRACT(YEAR FROM data) = 2024 AND descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR ' 
		GROUP BY reg_ans ORDER BY total_gastos DESC LIMIT 10) B ON A.registro_ans = B.reg_ans ORDER BY B.total_gastos DESC;