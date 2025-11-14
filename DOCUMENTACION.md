# Reporte de Implementación de Seguridad en Bases de Datos
PostgreSQL 
Estudiante: Valery Alarcón
Docente: Hely Suárez


🌐 1. Introducción y Principios de Seguridad

Este reporte describe la implementación del sistema de Seguridad, Control de Acceso y Auditoría para la base de datos empresa_segura, utilizando PostgreSQL.
El diseño se fundamenta en los principios esenciales de seguridad:

Principio de Mínimo Privilegio: cada usuario solo accede a lo estrictamente necesario.

Confidencialidad, Integridad y Disponibilidad (CID): asegurar que la información sea confiable, precisa y accesible.

Trazabilidad y responsabilidad: todas las operaciones críticas quedan registradas.

🛡️ 2. Control de Acceso y Roles Implementados

Para garantizar la seguridad, se establecieron roles y usuarios con permisos claramente delimitados.

🔷 Rol: admin_rrhh

Tipo: Rol administrativo con inicio de sesión.

Permisos: SELECT, INSERT, UPDATE, DELETE sobre todas las tablas y vistas.

Función: Gestionar la información del área de RRHH.

Seguridad: Contraseña con expiración (VALID UNTIL 90 days).

🔷 Rol: lector_rrhh

Tipo: Rol de lectura.

Permisos:

SELECT en todas las tablas (empleados, departamentos, historial_salarios).

SELECT en vistas públicas:

vista_empleados_sin_datos_sensibles

vista_empleados_por_fecha

vista_empleados_salario_alto

Función: Consultas sin riesgo de modificar datos sensibles.

🔷 Usuario: usuario_consulta

Permisos: Exclusivamente hereda el rol lector_rrhh.

Función: Acceder a reportes y realizar consultas seguras.

🧿 3. Seguridad a Nivel de Datos mediante Vistas

Para proteger información sensible se implementaron vistas que ocultan campos privados y validan los datos que ingresan a través de ellas.

Vista	Mecanismo de Seguridad	Finalidad
vista_empleados_sin_datos_sensibles	Oculta salary y birth_date	Protección de datos personales (PII).
vista_empleados_salario_alto	Filtra solo salarios elevados	Consultas segmentadas sin exponer datos completos.
vista_empleados_por_fecha	Filtro por hire_date + WITH CHECK OPTION	Garantiza integridad en inserciones y actualizaciones.

Estas vistas permiten compartir información sin comprometer la privacidad ni la integridad del sistema.

📜 4. Auditoría Transaccional y Registro de Cambios

Se implementó un sistema de auditoría para registrar toda operación crítica realizada sobre la tabla empleados.

✔ Tabla de Auditoría: audit_log

Registra:

Tabla afectada

Tipo de operación (INSERT, UPDATE, DELETE)

Usuario que ejecuta la acción

Fecha y hora

Datos OLD y NEW en formato JSONB

✔ Triggers AFTER

Se crearon los siguientes triggers:

AFTER INSERT

AFTER UPDATE

AFTER DELETE

Estos mecanismos garantizan trazabilidad completa y permiten reconstruir cualquier cambio ejecutado por los usuarios del sistema.

💾 5. Estrategia de Backup y Disponibilidad

Para asegurar la disponibilidad del sistema se implementaron procesos de respaldo y restauración:

Backups completos mediante pg_dump.

Restauraciones con pg_restore.

Revisión y documentación de la configuración WAL (Write-Ahead Log).

Con esto se garantiza que la base de datos pueda recuperarse ante:

fallos del sistema,

pérdida de datos,

errores humanos,

corrupción de archivos.

La estrategia permite mantener la continuidad operativa y reducir al mínimo la pérdida de información.

🌟 Conclusión

El sistema diseñado por Valery Alarcón integra prácticas profesionales de seguridad para bases de datos, incluyendo control de accesos, vistas seguras, auditoría detallada y mecanismos de respaldo.
Este proyecto refleja un enfoque sólido y moderno basado en las buenas prácticas de PostgreSQL.
