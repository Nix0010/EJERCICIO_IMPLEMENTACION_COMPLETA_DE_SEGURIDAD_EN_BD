Reporte de Implementación de Seguridad en Bases de Datos

Motor de Base de Datos: PostgreSQL

Estudiante: Valery Alarcón
Docente: Hely Suárez

1. Introducción y Principios de Seguridad

Este reporte describe la implementación del sistema de Seguridad, Control de Acceso y Auditoría para la base de datos seguridad_empresa, utilizando PostgreSQL.

El diseño se fundamenta en los principios esenciales de seguridad:

Principio de Mínimo Privilegio: Cada usuario solo accede a los datos y funcionalidades estrictamente necesarios.

Confidencialidad, Integridad y Disponibilidad (CID): Asegurar que la información sea confiable, precisa y accesible.

Trazabilidad y Responsabilidad: Todas las operaciones críticas quedan registradas para su posterior revisión.

2. Control de Acceso y Roles Implementados

Para garantizar la seguridad, se establecieron roles y usuarios con permisos claramente delimitados, basados en el principio de mínimo privilegio.

Rol: admin_rrhh

Tipo: Rol administrativo con inicio de sesión.

Función: Gestionar la información del área de RRHH (operaciones completas).

Permisos: SELECT, INSERT, UPDATE, DELETE sobre todas las tablas y vistas.

Seguridad: Contraseña con expiración (VALID UNTIL 90 days).

Rol: lector_rrhh

Tipo: Rol de lectura (generalmente sin inicio de sesión, usado para agrupar permisos).

Función: Consultas sin riesgo de modificar datos sensibles.

Permisos:

SELECT en todas las tablas (empleados, departamentos, historial_salarios).

SELECT en vistas públicas:

vista_empleados_sin_datos_sensibles

vista_empleados_por_fecha

vista_empleados_salario_alto

Usuario: usuario_consulta

Permisos: Exclusivamente hereda el rol lector_rrhh.

Función: Acceder a reportes y realizar consultas seguras.

3. Seguridad a Nivel de Datos mediante Vistas

Para proteger información sensible (Confidencialidad) y garantizar la calidad de los datos (Integridad), se implementaron vistas de seguridad:

Vista

Mecanismo de Seguridad

Finalidad

vista_empleados_sin_datos_sensibles

Oculta campos sensibles como salary y birth_date.

Protección de datos personales (PII).

vista_empleados_salario_alto

Filtra solo empleados con salarios elevados.

Consultas segmentadas sin exponer la base de datos completa.

vista_empleados_por_fecha

Cláusula WITH CHECK OPTION en hire_date.

Garantiza la integridad en inserciones/cambios realizados a través de la vista.

Estas vistas permiten compartir información con los usuarios de consulta sin comprometer la privacidad ni la integridad del sistema.

4. Auditoría Transaccional y Registro de Cambios

Se implementó un sistema de auditoría basado en PL/pgSQL para registrar toda operación crítica realizada sobre la tabla empleados, garantizando la Trazabilidad.

✔ Tabla de Auditoría: audit_log

Esta tabla forense registra:

Tabla afectada.

Tipo de operación (INSERT, UPDATE, DELETE).

Usuario que ejecuta la acción.

Fecha y hora del evento.

Datos OLD y NEW en formato JSONB, permitiendo una reconstrucción forense precisa.

✔ Triggers AFTER

Se crearon triggers de tipo AFTER para las operaciones:

AFTER INSERT

AFTER UPDATE

AFTER DELETE

Estos mecanismos se ejecutan inmediatamente después de la modificación de los datos, asegurando que el registro de auditoría sea completo y permita reconstruir cualquier cambio ejecutado por los usuarios del sistema.

5. Estrategia de Backup y Disponibilidad

Para asegurar la Disponibilidad y la resiliencia operativa, se implementaron procesos de respaldo y restauración:

Backups completos: Generación de respaldos lógicos mediante pg_dump.

Restauraciones: Uso de pg_restore para recuperar los datos.

Recuperación a un punto exacto (PITR): Revisión y documentación de la configuración WAL (Write-Ahead Log), lo cual es esencial para:

Recuperación ante fallos del sistema o errores humanos.

Garantizar continuidad operativa y mínima pérdida de información.
