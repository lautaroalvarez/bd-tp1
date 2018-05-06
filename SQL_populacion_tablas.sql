-- Populación de tablas BEGIN

USE tp1;

-- limpiamos todas las tablas en este preciso órden para poder popularlas de nuevo
-- DELETE FROM Locacion;

SELECT 'POPULATING DB' as 'INFO';

-- id_locacion, nombre, precio, ubicacion, tipo
INSERT INTO Locacion values (1, 'Parque de la Costa', 100, 'Tigre', 'P');
INSERT INTO Locacion values (2, 'Italpark', 300, 'CABA', 'P');
INSERT INTO Locacion values (3, 'Loolapalusa', 1000, 'San Isidro', 'T');
INSERT INTO Locacion values (4, 'Copa Libertadores', 400, 'CABA', 'T');

-- cuit_empresa, razon_social, direccion, provincia, pais
insert into Empresa values (20314457769, '33 Orientales entretenimiento', 'Cosme Beccar 445, San Fernando, C1650BHH', 'Buenos Aires', 'Argentina');
insert into Empresa values (20344561703, 'Full Fun', 'Azcuénaga 444, C1023BHF', 'CABA', 'Argentina');
insert into Empresa values (33417743159, 'Productora Los Gallegos ', 'Monteagudo 70 , Ramos Mejía, B5431JJD', 'Buenos Aires', 'Argentina');

-- id_locacion, cuit_empresa, nombre
insert into Evento values (3, 20314457769, '2017-04-04','2017-04-06');
insert into Evento values (4, 20344561703, '2017-04-05','2017-10-20');

-- id_atraccion, id_locaion, nombre, precio, minimo_edad, minimo_altura
INSERT INTO Atraccion values (1, 1,  'Tazas Locas', 50, 10, 140);
INSERT INTO Atraccion values (2, 1,  'Samba', 20, 8, 110);
INSERT INTO Atraccion values (3, 2,  'Autitos Chocadores', 60, 6, 100);
INSERT INTO Atraccion values (4, 2,  'Twister', 40, 7, 90);

-- id_categoria, nombre, valorx, valory
INSERT INTO Categoria values (1, "Basica", 0, 0);
INSERT INTO Categoria values (2, "Gold", 400, 35);
INSERT INTO Categoria values (3, "Platinum", 1500, 150);
INSERT INTO Categoria values (4, "Black", 2800, 250);

-- id_categoria, id_locacion, porcentaje
INSERT INTO Descuento_En_Locacion values (2, 1, 25);
INSERT INTO Descuento_En_Locacion values (2, 2, 50);
INSERT INTO Descuento_En_Locacion values (3, 4, 15);
INSERT INTO Descuento_En_Locacion values (3, 3, 30);
INSERT INTO Descuento_En_Locacion values (3, 2, 70);

-- id_categoria, id_atraccion, porcentaje
INSERT INTO Descuento_En_Atraccion values (2, 1, 10);
INSERT INTO Descuento_En_Atraccion values (2, 2, 10);
INSERT INTO Descuento_En_Atraccion values (2, 3, 10);
INSERT INTO Descuento_En_Atraccion values (2, 4, 10);
INSERT INTO Descuento_En_Atraccion values (3, 1, 30);
INSERT INTO Descuento_En_Atraccion values (3, 2, 30);
INSERT INTO Descuento_En_Atraccion values (3, 3, 30);
INSERT INTO Descuento_En_Atraccion values (3, 4, 30);

-- id_modo_de_pago, nombre
INSERT INTO Modo_De_Pago values (1, 'Efectivo');
INSERT INTO Modo_De_Pago values (2, 'Debito Automatico');
INSERT INTO Modo_De_Pago values (3, 'Pagomiscuentas');

-- dni, nombre, apelido, direccion, telefono, id_modo_de_pago
INSERT INTO Cliente values (13241345, 'Juan', 'García', 'Calle Falsa 123, CABA', '4444-4444', 1, '2017-01-15 20:30:00');
INSERT INTO Cliente values (24356543, 'Roberto', 'Pérez', 'Cangallo 4000, CABA', '5555-5555', 3, '2017-01-17 15:45:00');
INSERT INTO Cliente values (32333444, 'Agustín', 'Sánchez', 'Libertador 1431, CABA', '4545-4545', 1, '2017-01-17 19:20:00');
INSERT INTO Cliente values (28123456, 'Fabiana', 'Fernandez', 'Av Siempreviva 742', '011 1234-5678', 2, '2018-03-15 09:20:00');

