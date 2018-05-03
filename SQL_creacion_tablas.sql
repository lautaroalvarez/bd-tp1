-- Reset de los schemas
DROP DATABASE IF EXISTS tp1_mundial_tk;
CREATE DATABASE IF NOT EXISTS tp1_mundial_tk;
USE tp1_mundial_tk;

SELECT 'CREATING DATABASE STRUCTURE' AS 'INFO';

-- Creacion de tablas BEGIN

CREATE TABLE Pais (
  id_pais INTEGER NOT NULL,
  nombre VARCHAR(20),
  PRIMARY KEY (id_pais),
  UNIQUE (nombre)
);

CREATE TABLE Escuela (
  id_escuela INTEGER NOT NULL,
  nombre VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_escuela),
  UNIQUE (nombre)
);

CREATE TABLE Graduacion (
  id_graduacion INTEGER NOT NULL,
  dan INTEGER NOT NULL,
  CONSTRAINT danValido CHECK (dan BETWEEN 1 AND 6),
  PRIMARY KEY (id_graduacion)
);

CREATE TABLE Maestro (
  id_maestro INTEGER NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  apellido VARCHAR(255) NOT NULL,
  placa INTEGER NOT NULL,
  id_pais INTEGER NOT NULL,
  id_escuela INTEGER NOT NULL,
  id_graduacion INTEGER NOT NULL,
  FOREIGN KEY (id_pais) REFERENCES Pais (id_pais),
  FOREIGN KEY (id_escuela) REFERENCES Escuela (id_escuela),
  FOREIGN KEY (id_graduacion) REFERENCES Graduacion (id_graduacion),
  PRIMARY KEY (id_maestro),
  UNIQUE (placa)
);

CREATE TABLE Arbitro (
  id_arbitro INTEGER NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  apellido VARCHAR(255) NOT NULL,
  tipo ENUM('Juez', 'Presidente de Mesa', 'Suplente', 'Central'),
  placa INTEGER NOT NULL,
  id_pais INTEGER NOT NULL,
  id_graduacion INTEGER NOT NULL,
  FOREIGN KEY (id_pais) REFERENCES Pais (id_pais),
  FOREIGN KEY (id_graduacion) REFERENCES Graduacion (id_graduacion),
  PRIMARY KEY (id_arbitro),
  UNIQUE (placa)
);

CREATE TABLE PresidenteDeMesa (
  id_arbitro INTEGER NOT NULL,
  FOREIGN KEY (id_arbitro) REFERENCES Arbitro (id_arbitro),
  PRIMARY KEY (id_arbitro) 
);

CREATE TABLE Juez (
  id_arbitro INTEGER NOT NULL,
  FOREIGN KEY (id_arbitro) REFERENCES Arbitro (id_arbitro)
);

CREATE TABLE Central (
  id_arbitro INTEGER NOT NULL,
  FOREIGN KEY (id_arbitro) REFERENCES Arbitro (id_arbitro)
);

CREATE TABLE Suplente (
  id_arbitro INTEGER NOT NULL,
  FOREIGN KEY (id_arbitro) REFERENCES Arbitro (id_arbitro)
);

CREATE TABLE Equipo (
  id_equipo INTEGER NOT NULL,
  nombre VARCHAR(20),
  PRIMARY KEY (id_equipo),
  UNIQUE (nombre)
);

CREATE TABLE Coach (
  id_coach INTEGER NOT NULL,
  nombre VARCHAR(255),
  apellido VARCHAR(255),
  fecha_nacimiento DATE NOT NULL,
  numero_certificado INTEGER NOT NULL,
  foto VARCHAR(255),
  id_graduacion INTEGER NOT NULL,
  id_escuela INTEGER NOT NULL,
  id_equipo INTEGER NOT NULL,
  FOREIGN KEY (id_graduacion) REFERENCES Graduacion (id_graduacion),
  FOREIGN KEY (id_escuela) REFERENCES Escuela (id_escuela),
  FOREIGN KEY (id_equipo) REFERENCES Equipo (id_equipo), -- para mi un competidor esta solo en un equipo
  PRIMARY KEY (id_coach),
  UNIQUE (numero_certificado)
);

