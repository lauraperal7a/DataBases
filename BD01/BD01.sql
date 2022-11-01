-- Mostrar los vídeos con duración mayor a 300000 ms.
SELECT * FROM video
WHERE duracion > 300000;

-- Mostrar los vídeos que tengan más dislikes que likes.
SELECT * FROM video
WHERE cantidadLikes < cantidadDislikes;

-- Mostrar los usuarios cuyo país sea Argentina.
SELECT * FROM usuario
LEFT JOIN pais ON usuario.Pais_idPais = pais.idPais
WHERE pais.nombre = 'Argentina';

-- Mostrar los usuarios cuya contraseña tenga como segundo caracter una A sin importar la longitud de la contraseña.
SELECT * FROM usuario
WHERE password LIKE '_A%';

-- Mostrar vídeos que hayan sido publicados en el mes de Mayo.
SELECT * FROM video
WHERE MONTH(fechaPublicacion) = 5;