-- numero_de_tarjeta, dni, id_categoria, foto_path ('//srv/img/$id_tarjeta.png'),
INSERT INTO Tarjeta values (1, 13241345, 1, '//srv/img/1.png', 'Inactiva', '2017-01-15 20:30:00');
INSERT INTO Tarjeta values (2, 24356543, 3, '//srv/img/2.png', 'Activa', '2017-01-17 15:45:00');
INSERT INTO Tarjeta values (3, 32333444, 1, '//srv/img/3.png', 'Activa', '2017-01-17 19:20:00');
INSERT INTO Tarjeta values (4, 13241345, 2, '//srv/img/4.png', 'Inactiva', '2017-01-20 08:45:00');
INSERT INTO Tarjeta values (5, 13241345, 2, '//srv/img/5.png', 'Inactiva', '2017-03-15 15:30:00');
INSERT INTO Tarjeta values (6, 13241345, 2, '//srv/img/6.png', 'Activa', '2017-05-01 22:05:00');
INSERT INTO Tarjeta values (7, 28123456, 1, '//srv/img/7.png', 'Activa', '2018-03-15 09:20:00');

-- numero_de_tarjeta, id_categoria, fecha_desde
INSERT INTO Tarjeta_Tuvo_Categoria values (1, 1, '2017-01-15 22:30:00');
INSERT INTO Tarjeta_Tuvo_Categoria values (2, 1, '2017-01-17 15:45:00');
INSERT INTO Tarjeta_Tuvo_Categoria values (3, 3, '2017-01-17 19:20:00');
INSERT INTO Tarjeta_Tuvo_Categoria values (4, 1, '2017-01-20 08:45:00');
INSERT INTO Tarjeta_Tuvo_Categoria values (4, 2, '2017-03-01 09:00:00');
INSERT INTO Tarjeta_Tuvo_Categoria values (5, 2, '2017-03-15 15:30:00');
INSERT INTO Tarjeta_Tuvo_Categoria values (2, 3, '2017-05-01 09:00:00');
INSERT INTO Tarjeta_Tuvo_Categoria values (6, 2, '2017-05-01 22:05:00');
INSERT INTO Tarjeta_Tuvo_Categoria values (7, 1, '2018-03-15 09:20:00');

-- numero_de_factura, dni, fecha, monto, estado, fecha_de_vencimiento
INSERT INTO Factura values (1, 13241345, '2017-02-01', 210, 'P', '2017-02-17');
INSERT INTO Factura values (2, 13241345, '2017-03-01', 200, 'P', '2017-03-17');
INSERT INTO Factura values (3, 24356543, '2017-05-01', 2000, 'P', '2017-05-17');
INSERT INTO Factura values (4, 32333444, '2018-05-01', 400, 'I', '2018-05-17');
INSERT INTO Factura values (5, 28123456, '2018-05-01', 400, 'I', '2018-05-17');

-- id_entrada, dni, numero_de_tarjeta, fecha, precio, numero_de_factura
INSERT INTO Entrada values (1, 13241345, 1, '2017-01-16 10:50:00', 100, 1);
INSERT INTO Entrada values (2, 13241345, 1, '2017-01-16 11:30:00', 50, 1);
INSERT INTO Entrada values (3, 13241345, 1, '2017-01-16 13:00:00', 50, 1);
INSERT INTO Entrada values (4, 13241345, 4, '2017-02-17 09:35:00', 100, 2);
INSERT INTO Entrada values (5, 13241345, 4, '2017-02-17 11:00:00', 20, 2);
INSERT INTO Entrada values (6, 13241345, 4, '2017-02-17 11:45:00', 60, 2);
INSERT INTO Entrada values (7, 13241345, 4, '2017-02-17 15:00:00', 20, 2);
INSERT INTO Entrada values (8, 13241345, 4, '2017-02-17 15:00:00', 20, 2);
INSERT INTO Entrada values (9, 24356543, 2, '2017-04-04 08:00:00', 1000, 3);
INSERT INTO Entrada values (10, 24356543, 2, '2017-04-05 08:00:00', 1000, 3);
INSERT INTO Entrada values (11, 32333444, 3, '2018-04-25 09:00:00', 300, 4);
INSERT INTO Entrada values (12, 32333444, 3, '2018-04-25 10:10:00', 60, 4);
INSERT INTO Entrada values (13, 32333444, 3, '2018-04-25 10:50:00', 40, 4);
INSERT INTO Entrada values (14, 28123456, 7, '2018-04-28 21:15:00', 400, 5);

-- id_entrada, id_locacion
INSERT INTO Entrada_A_Locacion values (1, 1);
INSERT INTO Entrada_A_Locacion values (4, 1);
INSERT INTO Entrada_A_Locacion values (9, 3);
INSERT INTO Entrada_A_Locacion values (10, 3);
INSERT INTO Entrada_A_Locacion values (11, 2);
INSERT INTO Entrada_A_Locacion values (14, 4);

-- id_entrada, id_atraccion
INSERT INTO Entrada_A_Atraccion values (2, 1);
INSERT INTO Entrada_A_Atraccion values (3, 1);
INSERT INTO Entrada_A_Atraccion values (5, 2);
INSERT INTO Entrada_A_Atraccion values (6, 1);
INSERT INTO Entrada_A_Atraccion values (7, 2);
INSERT INTO Entrada_A_Atraccion values (8, 2);
INSERT INTO Entrada_A_Atraccion values (12, 3);
INSERT INTO Entrada_A_Atraccion values (13, 4);

-- Populación de tablas END
