
-- Contiene: Gestión de Usuarios, GRANTS, y Política de Expiración
-- (Sección 2 del Ejercicio - Entregable 2.5)

-- 2. IMPLEMENTAR GESTIÓN DE USUARIOS


-- 2.1. Crear usuario 'admin_rrhh' con acceso total a tabla empleados
CREATE USER 'admin_rrhh'@'localhost' IDENTIFIED BY 'Pass1234.' PASSWORD EXPIRE INTERVAL 90 DAY;
GRANT SELECT, INSERT, UPDATE, DELETE ON empresa_segura.empleados TO 'admin_rrhh'@'localhost';

-- 2.2. Crear usuario 'analista_bi' con solo SELECT en todas las tablas
CREATE USER 'analista_bi'@'localhost' IDENTIFIED BY 'Pass1234.' PASSWORD EXPIRE INTERVAL 90 DAY;
GRANT SELECT ON empresa_segura.* TO 'analista_bi'@'localhost';

-- 2.3. Crear usuario 'desarrollador' con permisos de SELECT, INSERT, UPDATE
CREATE USER 'desarrollador'@'localhost' IDENTIFIED BY 'Pass1234.' PASSWORD EXPIRE INTERVAL 90 DAY;
GRANT SELECT, INSERT, UPDATE ON empresa_segura.* TO 'desarrollador'@'localhost';

-- 2.4. La política de expiración se configura en el comando CREATE USER.

-- Aplicar los cambios de privilegios
FLUSH PRIVILEGES;
