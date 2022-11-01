-- 1) Empleados
-- a) Crear un SP que liste los apellidos, nombres y edad de los empleados ordenados alfabéticamente.
-- Tip: Para la edad, crear una función que tenga como parámetro de entrada la fecha de nacimiento y devuelva la edad.
-- b) Invocar el SP para verificar el resultado.

DELIMITER $$
CREATE FUNCTION calcular_edad(fecha_nacimiento DATE) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE edad INT;
	SET edad = YEAR(CURDATE())-YEAR(fecha_nacimiento);
	RETURN edad;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE info_empleados()
BEGIN
	SELECT Apellido, Nombre, calcular_edad(DATE(FechaNacimiento)) AS Edad FROM empleados
    ORDER BY Apellido;
END $$
DELIMITER ;

CALL info_empleados();

-- 2) Empleados por ciudad
-- a) Crear un SP que reciba el nombre de una ciudad y liste los empleados de esa ciudad que sean mayores a 25 años.
-- Tip: Utilizar la función creada en punto 1.
-- b) Invocar al SP para listar los empleados de London.

DELIMITER $$
CREATE PROCEDURE sp_empleados_ciudad(IN city VARCHAR(15))
BEGIN
	SELECT Apellido, Nombre, calcular_edad(DATE(FechaNacimiento)) AS Edad FROM empleados
    WHERE Ciudad = city AND calcular_edad(DATE(FechaNacimiento)) > 25;
END $$
DELIMITER ;

CALL sp_empleados_ciudad('London');

-- 3) Clientes por país
-- a) Crear un SP que liste los apellidos, nombres, edad y la diferencia en años de edad con el
-- valor máximo de edad que tiene la tabla de clientes.
-- Tip: Utilizar la función creada en punto 1. Crear una función que devuelva la fecha de
-- nacimiento mínima de la tabla clientes.

DELIMITER $$
CREATE FUNCTION calcular_fecha_nacimiento_mínima() RETURNS DATE DETERMINISTIC
BEGIN
	DECLARE fecha_minima DATE;
	SET fecha_minima = (SELECT MIN(FechaNacimiento) FROM empleados);
	RETURN fecha_minima;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE listar_con_diferencia_edad()
BEGIN
	DECLARE edad_maxima INT;
    SET edad_maxima = calcular_edad(calcular_fecha_nacimiento_mínima());
	SELECT Apellido, Nombre, calcular_edad(DATE(FechaNacimiento)) AS Edad, (edad_maxima - calcular_edad(DATE(FechaNacimiento))) AS Diferencia FROM empleados;
END $$
DELIMITER ;

CALL listar_con_diferencia_edad();