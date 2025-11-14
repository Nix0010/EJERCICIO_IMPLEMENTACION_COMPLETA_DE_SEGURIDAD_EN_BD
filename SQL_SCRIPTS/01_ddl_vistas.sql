
-- -----------------------------------------------------------
-- Archivo 00: Creación de la Base de Datos y Tablas (DDL)
-- Propósito: Establecer la estructura base del esquema 'seguridad_empresa'.
-- -----------------------------------------------------------

/* ======================================================
   01 - DEFINICIÓN DE TABLAS
   ====================================================== */
CREATE TABLE IF NOT EXISTS departamentos (
    id_departamento SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    ubicacion VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) UNIQUE,
    telefono VARCHAR(30),
    salario NUMERIC(12,2) NOT NULL,
    id_departamento INT REFERENCES departamentos(id_departamento) ON DELETE SET NULL,
    fecha_contratacion DATE NOT NULL DEFAULT CURRENT_DATE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_nacimiento DATE -- Agregado para simular un PII
);

CREATE TABLE IF NOT EXISTS salarios (
    id_salario SERIAL PRIMARY KEY,
    id_empleado INT NOT NULL REFERENCES empleados(id_empleado) ON DELETE CASCADE,
    salario_anterior NUMERIC(12,2) NOT NULL,
    salario_nuevo NUMERIC(12,2) NOT NULL,
    fecha_cambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);  


-- -----------------------------------------------------------
-- Archivo 01: Vistas de Seguridad (Protección de Datos)
-- Propósito: Implementar vistas para ocultar PII y aplicar controles de integridad.
-- -----------------------------------------------------------

/* ======================================================
   02 - VISTAS DE SEGURIDAD
   ====================================================== */

-- 1. Vista de empleados sin datos sensibles (PII como salario, correo)
CREATE OR REPLACE VIEW vista_empleados_sin_datos_sensibles AS
SELECT 
    id_empleado, 
    nombre, 
    apellido, 
    id_departamento, 
    fecha_contratacion, 
    activo
FROM 
    empleados;

-- 2. Vista de empleados con salarios superiores al promedio (ejemplo de segmentación)
CREATE OR REPLACE VIEW vista_empleados_salario_alto AS
SELECT 
    id_empleado, 
    nombre, 
    apellido, 
    salario
FROM 
    empleados
WHERE 
    salario > (SELECT AVG(salario) FROM empleados);

-- 3. Vista de empleados activos con control de integridad (WITH CHECK OPTION)
CREATE OR REPLACE VIEW vista_empleados_por_fecha AS
SELECT 
    id_empleado, 
    nombre, 
    apellido, 
    fecha_contratacion
FROM 
    empleados
WHERE 
    activo = TRUE
WITH CHECK OPTION;