CREATE TABLE Competidor (
  id_competidor INTEGER NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  apellido VARCHAR(255) NOT NULL,
  DNI VARCHAR(20) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  numero_certificado INTEGER NOT NULL,
  genero ENUM('M', 'F'),
  foto VARCHAR(255),
  id_graduacion INTEGER NOT NULL,
  id_escuela INTEGER NOT NULL,
  id_equipo_titular INTEGER,
  id_equipo_suplente INTEGER,
  id_coach INTEGER NOT NULL,
  id_pais INTEGER NOT NULL,
  FOREIGN KEY (id_graduacion) REFERENCES Graduacion (id_graduacion),
  FOREIGN KEY (id_escuela) REFERENCES Escuela (id_escuela),
  FOREIGN KEY (id_equipo_titular) REFERENCES Equipo (id_equipo), -- para mi un competidor esta solo en un equipo
  FOREIGN KEY (id_equipo_suplente) REFERENCES Equipo (id_equipo),
  FOREIGN KEY (id_coach) REFERENCES Coach (id_coach),
  FOREIGN KEY (id_pais) REFERENCES Pais (id_pais),
  PRIMARY KEY (id_competidor),
  UNIQUE (DNI),
  UNIQUE (numero_certificado)
);

-- falta coach que tambien puede ser un competidor!

CREATE TABLE Modalidad (
  id_modalidad INTEGER NOT NULL,
  nombre VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_modalidad),
  UNIQUE (nombre)
);

CREATE TABLE Categoria (
  id_categoria INTEGER NOT NULL,
  genero ENUM('M', 'F'),
  rango_edad VARCHAR(255),
  rango_peso VARCHAR(255),
  PRIMARY KEY (id_categoria)
);

-- faltan las clases hijas de categoria, pero todavia no se si quedaba cambiar algo de esa parte...

CREATE TABLE Competencia (
  id_competencia INTEGER NOT NULL,
  id_graduacion INTEGER, -- podemos no tener una graduacion
  id_categoria INTEGER NOT NULL,
  id_modalidad INTEGER NOT NULL,
  primer_puesto INTEGER,
  segundo_puesto INTEGER,
  tercer_puesto INTEGER,
  FOREIGN KEY (primer_puesto) REFERENCES Competidor (id_competidor),
  FOREIGN KEY (segundo_puesto) REFERENCES Competidor (id_competidor),
  FOREIGN KEY (tercer_puesto) REFERENCES Competidor (id_competidor),
  FOREIGN KEY (id_modalidad) REFERENCES Modalidad (id_modalidad),
  PRIMARY KEY (id_competencia)
);

CREATE TABLE Dirige (
  id_arbitro INTEGER NOT NULL,
  id_competencia INTEGER NOT NULL,
  FOREIGN KEY (id_arbitro) REFERENCES Arbitro (id_arbitro),
  FOREIGN KEY (id_competencia) REFERENCES Competencia (id_competencia),
  PRIMARY KEY (id_arbitro, id_competencia)
);

-- De la ternaria Inscribe
CREATE TABLE Inscripcion (
  id_competencia INTEGER NOT NULL,
  id_maestro INTEGER NOT NULL,
  id_competidor INTEGER NOT NULL,
  fecha_alta DATE NOT NULL,
  -- faltaba algo mas?
  FOREIGN KEY (id_competencia) REFERENCES Competencia (id_competencia),
  FOREIGN KEY (id_maestro) REFERENCES Maestro (id_maestro),
  FOREIGN KEY (id_competidor) REFERENCES Competidor (id_competidor),
  PRIMARY KEY (id_competencia, id_maestro, id_competidor)
);

SELECT 'CREATING TRIGGERS' as 'INFO';

  -- Esto se hace para que el ; no sea delimitador de statements y corte el procedure
DELIMITER //
CREATE TRIGGER IncluirTipoArbitro AFTER INSERT ON Arbitro
FOR EACH ROW
BEGIN
  IF NEW.tipo='Juez' THEN
    INSERT INTO Juez (id_arbitro) VALUES (NEW.id_arbitro);
  ELSEIF NEW.tipo='Central' THEN
    INSERT INTO Central (id_arbitro) VALUES (NEW.id_arbitro);
  ELSEIF NEW.tipo='PresidenteDeMesadeMesa' THEN
    INSERT INTO PresidenteDeMesa (id_arbitro) VALUES (NEW.id_arbitro);
  ELSE
    INSERT INTO Suplente (id_arbitro) VALUES (NEW.id_arbitro);
  END IF;
