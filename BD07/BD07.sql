-- 1. En una base de datos cualquiera, debemos confeccionar un stored procedure que le
-- enviemos un entero comprendido entre 0 y 999 inclusive. El segundo parámetro debe
-- retornar la cantidad de dígitos que tiene dicho número. Debemos utilizar la sentencia IF.
DELIMITER $$
CREATE PROCEDURE sp_cantidad_digitos(IN pi_numero INT, OUT po_cantidad INT)
BEGIN
	IF (pi_numero > 999) THEN SET po_cantidad = NULL;
    -- MEJORAR LÓGICA
    ELSE SET po_cantidad = CHAR_LENGTH(pi_numero);
    -- Otra opción
    -- ELSE SET po_cantidad = LENGTH(CAST(pi_numero AS CHAR(3)));
    END IF;
END$$
DELIMITER ;

CALL sp_cantidad_digitos(159, @cantidad);
SELECT @cantidad;

-- 2. En la base de datos Musimundos, vamos a generar un SP donde le vamos a pasar por
-- parámetro diferentes nombres de géneros en un varchar separados por |. Importante: al final
-- siempre poner un |. Un ejemplo, 'Trap|Reggaeton|House|'. Luego, debemos insertar cada uno
-- de ellos en nuestra tabla de géneros. Utilizar la sentencia WHILE. Tener en cuenta que para
-- insertar el id, debemos ir a buscar el último número de id de la tabla de géneros.

DELIMITER $$
CREATE PROCEDURE sp_insertar_generos(IN pi_generos VARCHAR(100))
BEGIN
	DECLARE ultimo_id TINYINT;
    DECLARE nuevo_genero VARCHAR(50);
    WHILE (LOCATE('|', pi_generos) != 0) DO
    SET ultimo_id = (SELECT MAX(id) FROM generos);
    SET nuevo_genero = LEFT(pi_generos,LOCATE('|', pi_generos)-1);
    INSERT INTO generos VALUES (ultimo_id+1, nuevo_genero);
    SET pi_generos = SUBSTRING(pi_generos, LOCATE('|', pi_generos)+1);
    END WHILE;
END$$
DELIMITER ;

CALL sp_insertar_generos('Trap|Reggaeton|House|');