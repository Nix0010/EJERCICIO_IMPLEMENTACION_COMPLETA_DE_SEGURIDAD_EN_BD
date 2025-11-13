
-- Contiene: Creación de tabla de auditoría y Triggers
-- (Sección 4 del Ejercicio)

-- Se asume conexión a empresa_segura
SET search_path TO public;

-- 4.1. Crear tabla audit_log
CREATE TABLE IF NOT EXISTS audit_log (
    id SERIAL PRIMARY KEY, -- SERIAL para autoincremento en PostgreSQL
    tabla VARCHAR(50) NOT NULL,
    operacion VARCHAR(10) NOT NULL,
    usuario TEXT NOT NULL, -- TEXT en PostgreSQL
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    datos_json JSONB -- JSONB para manejo eficiente de JSON
);

-- -----------------------------------------
-- 4.2. Implementar Función y Trigger AFTER INSERT
-- -----------------------------------------

CREATE OR REPLACE FUNCTION tr_empleados_ai()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (tabla, operacion, usuario, datos_json)
    VALUES (
        'empleados',
        'INSERT',
        CURRENT_USER, -- Función de usuario en PostgreSQL
        jsonb_build_object('NEW_emp_no', NEW.emp_no, 'NEW_name', NEW.first_name || ' ' || NEW.last_name) -- Función JSON en PostgreSQL
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_empleados_ai
AFTER INSERT ON empleados
FOR EACH ROW
EXECUTE FUNCTION tr_empleados_ai();


-- -----------------------------------------
-- 4.3. Implementar Función y Trigger AFTER UPDATE
-- -----------------------------------------

CREATE OR REPLACE FUNCTION tr_empleados_au()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.first_name IS DISTINCT FROM NEW.first_name OR OLD.last_name IS DISTINCT FROM NEW.last_name OR OLD.salary IS DISTINCT FROM NEW.salary THEN
        INSERT INTO audit_log (tabla, operacion, usuario, datos_json)
        VALUES (
            'empleados',
            'UPDATE',
            CURRENT_USER,
            jsonb_build_object(
                'emp_no', NEW.emp_no,
                'OLD_salary', OLD.salary,
                'NEW_salary', NEW.salary,
                'OLD_name', OLD.first_name || ' ' || OLD.last_name
            )
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_empleados_au
AFTER UPDATE ON empleados
FOR EACH ROW
EXECUTE FUNCTION tr_empleados_au();


-- -----------------------------------------
-- 4.4. Implementar Función y Trigger AFTER DELETE
-- -----------------------------------------

CREATE OR REPLACE FUNCTION tr_empleados_ad()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (tabla, operacion, usuario, datos_json)
    VALUES (
        'empleados',
        'DELETE',
        CURRENT_USER,
        jsonb_build_object('OLD_emp_no', OLD.emp_no, 'OLD_name', OLD.first_name || ' ' || OLD.last_name, 'OLD_salary', OLD.salary)
    );
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_empleados_ad
AFTER DELETE ON empleados
FOR EACH ROW
EXECUTE FUNCTION tr_empleados_ad();


-- -----------------------------------------
-- PRUEBAS DE AUDITORÍA (Sección 4.2)
-- -----------------------------------------

-- 1. PRUEBA DE INSERT
INSERT INTO empleados (emp_no, birth_date, first_name, last_name, gender, hire_date, salary)
VALUES (999999, '1990-01-01', 'Audit', 'Insert', 'M', CURRENT_DATE, 45000.00)
ON CONFLICT (emp_no) DO NOTHING;

-- 2. PRUEBA DE UPDATE
UPDATE empleados SET salary = 50000.00, last_name = 'UpdateTest' WHERE emp_no = 999999;

-- 3. PRUEBA DE DELETE
DELETE FROM empleados WHERE emp_no = 999999;

-- 4. VERIFICACIÓN Y CAPTURA DE PANTALLA
SELECT 
    id, 
    operacion, 
    usuario, 
    timestamp, 
    datos_json ->> 'NEW_salary' AS nuevo_salario -- Acceso a JSONB en PostgreSQL
FROM audit_log 
ORDER BY timestamp DESC 
LIMIT 3;
