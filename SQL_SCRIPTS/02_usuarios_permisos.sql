------------------------------------------------------------
-- 02 - USUARIOS, ROLES Y PERMISOS
------------------------------------------------------------

-- Rol de consulta
CREATE ROLE lector_rrhh;

GRANT SELECT ON empleados TO lector_rrhh;
GRANT SELECT ON departamentos TO lector_rrhh;
GRANT SELECT ON salarios TO lector_rrhh;
GRANT SELECT ON vista_empleados_salario_alto TO lector_rrhh;
GRANT SELECT ON vista_empleados_por_fecha TO lector_rrhh;

-- Rol administrador con expiración en 90 días
CREATE ROLE admin_rrhh LOGIN PASSWORD 'Pass1234.'
    VALID UNTIL (CURRENT_TIMESTAMP + INTERVAL '90 days');

GRANT ALL PRIVILEGES ON empleados TO admin_rrhh;
GRANT ALL PRIVILEGES ON departamentos TO admin_rrhh;
GRANT ALL PRIVILEGES ON salarios TO admin_rrhh;
GRANT ALL PRIVILEGES ON vista_empleados_salario_alto TO admin_rrhh;
GRANT ALL PRIVILEGES ON vista_empleados_por_fecha TO admin_rrhh;

-- Usuario lector
CREATE USER usuario_consulta PASSWORD 'User123.';
GRANT lector_rrhh TO usuario_consulta;
