------------------------------------------------------------
-- 01 - CREACIÓN DE TABLAS Y VISTAS (DDL)
------------------------------------------------------------

-- Tabla empleados
CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    salario NUMERIC(12,2) NOT NULL,
    fecha_contratacion DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Tabla departamentos
CREATE TABLE departamentos (
    id_departamento SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    ubicacion VARCHAR(100)
);

-- Tabla historial de salarios
CREATE TABLE historial_salarios (
    id_historial SERIAL PRIMARY KEY,
    id_empleado INT NOT NULL REFERENCES empleados(id_empleado),
    salario_anterior NUMERIC(12,2) NOT NULL,
    salario_nuevo NUMERIC(12,2) NOT NULL,
    fecha_cambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


------------------------------------------------------------
-- VISTAS
------------------------------------------------------------

-- Vista de empleados que ganan más que el promedio
CREATE OR REPLACE VIEW vista_empleados_salario_alto AS
SELECT 
    id_empleado, nombre, apellido, cargo, salario
FROM 
    empleados
WHERE 
    salario > (SELECT AVG(salario) FROM empleados);

-- Vista ordenada por fecha de contratación
CREATE OR REPLACE VIEW vista_empleados_por_fecha AS
SELECT 
    id_empleado, nombre, apellido, cargo, fecha_contratacion
FROM 
    empleados
ORDER BY fecha_contratacion ASC;
