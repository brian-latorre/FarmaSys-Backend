-- =========================================
-- SEDES
-- =========================================

INSERT INTO sede (nro_local, direccion) VALUES
                                            ('LIM001', 'Av. Javier Prado 123, San Isidro'),
                                            ('LIM002', 'Av. Larco 456, Miraflores');

-- =========================================
-- USUARIOS
-- =========================================

INSERT INTO usuario (username, password, estado, id_rol, id_sede) VALUES
                                                                      ('admin', '$2a$10$hashadmin', 'ACTIVO', 1, 1),
                                                                      ('cajero1', '$2a$10$hashcajero', 'ACTIVO', 2, 1),
                                                                      ('quimico1', '$2a$10$hashquimico', 'ACTIVO', 3, 1),
                                                                      ('almacen1', '$2a$10$hashalmacen', 'ACTIVO', 4, 2);

-- =========================================
-- PRODUCTOS
-- =========================================

INSERT INTO producto
(cod_barras, descripcion, precio_venta, precio_costo,
 laboratorio, registro_sanitario, condicion_venta)
VALUES
    ('775100000001','Paracetamol 500mg',3.50,1.20,'Medifarma','RS001','LIBRE'),
    ('775100000002','Ibuprofeno 400mg',5.50,2.10,'AC Farma','RS002','LIBRE'),
    ('775100000003','Amoxicilina 500mg',18.90,10.50,'Teva','RS003','RECETA_SIMPLE'),
    ('775100000004','Omeprazol 20mg',12.50,7.20,'Medifarma','RS004','LIBRE'),
    ('775100000005','Losartan 50mg',15.50,8.30,'Bayer','RS005','RECETA_SIMPLE'),
    ('775100000006','Metformina 850mg',11.90,5.80,'Abbott','RS006','RECETA_SIMPLE'),
    ('775100000007','Salbutamol Inhalador',29.90,18.00,'GSK','RS007','RECETA_SIMPLE'),
    ('775100000008','Loratadina 10mg',8.50,3.40,'AC Farma','RS008','LIBRE'),
    ('775100000009','Vitamina C 1g',12.00,5.50,'Medifarma','RS009','LIBRE'),
    ('775100000010','Diclofenaco 50mg',7.90,3.00,'Teva','RS010','LIBRE');