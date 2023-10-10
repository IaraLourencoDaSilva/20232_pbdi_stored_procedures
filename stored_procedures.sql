-- Exercicio

-- 1.2 Adicione um procedimento ao sistema do restaurante. Ele deve
-- - receber um parâmetro de entrada (IN) que representa o código de um cliente
-- - exibir, com RAISE NOTICE, o total de pedidos que o cliente tem

CREATE OR REPLACE PROCEDURE sp_add_procedimento(
	IN cod_cliente INT
)
LANGUAGE plpgsql
AS $$
DECLARE
	total_pedidos INT;
BEGIN 
	SELECT COUNT(*) INTO total_pedidos
	FROM tb_pedido
	WHERE cod_cliente = cod_cliente;
	
	RAISE NOTICE 'O total de pedido é: %', total_pedidos;
END;
$$



-- 1.1 Adicione uma tabela de log ao sistema do restaurante. Ajuste cada procedimento para
-- que ele registre
-- - a data em que a operação aconteceu
-- - o nome do procedimento executado

-- Procedimento original de inserção na tb_cliente
-- CREATE OR REPLACE PROCEDURE sp_inserir_cliente(
-- 	IN nome VARCHAR(200)
-- )LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     INSERT INTO tb_cliente(nome) VALUES (nome);
-- END;
-- $$

-- -- Ajuste o procedimento para registrar no log
-- CREATE OR REPLACE PROCEDURE sp_inserir_cliente_com_log(
-- 	nome_cliente VARCHAR(200)
-- ) LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     INSERT INTO tb_cliente (nome) VALUES (nome);
--     INSERT INTO tb_log (nome_procedimento) VALUES ('inserir_cliente_com_log');
-- END;
-- $$



-- CREATE TABLE IF NOT EXISTS tb_log (
--     cod_log SERIAL PRIMARY KEY,
--     data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     nome_procedimento VARCHAR(200) NOT NULL
-- );






--nome: sp_cadastrar_cliente
--parametros:
--1. modo IN, se chama nome, varchar(200)
--2. modo in, se codigo, tipo int, valor padrão null
-- se o codigo for null, fazer cadastro sem especificá-lo
--se o codigo não for null, fazer cadstro especificando também 
-- CREATE OR REPLACE PROCEDURE sp_cadastrar_cliente(
-- 	IN nome VARCHAR(200),
-- 	IN cod_tipo INT DEFAULT NULL
-- )
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- 	IF cod_tipo IS NULL THEN
-- 		INSERT INTO tb_clientes(nome) VALUES (nome);
-- 	ELSE
-- 		INSERT INTO tb_clientes VALUES (nome, cod_tipo);
-- 	END IF;
-- END;
-- $$



-- CREATE TABLE IF nOT EXISTS tb_cliente(
-- 	cod_cliente SERIAL PRIMARY KEY,
-- 	nome VARCHAR(200) NOT NULL
-- );

-- CREATE TABLE IF NOT EXISTS tb_pedido(
-- 	cod_pedido SERIAL PRIMARY KEY,
-- 	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
-- 	data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
-- 	status VARCHAR DEFAULT 'aberto',
-- 	cod_cliente INT NOT NULL,
-- 	CONSTRAINT fk_cliente FOREIGN KEY (cod_cliente) REFERENCES tb_cliente(cod_cliente)
-- );

-- CREATE TABLE IF NOT EXISTS tb_tipo_item(
-- 	cod_tipo SERIAL PRIMARY KEY,
-- 	descricao VARCHAR(200) NOT NULL
-- );
-- INSERT INTO tb_tipo_item (descricao) values
-- ('Bebida'), ('Comida');

-- SELECT * FROM tb_tipo_item;

-- CREATE TABLE IF NOT EXISTS tb_item(
-- 	cod_item SERIAL PRIMARY KEY,
-- 	descricao VARCHAR(200) NOT NULL,
-- 	valor NUMERIC(10, 2) NOT NULL,
-- 	cod_tipo INT NOT NULL,
-- 	CONSTRAINT fk_tipo_item FOREIGN KEY (cod_tipo) REFERENCES tb_tipo_item(cod_tipo)
-- );

-- INSERT INTO tb_item 
-- (descricao, valor, cod_tipo)
-- VALUES
-- ('Refrigerante', 7, 1),
-- ('Suco', 8, 1),
-- ('Hambirguer', 12, 2),
-- ('Batata Frita', 9, 2);

