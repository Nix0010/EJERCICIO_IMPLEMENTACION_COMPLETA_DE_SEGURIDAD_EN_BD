-- -----------------------------------------------------------
-- Archivo 02: Roles y Usuarios (Control de Acceso)
-- Propósito: Definir roles, asignar contraseñas e implementar el
-- Principio de Mínimo Privilegio mediante la asignación de roles.
-- -----------------------------------------------------------

/* ======================================================
   04 - ROLES Y USUARIOS
   ====================================================== */

-- 1. REVOCAR PERMISOS POR DEFECTO (Buena práctica de seguridad)
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;


-- 2. ROL ADMINISTRATIVO
-- Nota: La expiración de contraseña (VALID UNTIL) se añade como buena práctica.
CREATE ROLE admin_rrhh LOGIN PASSWORD 'Pass1234.' VALID UNTIL '2026-03-01';

-- Asignación de TODOS los privilegios a admin_rrhh sobre los objetos
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_rrhh;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_rrhh;
GRANT ALL PRIVILEGES ON ALL VIEWS IN SCHEMA public TO admin_rrhh;


-- 3. ROL DE LECTURA
CREATE ROLE lector_rrhh NOLOGIN;

-- Asignación de SELECT en todas las tablas y vistas públicas al rol lector
GRANT SELECT ON ALL TABLES IN SCHEMA public TO lector_rrhh;
GRANT SELECT ON ALL VIEWS IN SCHEMA public TO lector_rrhh;


-- 4. USUARIO DE CONSULTA
CREATE USER usuario_consulta PASSWORD 'User123.';

-- El usuario final hereda todos los permisos del rol lector
GRANT lector_rrhh TO usuario_consulta;
