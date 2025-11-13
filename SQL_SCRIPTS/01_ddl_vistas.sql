
-- Contiene: Estructura de Tablas (DDL) y Vistas de Seguridad
--  (Secciones 1 y 3 del Ejercicio)

-- 1. PREPARACI´´ÓN DEL AMBIENTE

-- 1.2. Crear nueva base de datos (PostgreSQL: se usa IF NOT EXISTS, pero la conexión a una BD debe ser previa)
-- Ejecutar en psql/DBeaver: CREATE DATABASE empresa_segura; y luego CONECTARSE.
-- Asumiendo que ya estás conectado a la BD empresa_segura:
SET search_path TO public;

-- 1.3. Creación de tablas base
CREATE TABLE IF NOT EXISTS empleados (
    emp_no INT NOT NULL PRIMARY KEY,
    birth_date DATE NOT NULL,
    first_name VARCHAR(14) NOT NULL,
    last_name VARCHAR(16) NOT NULL,
    gender CHAR(1) NOT NULL, -- Usamos CHAR(1) para consistencia
    hire_date DATE NOT NULL,
    salary NUMERIC(10, 2), -- NUMERIC en PostgreSQL
    CHECK (salary >= 0),
    CHECK (gender IN ('M', 'F'))
);

CREATE TABLE IF NOT EXISTS departamentos (
    dept_no CHAR(4) NOT NULL PRIMARY KEY,
    dept_name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS salarios (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (emp_no, from_date),
    FOREIGN KEY (emp_no) REFERENCES empleados (emp_no) ON DELETE CASCADE
);

-- Datos de prueba para verificación
INSERT INTO empleados (emp_no, birth_date, first_name, last_name, gender, hire_date, salary)
VALUES
(10001, '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26', 60000.00)
ON CONFLICT (emp_no) DO NOTHING;
INSERT INTO empleados (emp_no, birth_date, first_name, last_name, gender, hire_date, salary)
VALUES
(10002, '1964-06-02', 'Bezalel', 'Simmel', 'F', '1985-11-21', 75000.00)
ON CONFLICT (emp_no) DO NOTHING;
INSERT INTO empleados (emp_no, birth_date, first_name, last_name, gender, hire_date, salary)
VALUES
(10003, '1959-12-03', 'Parto', 'Bamford', 'M', '1986-08-28', 50000.00)
ON CONFLICT (emp_no) DO NOTHING;


-- 3. CREAR VISTAS DE SEGURIDAD


-- 3.1. Vista 'empleados_publico'
CREATE OR REPLACE VIEW empleados_publico AS
SELECT emp_no, first_name, last_name, hire_date
FROM empleados;

-- 3.2. Vista 'resumen_departamental'
CREATE OR REPLACE VIEW resumen_departamental AS
SELECT gender, COUNT(emp_no) AS total_empleados, ROUND(AVG(salary)::NUMERIC, 2) AS salario_promedio
FROM empleados
GROUP BY gender;

-- 3.3. Vista 'empleados_activos' con CHECK OPTION (CURDATE corregido)
CREATE OR REPLACE VIEW empleados_activos AS
SELECT emp_no, first_name, last_name, hire_date
FROM empleados
WHERE hire_date <= CURRENT_DATE -- Uso de CURRENT_DATE en PostgreSQL
WITH CHECK OPTION;
