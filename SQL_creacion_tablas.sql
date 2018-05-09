-- Reset de los schemas
DROP DATABASE IF EXISTS tp1;
CREATE DATABASE IF NOT EXISTS tp1;
USE tp1;

SELECT 'CREATING DATABASE STRUCTURE' AS 'INFO';

-- Creacion de tablas BEGIN

CREATE TABLE Locacion (
  id_locacion INTEGER NOT NULL,
  nombre VARCHAR(100),
  precio INTEGER NOT NULL,
  ubicacion VARCHAR(255),
  tipo VARCHAR(1), -- 'P'/'E'
  PRIMARY KEY (id_locacion),
  UNIQUE (nombre)
);

CREATE TABLE Empresa (
  cuit_empresa BIGINT NOT NULL,
  razon_social VARCHAR(100) NOT NULL,
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
  nombre VARCHAR(100) NOT NULL,
  precio INTEGER NOT NULL,
  minimo_edad INTEGER NOT NULL,
  minimo_altura INTEGER NOT NULL,
  PRIMARY KEY (id_atraccion),
  FOREIGN KEY (id_locacion) REFERENCES Locacion (id_locacion),
  UNIQUE (nombre)
);

CREATE TABLE Categoria (
  id_categoria INTEGER NOT NULL,
  nombre VARCHAR(100) NOT NULL,
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
  nombre VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_modo_de_pago),
  UNIQUE (nombre)
);

CREATE TABLE Cliente (
  dni INTEGER NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  apellido VARCHAR(255) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  telefono VARCHAR(255) NOT NULL,
  id_modo_de_pago INTEGER NOT NULL,
  fecha_alta DATETIME NOT NULL,
  FOREIGN KEY (id_modo_de_pago) REFERENCES Modo_De_Pago (id_modo_de_pago),
  PRIMARY KEY (dni)
);

CREATE TABLE Tarjeta (
  numero_de_tarjeta INTEGER NOT NULL,
  dni INTEGER NOT NULL,
  id_categoria INTEGER NOT NULL,
  foto_path VARCHAR(255) NOT NULL,
  estado VARCHAR(255) NOT NULL,
  fecha_alta DATETIME NOT NULL,
  FOREIGN KEY (dni) REFERENCES Cliente (dni),
  FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria),
  PRIMARY KEY (numero_de_tarjeta)
);

CREATE TABLE Tarjeta_Tuvo_Categoria (
  numero_de_tarjeta INTEGER NOT NULL,
  id_categoria INTEGER NOT NULL,
  fecha_desde DATETIME NOT NULL,
  FOREIGN KEY (numero_de_tarjeta) REFERENCES Tarjeta (numero_de_tarjeta),
  FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria),
  PRIMARY KEY (numero_de_tarjeta, id_categoria, fecha_desde)
);

CREATE TABLE Factura (
  numero_de_factura INTEGER NOT NULL,
  dni INTEGER NOT NULL,
  fecha DATE NOT NULL,
  monto DECIMAL(64,2) NOT NULL,
  estado VARCHAR(1) NOT NULL,-- 'P' Paga, 'I' Inpaga
  fecha_de_vencimiento DATE NOT NULL,
  FOREIGN KEY (dni) REFERENCES Cliente (dni),
  PRIMARY KEY (numero_de_factura)
);

