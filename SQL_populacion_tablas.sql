-- Populación de tablas BEGIN

USE tp1_mundial_tk;

-- limpiamos todas las tablas en este preciso órden para poder popularlas de nuevo
-- DELETE FROM Inscripcion;
-- DELETE FROM Competidor;
-- DELETE FROM Maestro;
-- DELETE FROM Coach;
-- DELETE FROM Escuela;
-- DELETE FROM Equipo;
-- DELETE FROM Categoria;
-- DELETE FROM Competencia;
-- DELETE FROM Modalidad;
-- DELETE FROM PresidenteDeMesa;
-- DELETE FROM Suplente;
-- DELETE FROM Arbitro;
-- DELETE FROM Juez;
-- DELETE FROM Graduacion;
-- DELETE FROM Pais;



-- id_pais, nombre
INSERT INTO Pais values (1, 'ARGENTINA');
INSERT INTO Pais values (2, 'PARAGUAY');
INSERT INTO Pais values (3, 'CHILE');
INSERT INTO Pais values (4, 'MEXICO');
INSERT INTO Pais values (5, 'COLOMBIA');

-- id_escuela, nombre
insert into Escuela values (1, 'escuelaArg1');
insert into Escuela values (2, 'escuelaArg2');
insert into Escuela values (3, 'escuelaPar1');
insert into Escuela values (4, 'escuelaPar2');
insert into Escuela values (5, 'escuelaChi1');
insert into Escuela values (6, 'escuelaChi2');
insert into Escuela values (7, 'escuelaMex1');
insert into Escuela values (8, 'escuelaMex2');
insert into Escuela values (9, 'escuelaCol1');
insert into Escuela values (10, 'escuelaCol2');

-- id_graduacion, dan
insert into Graduacion values (1, 1);
insert into Graduacion values (2, 2);
insert into Graduacion values (3, 3);
insert into Graduacion values (4, 4);
insert into Graduacion values (5, 5);
insert into Graduacion values (6, 6);

-- id_maestro, nombre, apellido, placa, id_pais, id_escuela, id_graduacion
insert into Maestro values (1, 'nombre1','apellido1',1,1,1,1);
insert into Maestro values (2, 'nombre2','apellido2',2,1,2,2);
insert into Maestro values (3, 'nombre3','apellido3',3,2,3,3);
insert into Maestro values (4, 'nombre4','apellido4',4,5,10,4);
insert into Maestro values (5, 'nombre5','apellido5',5,4,7,5);
insert into Maestro values (6, 'nombre6','apellido6',6,4,8,6);
insert into Maestro values (7, 'nombre7','apellido7',7,2,4,3);
insert into Maestro values (8, 'nombre8','apellido8',8,3,5,1);
insert into Maestro values (9, 'nombre9','apellido9',9,5,10,5);
insert into Maestro values (10, 'nombre10','apellido10',10,1,1,6);
insert into Maestro values (11, 'nombre11','apellido11',11,4,8,6);
insert into Maestro values (12, 'nombre12','apellido12',12,3,6,2);
insert into Maestro values (13, 'nombre13','apellido13',13,2,3,1);
insert into Maestro values (14, 'nombre14','apellido14',14,1,2,3);
insert into Maestro values (15, 'nombre15','apellido15',15,4,8,4);
insert into Maestro values (16, 'nombre16','apellido16',16,5,9,5);
insert into Maestro values (17, 'nombre17','apellido17',17,1,2,6);
insert into Maestro values (18, 'nombre18','apellido18',18,2,3,5);
insert into Maestro values (19, 'nombre19','apellido19',19,5,9,3);
insert into Maestro values (20, 'nombre20','apellido20',20,2,3,2);

-- id_equipo, nombre
insert into Equipo values (1, 'Boca Juniors TKD');
insert into Equipo values (2, 'Avengers');
insert into Equipo values (3, 'Defenders');
insert into Equipo values (4, 'equipo4');
insert into Equipo values (5, 'equipo5');

-- id_coach, nombre, apellido, fecha_nacimiento, numero_certificado, foto, id_graduacion, id_escuela, id_equipo
insert into Coach values (1, 'nombre_coach_1', 'apellido_coach_2', '1987-05-08', 112233445, 'idjidjiajdisdoaisjdaij', 4, 1, 1);
insert into Coach values (2, 'nombre_coach_2', 'apellido_coach_2', '1987-05-08', 112233446, 'idjidjiajdisdoaisjdaij', 2, 1, 2);
insert into Coach values (3, 'nombre_coach_3', 'apellido_coach_3', '1987-05-08', 112233447, 'idjidjiajdisdoaisjdaij', 3, 2, 3);
insert into Coach values (4, 'nombre_coach_4', 'apellido_coach_4', '1987-05-08', 112233448, 'idjidjiajdisdoaisjdaij', 5, 3, 4);
insert into Coach values (5, 'nombre_coach_5', 'apellido_coach_5', '1987-05-08', 112233449, 'idjidjiajdisdoaisjdaij', 6, 4, 5);

