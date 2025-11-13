
-- Contiene: Gestión de Usuarios, GRANTS, y Política de Expiración
-- (Sección 2 del Ejercicio - Entregable 2.5)

-- 2. IMPLEMENTAR GESTIÓN DE USUARIOS

-- PostgreSQL no tiene la cláusula PASSWORD EXPIRE en CREATE USER. Se crea solo la contraseña.

-- 2.1. Crear usuario 'admin_rrhh' con acceso total a tabla empleados
CREATE USER admin_rrhh WITH PASSWORD 'Pass1234.';
GRANT SELECT, INSERT, UPDATE, DELETE ON empleados TO admin_rrhh;

-- 2.2. Crear usuario 'analista_bi' con solo SELECT en todas las tablas
CREATE USER analista_bi WITH PASSWORD 'Pass1234.';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analista_bi;
-- Se necesita permiso para la tabla de auditoría futura
GRANT SELECT ON audit_log TO analista_bi; 

-- 2.3. Crear usuario 'desarrollador' con permisos de SELECT, INSERT, UPDATE
CREATE USER desarrollador WITH PASSWORD 'Pass1234.';
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO desarrollador;

-- 2.4. La política de contraseñas de expiración debe ser gestionada externamente.
