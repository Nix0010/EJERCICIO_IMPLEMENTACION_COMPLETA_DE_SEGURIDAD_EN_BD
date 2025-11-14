------------------------------------------------------------
-- 03 - AUDITORÍA Y TRIGGERS
------------------------------------------------------------

-- Tabla de auditoría
CREATE TABLE auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    nombre_tabla VARCHAR(100) NOT NULL,
    operacion VARCHAR(10) NOT NULL,
    usuario_ejecutor VARCHAR(50) NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Función general para registrar cambios
CREATE OR REPLACE FUNCTION insertar_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO auditoria(nombre_tabla, operacion, usuario_ejecutor)
    VALUES (TG_TABLE_NAME, TG_OP, CURRENT_USER);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

------------------------------------------------------------
-- TRIGGERS SOBRE LAS TABLAS
------------------------------------------------------------

CREATE TRIGGER trg_auditoria_empleados
AFTER INSERT OR UPDATE OR DELETE ON empleados
FOR EACH ROW EXECUTE FUNCTION insertar_auditoria();

CREATE TRIGGER trg_auditoria_departamentos
AFTER INSERT OR UPDATE OR DELETE ON departamentos
FOR EACH ROW EXECUTE FUNCTION insertar_auditoria();

CREATE TRIGGER trg_auditoria_salarios
AFTER INSERT OR UPDATE OR DELETE ON historial_salarios
FOR EACH ROW EXECUTE FUNCTION insertar_auditoria();
