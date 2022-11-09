-- 1. Necesitamos crear un procedimiento almacenado que inserta un cliente,
-- SP_Cliente_Insert que recibe los datos del cliente y lo inserta en caso que no exista
-- un cliente con el mismo número de DNI o Cédula de identidad.
DELIMITER $$
CREATE PROCEDURE sp_cliente_insert(n_cedulaident VARCHAR(10), n_apellido VARCHAR(45), n_nombres VARCHAR(100), n_fecha_nac DATE, n_Scoring_idScoring INT)
BEGIN
	IF NOT EXISTS (SELECT * FROM clientes WHERE cedulaident = n_cedulaident) THEN
	INSERT INTO clientes VALUES (DEFAULT, n_cedulaident, n_apellido, n_nombres, n_fecha_nac, n_Scoring_idScoring);
    END IF;
END$$
DELIMITER ;

CALL sp_cliente_insert('123456', 'Asd', 'Pepito Pig', '2010-02-05', 1);
CALL sp_cliente_insert('123456', 'Qwe', 'Pepito Pig', '2010-02-05', 2);
CALL sp_cliente_insert('789654', 'Pochi', 'Panchita', '2010-02-06', 3);
CALL sp_cliente_insert('789654', 'Teletubie', 'Panchita', '2010-02-06', 3);

-- 2. Armar una función fn_ValidadEdad que, dada la fecha de nacimiento de una persona
-- (YYYYMMDD), la fecha de inicio del préstamo (YYYYMMDD) y la cantidad de cuotas,
-- verifique que cumpla con la condición que la persona no tenga más de 80 años al
-- finalizar el préstamo.
DELIMITER $$
CREATE FUNCTION fn_ValidadEdad (fecha_nac DATE, fecha_prestamo DATE, cantidad_cuotas INT) RETURNS VARCHAR(5) DETERMINISTIC
BEGIN
	DECLARE fecha_fin_prestamo DATE;
    DECLARE edad_fin_prestamo INT;
    SET fecha_fin_prestamo = DATE_ADD(fecha_prestamo, INTERVAL cantidad_cuotas MONTH);
    SET edad_fin_prestamo = TIMESTAMPDIFF(YEAR, fecha_nac, fecha_fin_prestamo);
    IF edad_fin_prestamo < 80 THEN RETURN 'True';
    ELSE RETURN 'False';
    END IF;
END$$
DELIMITER ;

SELECT fn_ValidadEdad('1935-05-05','2021-10-02',5);

-- 3. Armar una función fn_diaHabil que, dada una fecha (YYYYMMDD), devuelva la
-- misma fecha si es un día hábil —lunes a viernes— o en caso de no serlo —si es
-- sábado o domingo— devuelva la fecha del primer día hábil siguiente.

-- 4. Crear un stored procedure SP_Genera_Cuota que, dado un importe, fecha de inicio,
-- y cantidad de cuotas, genere el detalle de las cuotas.