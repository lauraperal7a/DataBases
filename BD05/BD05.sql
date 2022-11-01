DELIMITER $$
CREATE FUNCTION calcular_edad(pi_fecha_nacimiento DATE) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE edad INT;
    SET edad = TIMESTAMPDIFF(YEAR, pi_fecha_nacimiento, CURDATE());
	RETURN edad;
END$$
DELIMITER ;

ALTER TABLE empleados
ADD Edad INT;

DELIMITER $$
CREATE PROCEDURE actualizar_edad()
BEGIN
	UPDATE empleados
    SET Edad = calcular_edad(fecha_nacimiento);
END$$
DELIMITER ;

CALL actualizar_edad();