-- Populación de tablas BEGIN

USE tp1;

-- limpiamos todas las tablas en este preciso órden para poder popularlas de nuevo
-- DELETE FROM Locacion;

SELECT 'POPULATING DB' as 'INFO';


-- id_locacion, nombre, precio, ubicacion
INSERT INTO Locacion values (1, 'Parque de la Costa', 100, 'Tigre');
INSERT INTO Locacion values (2, 'Italpark', 1, 'CABA');
INSERT INTO Locacion values (3, 'Loolapalusa', 10000, 'San Isidro');
INSERT INTO Locacion values (4, 'Copa Libertadores', 400, 'CABA');


-- cuit_empresa, razon_social, direccion, provincia, pais
insert into Empresa values (20314457769, '33 Orientales entretenimiento', 'Cosme Beccar 445, San Fernando, C1650BHH', 'Buenos Aires', 'Argentina');
insert into Empresa values (20344561703, 'Full Fun', 'Azcuénaga 444, C1023BHF', 'CABA', 'Argentina');
insert into Empresa values (33417743159, 'Productora Los Gallegos ', 'Monteagudo 70 , Ramos Mejía, B5431JJD', 'Buenos Aires', 'Argentina');


-- id_locacion, cuit_empresa, nombre
insert into Evento values (3, 20314457769, '2008-07-04','2008-07-05' );
insert into Evento values (4, 20344561703, '2008-10-04','2008-10-05' );


insert into Parque values (1);
insert into Parque values (2);


-- id_atraccion, id_locaion, nombre, precio, minimo_edad, minimo_altura

INSERT INTO Atraccion values (1, 1,  'Tazas Locas', 50, 10, 140);
INSERT INTO Atraccion values (2, 1,  'Samba', 20, 8, 110);
INSERT INTO Atraccion values (3, 2,  'Autitos Chocadores', 60, 6, 100);
INSERT INTO Atraccion values (4, 2,  'Twister', 40, 7, 90);


-- id_categoria, nombre, valorx, valory


INSERT INTO Categoria values (1, "Gold", 400, 35); 
INSERT INTO Categoria values (2, "Platinum", 1500, 150); 
INSERT INTO Categoria values (3, "Black", 2800, 250); 


-- id_categoria, id_locacion, porcentaje

INSERT INTO Descuento_En_Locacion values (2, 1, 25); 
INSERT INTO Descuento_En_Locacion values (2, 2, 50); 
INSERT INTO Descuento_En_Locacion values (3, 4, 15); 
INSERT INTO Descuento_En_Locacion values (3, 3, 30);
INSERT INTO Descuento_En_Locacion values (3, 2, 70);  



INSERT INTO Descuento_En_Atraccion values (2, 1, 10); 
INSERT INTO Descuento_En_Atraccion values (2, 2, 10); 
INSERT INTO Descuento_En_Atraccion values (2, 3, 10); 
INSERT INTO Descuento_En_Atraccion values (2, 4, 10); 
INSERT INTO Descuento_En_Atraccion values (3, 1, 30); 
INSERT INTO Descuento_En_Atraccion values (3, 2, 30); 
INSERT INTO Descuento_En_Atraccion values (3, 3, 30); 
INSERT INTO Descuento_En_Atraccion values (3, 4, 30); 


INSERT INTO Modo_De_Pago values (1, 'Efectivo');
INSERT INTO Modo_De_Pago values (2, 'Debito Automatico');
INSERT INTO Modo_De_Pago values (3, 'Pagomiscuentas');



-- dni, nombre appelido, direccion, telefono, id_modo_de_pago

INSERT INTO Cliente values (13241345, 'Juan', 'García', 'Calle Falsa 123, CABA', 44444444, 1);
INSERT INTO Cliente values (24356543, 'Roberto', 'Pérez', 'Cangallo 4000, CABA', 55555555, 3);
INSERT INTO Cliente values (32333444, 'Agustín', 'Sánchez', 'Libertador 1431, CABA', 45454545, 1);


-- Tarjeta
-- numero_de_tarjeta, dni, id_categoria, foto_path ('//srv/img/$id_tarjeta.png')

INSERT INTO Tarjeta values (1, 13241345, 1, '//srv/img/1.png');
INSERT INTO Tarjeta values (2, 24356543, 2, '//srv/img/1.png');
INSERT INTO Tarjeta values (3, 32333444, 3, '//srv/img/1.png');
INSERT INTO Tarjeta values (4, 13241345, 1, '//srv/img/1.png');
INSERT INTO Tarjeta values (5, 13241345, 1, '//srv/img/1.png');
INSERT INTO Tarjeta values (6, 13241345, 1, '//srv/img/1.png');


-- Cliente Tuvo Tarjeta
-- numero_de_tarjeta, dni, fecha_desde

-- Tarjeta Tuvo Categoría
-- numero_de_tarjeta, id_categoria, fecha_desde

-- Factura
-- numero_de_factura, dni, fecha, monto, estadom, fecha_de_vencimiento

-- Entrada
-- id_entrad, dni, numero_de_tarjeta, fecha, precio

-- Entrada A Locacion
-- id_entrada, id_locacion

-- Entrada_A_Atraccion
-- id_entrada, id_atraccion



-- Populación de tablas END