EJERCICIO: IMPLEMENTACIÓN COMPLETA DE SEGURIDAD EN BD

-- PREPARACIÓN DEL AMBIENTE (DDL)

CREATE DATABASE  empresa_segura;

-- Creación de tablas
CREATE TABLE empleados (
    emp_no INT NOT NULL PRIMARY KEY,
    birth_date DATE NOT NULL,
    first_name VARCHAR(14) NOT NULL,
    last_name VARCHAR(16) NOT NULL,
    gender VARCHAR(1) NOT NULL, -- Corrección para compatibilidad
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



-- CREAR VISTAS DE SEGURIDAD


--  Vista 'empleados_publico'
CREATE OR REPLACE VIEW empleados_publico AS
SELECT emp_no, first_name, last_name, hire_date
FROM empleados;

--  Vista 'resumen_departamental'
CREATE OR REPLACE VIEW resumen_departamental AS
SELECT gender, COUNT(emp_no) AS total_empleados, CAST(AVG(salary) AS DECIMAL(10, 2)) AS salario_promedio
FROM empleados
GROUP BY gender;

--  Vista 'empleados_activos' con CHECK OPTION
CREATE OR REPLACE VIEW empleados_activos AS
SELECT emp_no, first_name, last_name, hire_date
FROM empleados
WHERE hire_date <= CURDATE()
WITH CHECK OPTION;


-- CONFIGURAR AUDITORÍA (TRIGGERS)


--  Crear tabla audit_log
CREATE TABLE IF NOT EXISTS audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tabla VARCHAR(50) NOT NULL,
    operacion VARCHAR(10) NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    datos_json JSON
);

-- Cambiar delimitador para permitir la creación de TRIGGERS
DELIMITER //

-- Implementar trigger AFTER INSERT
CREATE OR REPLACE TRIGGER tr_empleados_ai
AFTER INSERT ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (tabla, operacion, usuario, datos_json)
    VALUES ('empleados', 'INSERT', USER(), JSON_OBJECT('NEW_emp_no', NEW.emp_no, 'NEW_name', CONCAT(NEW.first_name, ' ', NEW.last_name)));
END;
//

-- Implementar trigger AFTER UPDATE
CREATE OR REPLACE TRIGGER tr_empleados_au
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN
    IF OLD.first_name <> NEW.first_name OR OLD.last_name <> NEW.last_name OR OLD.salary <> NEW.salary THEN
        INSERT INTO audit_log (tabla, operacion, usuario, datos_json)
        VALUES (
            'empleados',
            'UPDATE',
            USER(),
            JSON_OBJECT('emp_no', NEW.emp_no, 'OLD_salary', OLD.salary, 'NEW_salary', NEW.salary, 'OLD_name', CONCAT(OLD.first_name, ' ', OLD.last_name))
        );
    END IF;
END;
//

-- Implementar trigger AFTER DELETE
CREATE OR REPLACE TRIGGER tr_empleados_ad
AFTER DELETE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (tabla, operacion, usuario, datos_json)
    VALUES ('empleados', 'DELETE', USER(), JSON_OBJECT('OLD_emp_no', OLD.emp_no, 'OLD_name', CONCAT(OLD.first_name, ' ', OLD.last_name), 'OLD_salary', OLD.salary));
END;
//

-- Restaurar el delimitador por defecto
DELIMITER ;
