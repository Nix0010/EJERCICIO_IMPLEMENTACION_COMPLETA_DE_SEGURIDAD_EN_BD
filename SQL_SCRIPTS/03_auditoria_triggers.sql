
   03 - INFRAESTRUCTURA DE AUDITORÍA


-- 1. TABLA FORENSE DE AUDITORÍA
CREATE TABLE IF NOT EXISTS audit_log (
    id_audit SERIAL PRIMARY KEY,
    tabla_objeto VARCHAR(100) NOT NULL,
    operacion VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
    usuario_ejecutor TEXT NOT NULL,
    fecha_evento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    datos_json JSONB
);

-- 2. FUNCIÓN PL/pgSQL PARA REGISTRO
CREATE OR REPLACE FUNCTION registrar_auditoria() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log(tabla_objeto, operacion, usuario_ejecutor, datos_json)
        VALUES (TG_TABLE_NAME, TG_OP, CURRENT_USER, row_to_json(NEW)::jsonb);
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        -- Registra el estado antiguo y el nuevo en un solo JSONB
        INSERT INTO audit_log(tabla_objeto, operacion, usuario_ejecutor, datos_json)
        VALUES (TG_TABLE_NAME, TG_OP, CURRENT_USER, jsonb_build_object('old', row_to_json(OLD), 'new', row_to_json(NEW)));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        -- Registra el estado que fue eliminado
        INSERT INTO audit_log(tabla_objeto, operacion, usuario_ejecutor, datos_json)
        VALUES (TG_TABLE_NAME, TG_OP, CURRENT_USER, row_to_json(OLD)::jsonb);
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. TRIGGER AFTER
CREATE TRIGGER trg_empleados_audit AFTER INSERT OR UPDATE OR DELETE ON empleados
FOR EACH ROW EXECUTE FUNCTION registrar_auditoria();
