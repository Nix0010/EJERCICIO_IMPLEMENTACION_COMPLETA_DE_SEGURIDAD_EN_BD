
   00 - CREAR BASE DE DATOS Y CONEXIÓN
   
-CREATE DATABASE seguridad_empresa;
\c seguridad_empresa;

   01 - DEFINICIÓN DE TABLAS
   
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
