-- Reset de los schemas
DROP DATABASE IF EXISTS tp1;
CREATE DATABASE IF NOT EXISTS tp1;
USE tp1;

SELECT 'CREATING DATABASE STRUCTURE' AS 'INFO';

-- Creacion de tablas BEGIN

CREATE TABLE Locacion (
  id_locacion INTEGER NOT NULL,
  nombre VARCHAR(255),
  precio INTEGER NOT NULL,
  ubicacion VARCHAR(255),
  tipo VARCHAR(1),
  PRIMARY KEY (id_locacion),
  UNIQUE (nombre)
);



CREATE TABLE Empresa (
  cuit_empresa BIGINT NOT NULL,
  razon_social VARCHAR(255) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  provincia VARCHAR(255) NOT NULL,
  pais VARCHAR(255) NOT NULL,
  PRIMARY KEY (cuit_empresa),
  UNIQUE (razon_social)
);

CREATE TABLE Evento (
  id_locacion INTEGER NOT NULL,
  cuit_empresa BIGINT NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  PRIMARY KEY (id_locacion),
  FOREIGN KEY (id_locacion) REFERENCES Locacion (id_locacion),
  FOREIGN KEY (cuit_empresa) REFERENCES Empresa (cuit_empresa)
);



CREATE TABLE Atraccion (
  id_atraccion INTEGER NOT NULL,
  id_locacion INTEGER NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  precio INTEGER NOT NULL,
  minimo_edad INTEGER NOT NULL,
  minimo_altura INTEGER NOT NULL,
  PRIMARY KEY (id_atraccion),
  FOREIGN KEY (id_locacion) REFERENCES Locacion (id_locacion),
  UNIQUE (nombre)
);

CREATE TABLE Categoria (
  id_categoria INTEGER NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  valor_x INTEGER NOT NULL,
  valor_y INTEGER NOT NULL,
  PRIMARY KEY (id_categoria),
  UNIQUE (nombre)
);


CREATE TABLE Descuento_En_Locacion (
  id_categoria INTEGER NOT NULL,
  id_locacion INTEGER NOT NULL,
  porcentaje INTEGER NOT NULL,
  FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria),
  FOREIGN KEY (id_locacion) REFERENCES Locacion (id_locacion),
  PRIMARY KEY (id_categoria, id_locacion)
);


CREATE TABLE Descuento_En_Atraccion (
  id_categoria INTEGER NOT NULL,
  id_atraccion INTEGER NOT NULL,
  porcentaje INTEGER NOT NULL,
  FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria),
  FOREIGN KEY (id_atraccion) REFERENCES Atraccion (id_atraccion),
  PRIMARY KEY (id_categoria, id_atraccion)
);


CREATE TABLE Modo_De_Pago (
  id_modo_de_pago INTEGER NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_modo_de_pago),
  UNIQUE (nombre)
);

CREATE TABLE Cliente (
  dni INTEGER NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  apellido VARCHAR(255) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  telefono INTEGER NOT NULL,
  id_modo_de_pago INTEGER NOT NULL,
  FOREIGN KEY (id_modo_de_pago) REFERENCES Modo_De_Pago (id_modo_de_pago),
  PRIMARY KEY (dni)
);


CREATE TABLE Tarjeta (
  numero_de_tarjeta INTEGER NOT NULL,
  dni INTEGER NOT NULL,
  id_categoria INTEGER NOT NULL,
  foto_path VARCHAR(255) NOT NULL,
  FOREIGN KEY (dni) REFERENCES Cliente (dni),
  FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria),
  PRIMARY KEY (numero_de_tarjeta)
);


CREATE TABLE Cliente_Tuvo_Tarjeta (
  numero_de_tarjeta INTEGER NOT NULL,
  dni INTEGER NOT NULL,
  fecha_desde DATE NOT NULL,
  FOREIGN KEY (numero_de_tarjeta) REFERENCES Tarjeta (numero_de_tarjeta),
  FOREIGN KEY (dni) REFERENCES Cliente (dni),
  PRIMARY KEY (numero_de_tarjeta, dni)
);

CREATE TABLE Tarjeta_Tuvo_Categoria (
  numero_de_tarjeta INTEGER NOT NULL,
  id_categoria INTEGER NOT NULL,
  fecha_desde DATE NOT NULL,
  FOREIGN KEY (numero_de_tarjeta) REFERENCES Tarjeta (numero_de_tarjeta),
  FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria),
  PRIMARY KEY (numero_de_tarjeta, id_categoria, fecha_desde)
);


CREATE TABLE Factura (
  numero_de_factura INTEGER NOT NULL,
  dni INTEGER NOT NULL,
  fecha DATE NOT NULL,
  monto DECIMAL(64,2) NOT NULL,
  estado VARCHAR(1) NOT NULL,-- 'A'  abierta, 'F' facturada
  fecha_de_vencimiento DATE NOT NULL,
  FOREIGN KEY (dni) REFERENCES Cliente (dni),
  PRIMARY KEY (numero_de_factura)
);

CREATE TABLE Entrada (
  id_entrada INTEGER NOT NULL,
  dni INTEGER NOT NULL,
  numero_de_tarjeta INTEGER NOT NULL,
  numero_de_factura INTEGER NOT NULL,
  fecha DATE NOT NULL,
  precio DECIMAL(64,2) NOT NULL,
  FOREIGN KEY (dni) REFERENCES Cliente (dni),
  FOREIGN KEY (numero_de_tarjeta) REFERENCES Tarjeta (numero_de_tarjeta),
  FOREIGN KEY (numero_de_factura) REFERENCES Factura (numero_de_factura),
  PRIMARY KEY (id_entrada)
);


CREATE TABLE Entrada_A_Locacion (
  id_entrada INTEGER NOT NULL,
  id_locacion INTEGER NOT NULL,
  FOREIGN KEY (id_locacion) REFERENCES Locacion (id_locacion),
  PRIMARY KEY (id_entrada)
);


CREATE TABLE Entrada_A_Atraccion (
  id_entrada INTEGER NOT NULL,
  id_atraccion INTEGER NOT NULL,
  FOREIGN KEY (id_atraccion) REFERENCES Atraccion (id_atraccion),
  PRIMARY KEY (id_entrada)
);


/*SELECT 'CREATING STORED PROCEDURES' AS 'INFO';

-- Listado de inscriptos por cada categoria
DELIMITER //
CREATE PROCEDURE atraccionMasFacturo()
	BEGIN
	select atr1.nombre from Atraccion atr1 where not exists( 
		select 1 from Atraccion atr2, Entrada_A_Atraccion entrada1 , Factura factura1 where 
			atr2.id_atraccion=entrada1.id_atraccion and entrada1.numero_de_factura=factura1.numero_de_factura and factura1.estado='F' group by id_atraccion having
				sum(factura1.monto) > (select sum(factura2.monto) from Entrada_A_Atraccion entrada1 , Factura factura1 where
					
	END //
DELIMITER ;
/*
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


*/