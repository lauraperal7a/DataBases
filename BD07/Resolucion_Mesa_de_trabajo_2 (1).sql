-- En una base cualquiera, vamos a generar un SP que reciba por parámetros diferentes números en un varchar separados por ;. Utilizar LOOP para recorrerlos.
-- Importante: al final siempre poner un ;. Un ejemplo, '10;66;138;37;-72;0.5;'. El SP devolverá 2 parámetros: la suma total entre ellos y el promedio de los mismos.
-- Solo debemos sumar y promediar los números que son positivos. Validar lo dicho anteriormente con un CASE. Suponemos que siempre se recibe al menos 1 número.
DELIMITER $$
CREATE PROCEDURE numeros (IN numeros VARCHAR(100), OUT suma DOUBLE, OUT promedio DOUBLE)
BEGIN
	DECLARE cantidad INT DEFAULT 0;
	SET suma = 0;
	numeros_loop: LOOP
		SET cantidad = cantidad + 1;
        CASE WHEN (CAST(LEFT(numeros, LOCATE(';', numeros) - 1) AS DOUBLE) > 0) THEN
			SET suma = suma + CAST(LEFT(numeros, LOCATE(';', numeros) - 1) AS DOUBLE);
		ELSE
			SET cantidad = cantidad - 1;
		END CASE;
		SET numeros = RIGHT(numeros, CHAR_LENGTH(numeros) - LOCATE(';', numeros));
        IF (LOCATE(';', numeros) = 0) THEN
			LEAVE numeros_loop;
		END IF;
    END LOOP;
    SET promedio = suma / cantidad;
END $$

CALL numeros ('10;66;138;37;-72;0.5;', @suma, @promedio);
SELECT @suma, @promedio;