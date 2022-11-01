-- 1. Listar todos los países que contengan la letra A, ordenada alfabéticamente.
SELECT * FROM pais
WHERE nombre LIKE '%A%'
ORDER BY nombre;

-- 2. Generar un listado de los usuarios, con el detalle de todos sus datos, el avatar que
-- poseen y a qué país pertenecen.
SELECT u.nombre, u.email, u.password, u.fechaNacimiento, u.codigoPostal, a.nombre AS avatar, p.nombre AS pais FROM usuario u
INNER JOIN avatar a ON u.Avatar_idAvatar = a.idAvatar
INNER JOIN pais p ON u.Pais_idPais = p.idPais;

-- 3. Confeccionar un listado con los usuarios que tienen playlists, mostrando la cantidad
-- que poseen.
SELECT u.nombre, COUNT(p.idPlaylist) AS Cantidad_Playlist FROM usuario u
INNER JOIN playlist p ON u.idUsuario = p.Usuario_idUsuario
GROUP BY u.nombre;

-- 4. Mostrar todos los canales creados entre el 01/04/2021 y el 01/06/2021.
SELECT * FROM canal
WHERE fechaCreacion BETWEEN '2021-04-01 00:00:00' AND '2021-06-01 00:00:00';

-- 5. Mostrar los 5 videos de menor duración, listando el título del vídeo, la o las etiquetas
-- que poseen, el nombre de usuario y país al que corresponden.
SELECT v.titulo, v.duracion, COUNT(e.nombre) AS etiquetaS, u.nombre AS usuario, p.nombre AS pais FROM video v
INNER JOIN video_etiqueta ve ON v.idVideo = ve.Video_idVideo
INNER JOIN etiqueta e ON e.idEtiqueta = ve.Etiqueta_idEtiqueta
INNER JOIN usuario u ON v.Usuario_idUsuario = u.idUsuario
INNER JOIN pais p ON u.Pais_idPais = p.idPais
GROUP BY v.titulo
ORDER BY v.duracion
LIMIT 5;

-- 6. Listar todas las playlists que posean menos de 3 videos, mostrando el nombre de
-- usuario y el avatar que poseen.
SELECT u.nombre nombreUsuario, (SELECT a.nombre FROM avatar a WHERE u.Avatar_idAvatar = a.idAvatar) avatar, p.nombre nombrePlaylist, COUNT(pv.Video_idVideo) cantidadVideos
FROM playlist p
INNER JOIN playlist_video pv ON p.idPlaylist = pv.Playlist_idPlaylist
INNER JOIN video v ON v.idVideo = pv.Video_idVideo
LEFT JOIN usuario u ON u.idUsuario = p.Usuario_idUsuario
GROUP BY pv.Playlist_idPlaylist
HAVING cantidadVideos < 3;

-- 7. Insertar un nuevo avatar y asignarlo a un usuario.
INSERT INTO avatar (idAvatar, nombre, urlImagen) 
VALUES (DEFAULT,'MEME','Url');
UPDATE usuario
SET Avatar_idAvatar = (SELECT idAvatar FROM avatar WHERE nombre = 'MEME')
WHERE idUsuario = 1;

-- 8. Generar un informe estilo ranking de avatares utilizados por país.
SELECT a.nombre AS avatar, p.nombre AS pais, COUNT(a.idAvatar) AS ranking FROM avatar a
INNER JOIN usuario u ON a.idAvatar = u.Avatar_idAvatar
INNER JOIN pais p ON u.Pais_idPais = p.idPais
GROUP BY avatar, p.nombre
ORDER BY ranking DESC;

-- 9. Insertar un usuario con los siguientes datos:
-- a. Nombre: Roberto Rodriguez
-- b. E-mail: rrodriguez@dhtube.com
-- c. Password: rr1254
-- d. Fecha de nacimiento: 01 de noviembre de 1975
-- e. Código postal: 1429
-- f. País: Argentina
-- g. Avatar: carita feliz
INSERT INTO usuario (nombre, email, password, fechaNacimiento, codigoPostal, Pais_idPais,Avatar_idAvatar) VALUES
("Roberto Rodriguez","rrodriguez@dhtube.com","rr1254","1975-11-01 00:00:00", "1429",9,85);

-- 10. Generar un reporte de todos los videos y sus etiquetas, pero solo de aquellos cuyos
-- nombres de la etiqueta contengan menos de 10 caracteres, ordenado
-- ascendentemente por la cantidad de caracteres que posea la etiqueta.
SELECT v.titulo, v.descripcion, v.tamanio, v.duracion, v.imagen, v.cantidadReproducciones, v.cantidadLikes, v.cantidadDislikes, e.nombre AS Etiqueta FROM video v
INNER JOIN video_etiqueta ve ON v.idVideo = ve.Video_idVideo
INNER JOIN etiqueta e ON e.idEtiqueta = ve.Etiqueta_idEtiqueta
WHERE LENGTH(e.nombre) < 10
ORDER BY LENGTH(e.nombre);