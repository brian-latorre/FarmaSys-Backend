CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Seguridad

CREATE TABLE rol (
                     id         SERIAL PRIMARY KEY,
                     nombre_rol VARCHAR(50) NOT NULL UNIQUE
);

-- Inventario y catalogo

CREATE TABLE sede (
                      id        SERIAL PRIMARY KEY,
                      nro_local VARCHAR(20) NOT NULL UNIQUE,
                      direccion VARCHAR(255) NOT NULL
);

CREATE TABLE producto (
                          id                 BIGSERIAL PRIMARY KEY,
                          cod_barras         VARCHAR(50) NOT NULL UNIQUE,
                          descripcion        VARCHAR(255) NOT NULL,
                          precio_venta       DECIMAL(10,2) NOT NULL CHECK (precio_venta >= 0),
                          precio_costo       DECIMAL(10,2) NOT NULL CHECK (precio_costo >= 0),
                          laboratorio        VARCHAR(120) NOT NULL,
                          registro_sanitario VARCHAR(60),
                          condicion_venta    VARCHAR(30) NOT NULL -- LIBRE, RECETA_SIMPLE, RECETA_RETENIDA
);

CREATE TABLE lote (
                      id                BIGSERIAL PRIMARY KEY,
                      nro_lote          VARCHAR(60) NOT NULL,
                      fecha_vencimiento DATE NOT NULL,
                      stock_fisico      INTEGER NOT NULL DEFAULT 0 CHECK (stock_fisico >= 0),
                      id_sede           INTEGER NOT NULL REFERENCES sede(id),
                      id_producto       BIGINT NOT NULL REFERENCES producto(id),
                      UNIQUE (nro_lote, id_sede, id_producto)
);

CREATE TABLE usuario (
                         id       SERIAL PRIMARY KEY,
                         username VARCHAR(60) NOT NULL UNIQUE,
                         password VARCHAR(255) NOT NULL, -- hash bcrypt
                         estado   VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
                         id_rol   INTEGER NOT NULL REFERENCES rol(id),
                         id_sede  INTEGER NOT NULL REFERENCES sede(id)
);

-- Ventas

CREATE TABLE cliente (
                         id                   BIGSERIAL PRIMARY KEY,
                         dni_ruc              VARCHAR(15) NOT NULL UNIQUE,
                         nombres_razon_social VARCHAR(200) NOT NULL,
                         telefono             VARCHAR(20),
                         direccion            VARCHAR(255)
);

CREATE TABLE orden_venta (
                             id           BIGSERIAL PRIMARY KEY,
                             nro_orden    VARCHAR(20) NOT NULL UNIQUE,
                             fecha_hora   TIMESTAMP NOT NULL DEFAULT NOW(),
                             canal_origen VARCHAR(30) NOT NULL, -- PRESENCIAL, WEB, APP, TELEFONO
                             estado       VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
                             monto_total  DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (monto_total >= 0),
                             id_cliente   BIGINT NOT NULL REFERENCES cliente(id)
);

CREATE TABLE linea_orden_venta (
                                   id             BIGSERIAL PRIMARY KEY,
                                   cantidad       INTEGER NOT NULL CHECK (cantidad > 0),
                                   subtotal       DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
                                   id_orden_venta BIGINT NOT NULL REFERENCES orden_venta(id),
                                   id_producto    BIGINT NOT NULL REFERENCES producto(id)
);

-- comprobante_pago: herencia de tabla unica, dtype = BOLETA o FACTURA
CREATE TABLE comprobante_pago (
                                  id              BIGSERIAL PRIMARY KEY,
                                  dtype           VARCHAR(10) NOT NULL,
                                  nro_comprobante VARCHAR(30) NOT NULL UNIQUE,
                                  fecha_emision   TIMESTAMP NOT NULL DEFAULT NOW(),
                                  total           DECIMAL(10,2) NOT NULL CHECK (total >= 0),
                                  estado          VARCHAR(20) NOT NULL DEFAULT 'EMITIDO',
                                  dni_cliente     VARCHAR(15),
                                  ruc_cliente     VARCHAR(15),
                                  razon_social    VARCHAR(200),
                                  id_orden_venta  BIGINT NOT NULL REFERENCES orden_venta(id),
                                  CONSTRAINT chk_dtype CHECK (dtype IN ('BOLETA','FACTURA'))
);

-- medio_pago: herencia de tabla unica, dtype = EFECTIVO o TARJETA
CREATE TABLE medio_pago (
                            id              BIGSERIAL PRIMARY KEY,
                            dtype           VARCHAR(10) NOT NULL,
                            monto_pagado    DECIMAL(10,2) NOT NULL CHECK (monto_pagado >= 0),
                            moneda          VARCHAR(10) NOT NULL DEFAULT 'PEN',
                            monto_entregado DECIMAL(10,2),
                            vuelto          DECIMAL(10,2),
                            nro_operacion   VARCHAR(30),
                            marca_tarjeta   VARCHAR(20),
                            id_orden_venta  BIGINT NOT NULL REFERENCES orden_venta(id),
                            CONSTRAINT chk_medio_dtype CHECK (dtype IN ('EFECTIVO','TARJETA'))
);