END;
//

DELIMITER ;

-- Creacion de trigger END

SELECT 'CREATING STORED PROCEDURES' AS 'INFO';

-- Listado de inscriptos por cada categoria
DELIMITER //
CREATE PROCEDURE inscriptosPorCategoria(IN idCategoria INTEGER)
	BEGIN
	SELECT cidor.DNI, cidor.nombre, cidor.apellido FROM Inscripcion AS ins,
		Competencia AS ccia, Competidor AS cidor, Categoria AS cat
			WHERE ins.id_competencia = ccia.id_competencia AND
			cidor.id_competidor = ins.id_competidor AND
			ccia.id_categoria = cat.id_categoria AND
			cat.id_categoria = idCategoria;
	END //
DELIMITER ;

-- Pais con mayor cantidad de medallas de oro
DELIMITER //
CREATE PROCEDURE paisesConMasMedallasOro()
	BEGIN
  SELECT p.nombre from Pais AS p WHERE p.id_pais IN 
  (SELECT co.id_pais FROM Competencia AS c
  INNER JOIN Competidor AS co ON c.primer_puesto = co.id_competidor
  GROUP BY co.id_pais
  ORDER BY COUNT(*) DESC)
  LIMIT 1;
	END //
DELIMITER ;

-- Pais con mayor cantidad de medallas de plata
DELIMITER //
CREATE PROCEDURE paisesConMasMedallasPlata()
	BEGIN
  SELECT p.nombre from Pais AS p WHERE p.id_pais IN 
  (SELECT co.id_pais FROM Competencia AS c
  INNER JOIN Competidor AS co ON c.segundo_puesto = co.id_competidor
  GROUP BY co.id_pais
  ORDER BY COUNT(*) DESC)
  LIMIT 1;
	END //
DELIMITER ;

-- Pais con mayor cantidad de medallas de bronce
DELIMITER //
CREATE PROCEDURE paisesConMasMedallasBronce()
	BEGIN
  SELECT p.nombre from Pais AS p WHERE p.id_pais IN 
  (SELECT co.id_pais FROM Competencia AS c
  INNER JOIN Competidor AS co ON c.tercer_puesto = co.id_competidor
  GROUP BY co.id_pais
  ORDER BY COUNT(*) DESC)
  LIMIT 1;
	END //
DELIMITER ;

-- Ranking por pais
DELIMITER //
CREATE PROCEDURE rankingPorPais()
BEGIN
SELECT p.nombre as 'Pais', q.oro as 'Oro', q.plata as 'Plata', q.bronce as 'Bronce' FROM
  (SELECT m.id_pais,
    SUM(IF(c.primer_puesto IS NULL, 0, 3)) AS oro,
    SUM(IF(c.segundo_puesto IS NULL, 0, 2)) AS plata,
    SUM(IF(c.tercer_puesto IS NULL, 0, 1)) AS bronce
    FROM Competencia c, Inscripcion i, Maestro m
    WHERE c.id_competencia = i.id_competencia AND i.id_maestro = m.id_maestro
    GROUP BY m.id_pais) q
    INNER JOIN Pais p ON q.id_pais = p.id_pais
    ORDER BY q.oro DESC;
  END //
DELIMITER ;

-- Ranking por escuela
DELIMITER //
CREATE PROCEDURE rankingPorEscuela()
BEGIN
SELECT p.nombre as 'Pais', q.oro as 'Oro', q.plata as 'Plata', q.bronce as 'Bronce' FROM
  (SELECT m.id_escuela,
    SUM(IF(c.primer_puesto IS NULL, 0, 3)) AS oro,
    SUM(IF(c.segundo_puesto IS NULL, 0, 2)) AS plata,
    SUM(IF(c.tercer_puesto IS NULL, 0, 1)) AS bronce
    FROM Competencia c, Inscripcion i, Maestro m
    WHERE c.id_competencia = i.id_competencia AND i.id_maestro = m.id_maestro
    GROUP BY m.id_escuela) q
    INNER JOIN Escuela p ON q.id_escuela = p.id_escuela
    ORDER BY q.oro DESC;
  END //