CREATE TABLE Entrada (
  id_entrada INTEGER NOT NULL,
  dni INTEGER NOT NULL,
  numero_de_tarjeta INTEGER NOT NULL,
  fecha DATETIME NOT NULL,
  precio DECIMAL(64,2) NOT NULL,
  numero_de_factura INTEGER,
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

SELECT 'CREATING STORED PROCEDURES' AS 'INFO';
-- Atraccion que mas facturo
DELIMITER //
CREATE PROCEDURE atraccionMasFacturo()
	BEGIN
	select atr1.nombre from Atraccion atr1 where not exists( 
		select 1 from Atraccion AS atr2, Entrada_A_Atraccion AS entrada1 , Factura AS factura1 where 
			atr2.id_atraccion=entrada1.id_atraccion and entrada1.numero_de_factura=factura1.numero_de_factura and factura1.estado='P' group by id_atraccion having
				sum(factura1.monto) > (select sum(factura2.monto) from Entrada_A_Atraccion AS entrada2 , Factura AS factura2 where 
					atr1.id_atraccion=entrada1.id_atraccion and entrada2.numero_de_factura=factura2.numero_de_factura and factura2.estado='P'));
	END //
DELIMITER ;

-- Parque que mas facturo XX
DELIMITER //
CREATE PROCEDURE parqueMasFacturo()
	BEGIN
	select par1.nombre from Locacion par1 where par1.tipo='P' and not exists( 
		select 1 from Locacion par2, Entrada_A_Locacion entradaL1, Entrada_A_Atraccion entradaA1 , Atraccion atr1,Factura factura1 where 
			((par2.id_locacion=entradaL1.id_locacion and entradaL1.numero_de_factura=factura1.numero_de_factura) or (entradaA1.id_atraccion=atr1.id_atraccion and entradaA1.numero_de_factura=factura1.numero_de_factura and atr1.id_locacion=par2.id_locacion )) and factura1.estado='P' group by id_atraccion having
				sum(factura1.monto) > (select sum(factura2.monto) from Atraccion atr2,Entrada_A_Locacion entradaL2,Entrada_A_Atraccion entradaA2 , Factura factura2 where 
					((par1.id_locacion=entradaL1.id_locacion and entradaL1.numero_de_factura=factura1.numero_de_factura) or (entradaA1.id_atraccion=atr1.id_atraccion and entradaA1.numero_de_factura=factura1.numero_de_factura and atr1.id_locacion=par1.id_locacion )) and factura2.estado='P'));
	END //
DELIMITER ;


-- Atraccion que mas facturo por parque XX
DELIMITER //
CREATE PROCEDURE atraccionMasFacturoPorParque()
	BEGIN
	
	END //
DELIMITER ;
-- Facturas adeudadas

DELIMITER //
CREATE PROCEDURE facturasAdeudadas()
	BEGIN
	SELECT * FROM Facturas where  estado='I';
	END //
DELIMITER ;

-- Atracciones mas visitadas por cliente en rango de fecha XX

DELIMITER //
CREATE PROCEDURE atraccionesPorCliente(IN fechaInicio DATE, IN fechaFin DATE)
	BEGIN
	
	END //
DELIMITER ;
-- Empresa organizadora de eventos que tuvo mayor facturacion
DELIMITER //
CREATE PROCEDURE empresaMasFacturo()
	BEGIN
  SELECT ev.id_locacion, em.cuit_empresa, em.razon_social, SUM(en.precio) facturacion
    FROM Empresa as em, Evento as ev, Entrada_A_Locacion as el, Entrada as en
    WHERE em.cuit_empresa = ev.cuit_empresa AND el.id_locacion = ev.id_locacion AND en.id_entrada = el.id_entrada
    GROUP BY em.cuit_empresa
    LIMIT 0, 1;
	END //
DELIMITER ;

-- Ranking de parques/atracciones con mayor cantidad de visitas en rango de fechas
DELIMITER //
CREATE PROCEDURE rankingParquesAtracciones(IN fecha_desde VARCHAR(10), IN fecha_hasta VARCHAR(10))
	BEGIN
  (
    SELECT 'Parque' as tipo, l.nombre as nombre, COUNT(el.id_entrada) visitas
      FROM Locacion as l, Entrada as en, Entrada_A_Locacion as el
      WHERE l.tipo = 'P' AND el.id_locacion = l.id_locacion AND en.id_entrada = el.id_entrada AND en.fecha > fecha_desde AND en.fecha < fecha_hasta
      GROUP BY l.id_locacion
      LIMIT 0, 5
  )
  UNION
  (
    SELECT 'Atraccion' as tipo, a.nombre as nombre, COUNT(ea.id_entrada) visitas
      FROM Atraccion as a, Entrada as en, Entrada_A_Atraccion as ea
      WHERE ea.id_atraccion = a.id_atraccion AND en.id_entrada = ea.id_entrada AND en.fecha > fecha_desde AND en.fecha < fecha_hasta
      GROUP BY a.id_atraccion
      LIMIT 0, 5
  )
    ORDER BY visitas
    DESC LIMIT 0, 5;
	END //
DELIMITER ;