CREATE TABLE nota_credito (
                              id                  BIGSERIAL PRIMARY KEY,
                              nro_nota            VARCHAR(30) NOT NULL UNIQUE,
                              fecha_emision       TIMESTAMP NOT NULL DEFAULT NOW(),
                              motivo              VARCHAR(255) NOT NULL,
                              monto_revertido     DECIMAL(10,2) NOT NULL CHECK (monto_revertido >= 0),
                              id_comprobante_pago BIGINT NOT NULL REFERENCES comprobante_pago(id)
);

-- Compras

CREATE TABLE proveedor (
                           id                  BIGSERIAL PRIMARY KEY,
                           ruc                 VARCHAR(15) NOT NULL UNIQUE,
                           razon_social        VARCHAR(200) NOT NULL,
                           condicion_comercial VARCHAR(100)
);

CREATE TABLE orden_compra (
                              id            BIGSERIAL PRIMARY KEY,
                              nro_oc        VARCHAR(20) NOT NULL UNIQUE,
                              fecha_emision DATE NOT NULL DEFAULT CURRENT_DATE,
                              estado        VARCHAR(20) NOT NULL DEFAULT 'BORRADOR',
                              id_proveedor  BIGINT NOT NULL REFERENCES proveedor(id)
);

CREATE TABLE linea_orden_compra (
                                    id                  BIGSERIAL PRIMARY KEY,
                                    cantidad_solicitada INTEGER NOT NULL CHECK (cantidad_solicitada > 0),
                                    id_orden_compra     BIGINT NOT NULL REFERENCES orden_compra(id),
                                    id_producto         BIGINT NOT NULL REFERENCES producto(id)
);

CREATE TABLE factura_compra (
                                id                BIGSERIAL PRIMARY KEY,
                                nro_factura       VARCHAR(30) NOT NULL UNIQUE,
                                fecha_recepcion   DATE NOT NULL,
                                fecha_vencimiento DATE NOT NULL,
                                monto_total       DECIMAL(10,2) NOT NULL CHECK (monto_total >= 0),
                                estado_pasivo     VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
                                id_orden_compra   BIGINT NOT NULL REFERENCES orden_compra(id)
);

-- Recetas magistrales

CREATE TABLE paciente (
                          id                BIGSERIAL PRIMARY KEY,
                          dni               VARCHAR(10) NOT NULL UNIQUE,
                          nombres_completos VARCHAR(200) NOT NULL
);

CREATE TABLE medico (
                        id                BIGSERIAL PRIMARY KEY,
                        cmp               VARCHAR(20) NOT NULL UNIQUE,
                        nombres_completos VARCHAR(200) NOT NULL,
                        especialidad      VARCHAR(100) NOT NULL
);

CREATE TABLE receta_magistral (
                                  id                 BIGSERIAL PRIMARY KEY,
                                  nro_receta         VARCHAR(30) NOT NULL UNIQUE,
                                  fecha_evaluacion   DATE NOT NULL DEFAULT CURRENT_DATE,
                                  presupuesto        DECIMAL(10,2) CHECK (presupuesto >= 0),
                                  contraindicaciones TEXT,
                                  estado_formula     VARCHAR(30) NOT NULL DEFAULT 'EN_EVALUACION',
                                  id_medico          BIGINT NOT NULL REFERENCES medico(id),
                                  id_paciente        BIGINT NOT NULL REFERENCES paciente(id)
);

CREATE TABLE insumo_formula (
                                id                  BIGSERIAL PRIMARY KEY,
                                gramos_requeridos   DECIMAL(10,4) NOT NULL CHECK (gramos_requeridos > 0),
                                id_receta_magistral BIGINT NOT NULL REFERENCES receta_magistral(id),
                                id_producto         BIGINT NOT NULL REFERENCES producto(id)
);

-- Indices

CREATE INDEX idx_producto_cod_barras ON producto(cod_barras);
CREATE INDEX idx_lote_fecha_vencimiento ON lote(fecha_vencimiento);
CREATE INDEX idx_ov_estado ON orden_venta(estado);
CREATE INDEX idx_ov_canal ON orden_venta(canal_origen);
CREATE INDEX idx_ov_cliente ON orden_venta(id_cliente);
CREATE INDEX idx_cp_nro_comprobante ON comprobante_pago(nro_comprobante);
CREATE INDEX idx_oc_proveedor ON orden_compra(id_proveedor);
CREATE INDEX idx_rm_paciente ON receta_magistral(id_paciente);
CREATE INDEX idx_rm_medico ON receta_magistral(id_medico);
CREATE INDEX idx_usuario_username ON usuario(username);

-- Datos semilla

INSERT INTO rol (nombre_rol) VALUES
                                 ('Administrador'),
                                 ('Cajero'),
                                 ('Quimico Farmaceutico'),
                                 ('Almacenero'),
                                 ('Auditor');