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
  orden INTEGER NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  valor_x INTEGER NOT NULL,
  valor_y INTEGER NOT NULL,
  PRIMARY KEY (id_categoria),
  UNIQUE (nombre, orden)
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
  id_categoria INTEGER NOT NULL,
  FOREIGN KEY (id_modo_de_pago) REFERENCES Modo_De_Pago (id_modo_de_pago),
  FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria),
  PRIMARY KEY (dni)
);

CREATE TABLE Cliente_Tuvo_Categoria (
  dni INTEGER NOT NULL,
  id_categoria INTEGER NOT NULL,
  fecha_desde DATETIME NOT NULL,
  FOREIGN KEY (dni) REFERENCES Cliente (dni),
  FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria),
  PRIMARY KEY (dni, id_categoria, fecha_desde)
);

CREATE TABLE Tarjeta (
  numero_de_tarjeta INTEGER NOT NULL,
  dni INTEGER NOT NULL,
  foto_path VARCHAR(255) NOT NULL,
  estado VARCHAR(255) NOT NULL,
  fecha_alta DATETIME NOT NULL,
  FOREIGN KEY (dni) REFERENCES Cliente (dni),
  PRIMARY KEY (numero_de_tarjeta)
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
-- Atraccion que mas facturo
DELIMITER //
CREATE PROCEDURE atraccionMasFacturo()
  BEGIN
  select atr1.nombre from Atraccion atr1 where not exists(
    select 1 from Atraccion atr2, Entrada_A_Atraccion entrada1,Entrada ent  where
      atr2.id_atraccion=entrada1.id_atraccion and entrada1.id_entrada = ent.id_entrada group by atr2.id_atraccion having
        sum(ent.precio) > (select sum(ent2.precio) from Entrada_A_Atraccion  entrada2, Entrada ent2 where
          atr1.id_atraccion=entrada2.id_atraccion and entrada2.id_entrada = ent2.id_entrada));
  END //
DELIMITER ;

-- Parque que mas facturo 
DELIMITER //
CREATE PROCEDURE parqueMasFacturo()
  BEGIN
  select par1.nombre from Locacion par1 where par1.tipo ='P' and not exists(
    select 1 from Locacion par2, Entrada_A_Locacion entrada1, Entrada ent where
      par2.id_locacion=entrada1.id_locacion and entrada1.id_entrada = ent.id_entrada and par2.tipo ='P' group by par2.id_locacion having
        sum(ent.precio) > (select sum(ent2.precio) from Entrada_A_Locacion entrada2 , Entrada ent2 where
          par1.id_locacion=entrada2.id_locacion and entrada2.id_entrada = ent2.id_entrada)) ;
  END //
DELIMITER ;


-- Atraccion que mas facturo por parque 
DELIMITER //
CREATE PROCEDURE atraccionMasFacturoPorParque()
  BEGIN
    select par1.nombre,atr1.nombre from Locacion par1 ,Atraccion atr1 where par1.tipo='P' and par1.id_locacion=atr1.id_locacion and
      not exists(select 1 from Atraccion atr2, Entrada_A_Atraccion entrada1,Entrada ent where
        atr1.id_locacion=atr2.id_locacion and  atr2.id_atraccion=entrada1.id_atraccion and entrada1.id_entrada = ent.id_entrada group by atr2.id_atraccion having
          sum(ent.precio) > (select sum(ent2.precio) from Entrada_A_Atraccion entrada2,Entrada ent2 where
            atr1.id_atraccion=entrada2.id_atraccion and entrada2.id_entrada = ent2.id_entrada ));
  END //
DELIMITER ;
-- Facturas adeudadas

DELIMITER //
CREATE PROCEDURE facturasAdeudadas()
  BEGIN
  SELECT * FROM Factura where  estado='I';
  END //
DELIMITER ;

-- Atracciones mas visitadas por cliente en rango de fecha 

DELIMITER //
CREATE PROCEDURE atraccionesPorCliente(IN fechaInicio DATE, IN fechaFin DATE)
  BEGIN
    select cl.nombre, atr.nombre from Cliente cl, Atraccion atr where
      exists( select 1 from Entrada_A_Atraccion entradaA , Entrada entrada where entradaA.id_atraccion = atr.id_atraccion and entrada.id_entrada=entradaA.id_entrada and entrada.dni=cl.dni and entrada.fecha<=fechaFin and fechaInicio<=entrada.fecha ) 
        and not exists ( select 1 from Atraccion atr2, Entrada_A_Atraccion entrada1,Entrada ent where
        atr.id_locacion=atr2.id_locacion and  atr2.id_atraccion=entrada1.id_atraccion and entrada1.id_entrada = ent.id_entrada  and ent.fecha<=fechaFin and fechaInicio<=ent.fecha  group by atr2.id_atraccion having
          sum(ent.precio) > (select sum(ent2.precio) from Entrada_A_Atraccion entrada2 ,Entrada ent2 where
            atr.id_atraccion=entrada2.id_atraccion and entrada2.id_entrada = ent2.id_entrada  and ent2.fecha<=fechaFin and fechaInicio<=ent2.fecha ));
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

-- Subida de categoría
--    Sube al cliente de categoria
DELIMITER //
CREATE PROCEDURE subirCategoriaACliente(IN dniCliente INTEGER)
  BEGIN
    DECLARE idSiguienteCategoria INTEGER;
    DECLARE ordenCategoriaActual INTEGER;
    SELECT dniCliente 'El cliente sube de categoria';

    SELECT ca.orden INTO ordenCategoriaActual
      FROM Cliente_Tuvo_Categoria as ctc, Categoria as ca
      WHERE ctc.dni = dniCliente AND ca.id_categoria = ctc.id_categoria
      ORDER BY ctc.fecha_desde DESC
      LIMIT 0, 1;

    SELECT id_categoria INTO idSiguienteCategoria
      FROM Categoria
      WHERE orden > ordenCategoriaActual
      ORDER BY orden ASC
      LIMIT 0, 1;

    IF idSiguienteCategoria THEN
      UPDATE Cliente
        SET id_categoria = idSiguienteCategoria
        WHERE dni = dniCliente;
      INSERT INTO Cliente_Tuvo_Categoria
        SET dni = dniCliente, id_categoria = idSiguienteCategoria, fecha_desde = NOW();
    END IF;
  END //
DELIMITER ;
--    Analiza si un cliente debe subir de categoría
DELIMITER //
CREATE PROCEDURE verSiSubirCategoriaCliente(IN dniCliente INTEGER)
  BEGIN
    DECLARE debeSubir BOOLEAN;

    SELECT ga.gastado_este_ano >= ca.valor_x INTO debeSubir
      FROM
      (
        SELECT ctc.dni, ca.valor_x
          FROM Cliente_Tuvo_Categoria as ctc, Categoria as ca
          WHERE ctc.id_categoria = ca.id_categoria AND ctc.dni = dniCliente
          ORDER BY ctc.fecha_desde DESC
          LIMIT 0, 1
      ) as ca,
      (
        SELECT dni, SUM(precio) gastado_este_ano
          FROM Entrada
          WHERE dni = dniCliente AND YEAR(fecha) = YEAR(NOW())
      ) as ga;

      IF debeSubir THEN
        call subirCategoriaACliente(dniCliente);
      END IF;
  END //
DELIMITER ;
--    Analiza si los clientes deben subir de categoria
DELIMITER //
CREATE PROCEDURE verSiSubirCategoriaClientes()
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE clienteActual INTEGER;
    DECLARE dniClientes CURSOR FOR
      SELECT dni FROM Cliente;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN dniClientes;
    recorrerClientes: LOOP
      FETCH dniClientes INTO clienteActual;
      IF done THEN
        LEAVE recorrerClientes;
      END IF;
      call verSiSubirCategoriaCliente(clienteActual);
    END LOOP;
    CLOSE dniClientes;
  END //
DELIMITER ;

-- Bajada de categoría
--    Baja al cliente de categoria
DELIMITER //
CREATE PROCEDURE bajarCategoriaACliente(IN dniCliente INTEGER)
  BEGIN
    DECLARE idCategoriaPrevia INTEGER;
    DECLARE ordenCategoriaActual INTEGER;
    SELECT dniCliente 'El cliente baja de categoria';

    SELECT ca.orden INTO ordenCategoriaActual
      FROM Cliente_Tuvo_Categoria as ctc, Categoria as ca
      WHERE ctc.dni = dniCliente AND ca.id_categoria = ctc.id_categoria
      ORDER BY ctc.fecha_desde DESC
      LIMIT 0, 1;

    SELECT id_categoria INTO idCategoriaPrevia
      FROM Categoria
      WHERE orden < ordenCategoriaActual
      ORDER BY orden ASC
      LIMIT 0, 1;

    IF idCategoriaPrevia THEN
      UPDATE Cliente
        SET id_categoria = idCategoriaPrevia
        WHERE dni = dniCliente;
      INSERT INTO Cliente_Tuvo_Categoria
        SET dni = dniCliente, id_categoria = idCategoriaPrevia, fecha_desde = NOW();
    END IF;
  END //
DELIMITER ;
--    Analiza si un cliente debe bajar de categoría
DELIMITER //
CREATE PROCEDURE verSiBajarCategoriaCliente(IN dniCliente INTEGER)
  BEGIN
    DECLARE debeSubir BOOLEAN;

    SELECT (ga.gastado_ultimo_ano / 12) < ca.valor_y INTO debeSubir
      FROM
      (
        SELECT ctc.dni, ca.valor_y
          FROM Cliente_Tuvo_Categoria as ctc, Categoria as ca
          WHERE ctc.id_categoria = ca.id_categoria AND ctc.dni = dniCliente
          ORDER BY ctc.fecha_desde DESC
          LIMIT 0, 1
      ) as ca,
      (
        SELECT dni, SUM(precio) gastado_ultimo_ano
          FROM Entrada
          WHERE dni = dniCliente AND fecha >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
      ) as ga;

      IF debeSubir THEN
        call bajarCategoriaACliente(dniCliente);
      END IF;
  END //
DELIMITER ;
--    Analiza si los clientes deben bajar de categoria
DELIMITER //
CREATE PROCEDURE verSiBajarCategoriaClientes()
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE clienteActual INTEGER;
    DECLARE dniClientes CURSOR FOR
      SELECT dni FROM Cliente;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN dniClientes;
    recorrerClientes: LOOP
      FETCH dniClientes INTO clienteActual;
      IF done THEN
        LEAVE recorrerClientes;
      END IF;
      call verSiBajarCategoriaCliente(clienteActual);
    END LOOP;
    CLOSE dniClientes;
  END //
DELIMITER ;

-- SP que reacomoda categoria de dniClientes
DELIMITER //
CREATE PROCEDURE reacomodarCategoriaClientes()
  BEGIN
    call verSiSubirCategoriaClientes();
    call verSiBajarCategoriaClientes();
  END //
DELIMITER ;