-- id_competidor, nombre, apellido, DNI, fecha_nacimiento, numero_certificado, genero, foto, id_graduacion, id_escuela, id_equipo_titular, id_equipo_suplente, id_coach, id_pais
insert into Competidor values (1, 'nombre_competidor_1', 'apellido_competidor_1', '11111111', '1987-05-08', 123, 'M', 'iajdhahdoaushdauh', 1, 1, null, null, 1,1);
insert into Competidor values (2, 'nombre_competidor_2', 'apellido_competidor_2', '11111112', '1987-05-09', 124, 'F', 'iajdhahdoaushdauh', 2, 1, 1, null, 1,2);
insert into Competidor values (3, 'nombre_competidor_3', 'apellido_competidor_3', '11111113', '1987-05-10', 125, 'M', 'iajdhahdoaushdauh', 1, 1, 3, null, 3,3);
insert into Competidor values (4, 'nombre_competidor_4', 'apellido_competidor_4', '11111114', '1987-05-11', 126, 'F', 'iajdhahdoaushdauh', 4, 1, null, null, 1,4);
insert into Competidor values (5, 'nombre_competidor_5', 'apellido_competidor_5', '11111115', '1987-05-12', 127, 'F', 'iajdhahdoaushdauh', 2, 1, null, 2, 2,5);
insert into Competidor values (6, 'nombre_competidor_6', 'apellido_competidor_6', '11111116', '1987-05-13', 128, 'M', 'iajdhahdoaushdauh', 3, 1, null, 2, 2,1);
insert into Competidor values (7, 'nombre_competidor_7', 'apellido_competidor_7', '11111117', '1987-05-14', 129, 'F', 'iajdhahdoaushdauh', 3, 2, null, null, 1,2);
insert into Competidor values (8, 'nombre_competidor_8', 'apellido_competidor_8', '11111118', '1987-05-15', 130, 'M', 'iajdhahdoaushdauh', 5, 2, null, null, 4,3);
insert into Competidor values (9, 'nombre_competidor_9', 'apellido_competidor_9', '11111119', '1987-05-16', 131, 'F', 'iajdhahdoaushdauh', 2, 3, null, null, 5,4);
insert into Competidor values (10, 'nombre_competidor_10', 'apellido_competidor_10', '11111110', '1987-05-17', 132, 'M', 'iajdhahdoaushdauh', 1, 3, null, null, 5,5);

-- id_categoria, genero, rango_edad, rango_peso
insert into Categoria values (1, 'F','peso1','edad1');
insert into Categoria values (2, 'F','peso2','edad2');
insert into Categoria values (3, 'F','peso3','edad3');
insert into Categoria values (4, 'F','peso4','edad4');

-- id_modalidad, nombre
insert into Modalidad values (1, 'modaliad1');
insert into Modalidad values (2, 'modaliad2');
insert into Modalidad values (3, 'modaliad3');

-- id_competencia, id_graduacion, id_categoria, id_modalidad, primer_puesto, segundo_puesto, tercer_puesto
insert into Competencia values (1,1,1,1, 1, 2, 3);
insert into Competencia values (2,1,2,1, 1, 4, 5);
insert into Competencia values (3,2,2,1, 3, 5, 2);

-- id_competencia, id_maestro, id_competidor, fecha_alta
insert into Inscripcion values (1,1,1,now());
insert into Inscripcion values (1,2,2,now());
insert into Inscripcion values (1,3,3,now());
insert into Inscripcion values (2,3,1,now());
insert into Inscripcion values (2,4,5,now());
insert into Inscripcion values (2,3,4,now());
insert into Inscripcion values (2,3,2,now());
insert into Inscripcion values (3,2,3,now());



insert into Arbitro values (1,'pepe','sanchez',1,100,1,1);
insert into Arbitro values (2,'pepe','sanchez',1,150,1,2);
insert into Arbitro values (3,'pepe','sanchez',3,301,1,3);
insert into Arbitro values (4,'pepe','sanchez',1,123,2,1);
insert into Arbitro values (5,'pepe','sanchez',1,154,2,2);
insert into Arbitro values (6,'pepe','sanchez',3,345,2,3);
insert into Arbitro values (7,'pepe','sanchez',2,211,2,3);

insert into Juez values (1);
insert into Juez values (2);
insert into Juez values (4);
insert into Juez values (5);
insert into PresidenteDeMesa values (7);
insert into Suplente values (6);
insert into Suplente values (3);




-- Populación de tablas END