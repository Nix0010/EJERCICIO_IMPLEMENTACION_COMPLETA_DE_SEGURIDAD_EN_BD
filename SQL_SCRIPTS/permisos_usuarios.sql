
-- Usuario: admin_rrhh (Acceso total a tabla 'empleados', expiración 90 días)
CREATE USER 'admin_rrhh'@'localhost' IDENTIFIED BY 'Pass1234.' PASSWORD EXPIRE INTERVAL 90 DAY;
GRANT SELECT, INSERT, UPDATE, DELETE ON empresa_segura.empleados TO 'admin_rrhh'@'localhost';

-- Usuario: analista_bi (Solo SELECT en todas las tablas, expiración 90 días)
CREATE USER 'analista_bi'@'localhost' IDENTIFIED BY 'Pass1234.' PASSWORD EXPIRE INTERVAL 90 DAY;
GRANT SELECT ON empresa_segura.* TO 'analista_bi'@'localhost';

-- Usuario: desarrollador (SELECT, INSERT, UPDATE en todas las tablas, expiración 90 días)
CREATE USER 'desarrollador'@'localhost' IDENTIFIED BY 'Pass1234.' PASSWORD EXPIRE INTERVAL 90 DAY;
GRANT SELECT, INSERT, UPDATE ON empresa_segura.* TO 'desarrollador'@'localhost';

FLUSH PRIVILEGES;
