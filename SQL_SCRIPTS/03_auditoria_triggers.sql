
-- Contiene: Creación de tabla de auditoría y Triggers
-- (Sección 4 del Ejercicio)

USE empresa_segura;

-- 4.1. Crear tabla audit_log
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

-- 4.2. Implementar trigger AFTER INSERT
CREATE OR REPLACE TRIGGER tr_empleados_ai
AFTER INSERT ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (tabla, operacion, usuario, datos_json)
    VALUES ('empleados', 'INSERT', USER(), JSON_OBJECT('NEW_emp_no', NEW.emp_no, 'NEW_name', CONCAT(NEW.first_name, ' ', NEW.last_name)));
END;
//

-- 4.3. Implementar trigger AFTER UPDATE
CREATE OR REPLACE TRIGGER tr_empleados_au
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN
    -- Audita si hay un cambio en nombre o salario
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

-- 4.4. Implementar trigger AFTER DELETE
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