DELIMITER ;

-- Medallero por escuela
DELIMITER //
CREATE PROCEDURE medalleroPorEscuela(IN idEscuela INTEGER)
  BEGIN
  SELECT * FROM Competidor AS c, Competencia as co
  WHERE c.id_competidor IN (co.primer_puesto, co.segundo_puesto, co.tercer_puesto)
  AND c.id_escuela = idEscuela;
  END //
DELIMITER ;

-- Listado de arbitros por pais.
DELIMITER //
CREATE PROCEDURE arbitrosPorPais(IN idPais INTEGER)
  BEGIN
  SELECT * FROM Arbitro AS a WHERE a.id_pais = idPais;
  END //
DELIMITER ;

-- Lista de todos los arbitros que actuaron como arbitro central en la categoria Combate
DELIMITER //
CREATE PROCEDURE arbitrosCentralesEnModalidad(IN tipo VARCHAR(20))
  BEGIN
  SELECT a.nombre, a.apellido FROM Arbitro AS a
  INNER JOIN Central ar ON a.id_arbitro = ar.id_arbitro
  INNER JOIN Dirige AS d ON a.id_arbitro = d.id_arbitro
  INNER JOIN Competencia AS c ON d.id_competencia = c.id_competencia
  INNER JOIN Modalidad AS m ON c.id_modalidad = m.id_modalidad
  WHERE m.nombre = tipo;
  END //
DELIMITER ;

-- Lista de equipos por pais
DELIMITER //
CREATE PROCEDURE equiposPorPais(IN idPais INTEGER)
  BEGIN
  SELECT DISTINCT e.nombre FROM Equipo AS e
  INNER JOIN Competidor c ON c.id_equipo_titular = e.id_equipo
  WHERE c.id_pais = idPais;
  END //
DELIMITER ;


-- Lista de equipos por pais
DELIMITER //
CREATE PROCEDURE medallasPorCompetidor(IN idCompetidor INTEGER)
BEGIN
select distinct idCompetidor, Competencia.id_competencia,
      CASE 
         WHEN idCompetidor = Competencia.primer_puesto THEN 'Primero'
         WHEN idCompetidor = Competencia.segundo_puesto THEN 'Segundo'
         WHEN idCompetidor = Competencia.tercer_puesto THEN 'Tercero'
      END as Puesto,
      Categoria.genero, Categoria.rango_edad, Categoria.rango_peso
	from Competidor, Competencia , Inscripcion, Categoria where 
Competidor.id_competidor = Inscripcion.id_competidor and 
Inscripcion.id_competencia = Competencia.id_competencia and 
Categoria.id_categoria = Competencia.id_categoria and 
(Competencia.primer_puesto = idCompetidor or Competencia.segundo_puesto = idCompetidor or Competencia.tercer_puesto = idCompetidor);
  END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE medallasPorEscuela(IN idEscuela INTEGER)
BEGIN
select Competidor.id_competidor, Competencia.id_competencia,
      CASE 
         WHEN Competidor.id_competidor = Competencia.primer_puesto THEN 'Primero'
         WHEN Competidor.id_competidor = Competencia.segundo_puesto THEN 'Segundo'
         WHEN Competidor.id_competidor = Competencia.tercer_puesto THEN 'Tercero'
      END as Puesto,
      Categoria.genero, Categoria.rango_edad, Categoria.rango_peso
  from Competidor, Competencia , Inscripcion, Categoria WHERE
Competidor.id_escuela = idEscuela AND
 Competidor.id_competidor = Inscripcion.id_competidor AND 
 Inscripcion.id_competencia = Competencia.id_competencia AND 
 Categoria.id_categoria = Competencia.id_categoria AND 
(Competencia.primer_puesto = Competidor.id_competidor OR Competencia.segundo_puesto = Competidor.id_competidor or Competencia.tercer_puesto = Competidor.id_competidor);
  END //
DELIMITER ;


