#Clase de Repaso 

#Nombre de SP: Sp_Prestamo
#Objetivo: generar un prestamo con x cantidad de cuotas para una persona

#Parametros:
	#codigoCliente 			IN	INT
    #importe				IN	DOUBLE
    #fechaInicioPrestamo	IN	DATE
    #CantidadCuotas			IN	TINYINT
    #tipo					IN	TINYINT

#Logica

#validar que la edad de la persona este entre 18 y 80 (CodCliente --> fecha de nacimiento)
#validar que a la fecha final del prestamo la persona no tenga 80 anios (CodCliente --> fecha de nacimiento, fechaInicioPrestamo ,CantidadCuotas)
#validar del monto del prestamo (CodCliente --> Scoring.MaxImporte ,  importe)

#Genero las cuotas --> en la tabla temporal
#Si tipo = simulacion
	#Muestro
#Si tipo = otorgamiento
    #Insertar las cuotas en la tabla correspondiente

#Parametros (solo lo declaramos cuando creamos/modificamos la firma de un procedimiento ):
	# IN 	:  	Parametros de entrada. A cada parametro le asigno un valor y el sp toma ese valor para realizar operacion
    # OUT 	:	Parametros de salida. 	
    # INOUT	:	Parametro de entrada/salida

#select  c.*, s.* from scoring s inner join clientes c on c.scoring_idScoring = s.idScoring;

DELIMITER $$ 
CREATE FUNCTION udf_isAgeInRange(pi_fecha_nacimiento DATE)  returns tinyint 
deterministic
begin 
DECLARE resultado TINYINT(1) DEFAULT 0;

IF TIMESTAMPDIFF(YEAR,pi_fecha_nacimiento, curdate()) BETWEEN 18 AND 80 THEN 
	SET resultado = 1;
END IF;

RETURN resultado;

end 
$$

#Test function 
select udf_isAgeInRange('2020-01-01')


#validar del monto del prestamo 
DELIMITER $$ 
CREATE FUNCTION udf_isImporteMenorAImporteMaximo(pi_codigo_cliente INT, pi_importe_prestamo DOUBLE)  returns tinyint 
deterministic
begin 
DECLARE resultado TINYINT(1) DEFAULT 0;

SET resultado = (SELECT  CASE WHEN s.MaximoImporte < pi_importe_prestamo THEN 0 ELSE 1 END  
from scoring s inner join clientes c on c.scoring_idScoring = s.idScoring);

RETURN resultado;

end 
$$


DELIMITER $$
CREATE PROCEDURE  SP_PRESTAMO(IN pi_codigoCliente INT, IN pi_importe DOUBLE,IN pi_fechaInicioPrestamo DATE
							, IN pi_CantidadCuotas TINYINT, IN pi_tipo TINYINT, OUT po_mensaje_error VARCHAR(200), OUT po_codigo_error TINYINT)

BEGIN 

	declare valorCuota decimal(10,2) default 1;
    declare vCuota int ;
    declare fechaCuota date;
    DECLARE id_prestamo INT;

#Logica 
#validar que la edad de la persona este entre 18 y 80 (CodCliente --> fecha de nacimiento)
DECLARE fecha_nacimiento DATE;

SET fecha_nacimiento = (SELECT fecha_nac FROM clientes c WHERE c.idClientes = pi_codigoCliente);

IF 	udf_isAgeInRange(fecha_nacimiento) = 1
	AND fn_validaedad(fecha_nacimiento, pi_fechaInicioPrestamo, pi_CantidadCuotas)  = 1
    AND udf_isImporteMenorAImporteMaximo(pi_codigoCliente, pi_importe) = 1
THEN 

#Generar cuotas

    CALL SP_Genera_cuota(pi_importe  , pi_fechaInicioPrestamo, pi_CantidadCuotas);

	IF pi_tipo = 1 THEN 
		SELECT 
			nrocuota as 'Nro de Cuota ',
			DATE_FORMAT(fecha,'%d %M %Y') as 'Fecha de Cuota',
			importe as 'Valor Cuota'
		FROM tmpCuotas;
	ELSE IF pi_tipo = 2 THEN 
    
		INSERT INTO prestamo(idCliente, fecha, importe, cantcuotas) 
		VALUES (pi_codigoCliente, now(), pi_importe, pi_CantidadCuotas);
        
        SET id_prestamo = LAST_INSERT_ID();
    
		INSERT INTO cuotas(idCuotas, idprestamo, fecha, importe) 
        SELECT 
			nrocuota, id_prestamo, fecha, importe
		FROM tmpCuotas;
        
    END IF;
	END IF;

END IF;

END;

$$


DELIMITER $$
CREATE PROCEDURE SP_Prestamo_Master (IN codigoCliente INT, IN importe DOUBLE, INOUT pio_fechaInicioPrestamo DATE
							, IN CantidadCuotas TINYINT, IN tipo TINYINT)
BEGIN 

DECLARE mensaje_error VARCHAR(200);
DECLARE codigo_error TINYINT;


CALL SP_PRESTAMO (1, 100.50, pio_fechaInicioPrestamo, 5, 1, mensaje_error, codigo_error); 
# Pregunto por los parametros de salida del sp
IF codigo_error != 0 THEN  # 0  ES NO HAY ERROR
SELECT mensaje_error;
END IF;	

SET pio_fechaInicioPrestamo = DATE_ADD(pio_fechaInicioPrestamo, INTERVAL 4 DAY);

END;$$

SET @fechaInicio = '2022-11-08';
CALL SP_Prestamo_Master (1, 100.50, fechaInicio, 5,1);
select @fechaInicio



# Prueba de SQL es un MUST SABER GROUP BY Y HAVING

