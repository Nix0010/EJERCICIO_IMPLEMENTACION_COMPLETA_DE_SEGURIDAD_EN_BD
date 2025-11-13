
-- Contiene: Estructura de Tablas (DDL) y Vistas de Seguridad
--  (Secciones 1 y 3 del Ejercicio)

-- 1. PREPARACIÓN DEL AMBIENTE (DDL)

CREATE DATABASE IF NOT EXISTS empresa_segura;
USE empresa_segura;

-- 1.3. Creación de tablas base (Corregida para compatibilidad de ENUM)
CREATE TABLE empleados (
    emp_no INT NOT NULL PRIMARY KEY,
    birth_date DATE NOT NULL,
    first_name VARCHAR(14) NOT NULL,
    last_name VARCHAR(16) NOT NULL,
    gender VARCHAR(1) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    CHECK (salary >= 0),
    CHECK (gender IN ('M', 'F'))
);

CREATE TABLE departamentos (
    dept_no CHAR(4) NOT NULL PRIMARY KEY,
    dept_name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE salarios (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (emp_no, from_date),
    FOREIGN KEY (emp_no) REFERENCES empleados (emp_no) ON DELETE CASCADE
);

-- Poblar la tabla 'empleados' con datos de prueba
INSERT INTO empleados VALUES
(10001, '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26', 60000.00),
(10002, '1964-06-02', 'Bezalel', 'Simmel', 'F', '1985-11-21', 75000.00),
(10003, '1959-12-03', 'Parto', 'Bamford', 'M', '1986-08-28', 50000.00);



-- 3. CREAR VISTAS DE SEGURIDAD


-- 3.1. Vista 'empleados_publico' (Oculta salarios y datos personales sensibles)
CREATE OR REPLACE VIEW empleados_publico AS
SELECT emp_no, first_name, last_name, hire_date
FROM empleados;

-- 3.2. Vista 'resumen_departamental' (Estadísticas agregadas)
CREATE OR REPLACE VIEW resumen_departamental AS
SELECT gender, COUNT(emp_no) AS total_empleados, CAST(AVG(salary) AS DECIMAL(10, 2)) AS salario_promedio
FROM empleados
GROUP BY gender;

-- 3.3. Vista 'empleados_activos' con CHECK OPTION
CREATE OR REPLACE VIEW empleados_activos AS
SELECT emp_no, first_name, last_name, hire_date
FROM empleados
WHERE hire_date <= CURDATE()
WITH CHECK OPTION;