-- SELECT * FROM tb_item;

-- CREATE TABLE IF NOT EXISTS tb_item_pedido(
-- 	--surrogate key
-- 	cod_item_pedido SERIAL PRIMARY KEY,
-- 	cod_item INT,
-- 	cod_pedido INT,
-- 	CONSTRAINT fk_item FOREIGN KEY (cod_item) REFERENCES tb_item(cod_item),
-- 	CONSTRAINT fk_pedido FOREIGN KEY (cod_pedido) REFERENCES tb_pedido(cod_pedido)
-- );

--Não tem como colocar vazio
-- CALL sp_calcula_media(1);
-- CALL sp_calcula_media(2,3);
-- CALL sp_calcula_media(8,5,6,7,4,1);
-- CALL sp_calcula_media(ARRAY[1,2]);

--variadic (varargs do java ou variable length do python)
-- CREATE OR REPLACE PROCEDURE sp_calcula_media(
-- 	VARIADIC p_valores INT []
-- )
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
-- 	v_media NUMERIC (10, 2) := 0;
-- 	v_valor INT;
-- BEGIN
-- 	FOREACH v_valor IN ARRAY p_valores LOOP
-- 		v_media := v_media + v_valor;
-- 	END LOOP;
-- 	RAISE NOTICE 
-- 		'A média é: %', 
-- 		v_media / array_length(p_valores, 1);
-- END;
-- $$


--colocando em execução
-- DO $$
-- DECLARE 
-- 	v1 INT := 20;
-- 	v2 INT := 3;
-- BEGIN
-- 	CALL sp_acha_maior(v1, v2);
-- 	RAISE NOTICE '% é o maior', v1;
-- END;
-- $$

-- DROP PROCEDURE IF EXISTS sp_acha_maior;
-- CREATE OR REPLACE PROCEDURE sp_acha_maior(
-- 	INOUT valor1 INT,
-- 	IN valor2 INT
-- )
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- 	IF valor2 > valor1 THEN
-- 		valor1 := valor2;
-- 	END IF;
-- END;
-- $$

-- --bloquinho anônimo
-- DO $$
-- DECLARE
-- 	resultado INT;
-- BEGIN 
-- 	CALL sp_acha_maior(resultado, 2, 3);
-- 	RAISE NOTICE '% é o maior', resultado;
-- END;
-- $$


-- --Aqui estamos removendo o proc de nome sp_acha_maior para pode reutilizar o nome 
-- DROP PROCEDURE IF EXISTS sp_acha_maior;
-- CREATE OR REPLACE PROCEDURE 
-- sp_acha_maior(
-- 		OUT resultado INT,
-- 		IN valor1 INT,
-- 		IN valor2 INT
-- 	)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN 
-- 	CASE
-- 		WHEN valor1 > valor2 THEN
-- 			$1 := valor1;
-- 		ELSE
-- 			resultado := valor2;
-- 	END CASE;
-- END;
-- $$


-- --Colocando em execução 
-- CALL sp_acha_maior(3,2);


-- --Criando 
-- --Ambos são IN, pois IN é o padrão 
-- CREATE OR REPLACE PROCEDURE sp_acha_maior(
-- 	IN valor1 INT,
-- 	Valor2 INT
-- )
-- LANGUAGE plpgsql 
-- AS $$
-- BEGIN 
-- 	IF valor1 > valor2 THEN 
-- 		RAISE NOTICE '% é o maior', $1;
-- 	ELSE
-- 		RAISE NOTICE '% é o maior', $2;
-- 	END IF;
-- END;
-- $$

-- --colocando em execução 
-- CALL sp_ola_usuario('Pedro')

-- --Criando 
-- CREATE OR REPLACE PROCEDURE sp_ola_usuario(nome VARCHAR(200))
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN 
-- 	--acessando parâmetro pelo nome 
-- 	RAISE NOTICE 'Olá, %', nome;
-- 	--assim também vale 
-- 	RAISE NOTICE 'Olá, %', $1;
-- END;
-- $$

-- -- OR REPLACE Opcional 
-- -- Se o proc Ainda Não existir, ele será criado
-- -- Se já existir, será substituído
-- CREATE OR REPLACE PROCEDURE sp_ola_procedures()
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- 	RAISE NOTICE 'Olá, procedures';
-- END;
-- $$

-- CALL sp_ola_procedures();