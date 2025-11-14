## Introducción y Alcance del Proyecto

Este documento presenta la implementación completa del sistema de **Seguridad, Control de Acceso y Auditoría** desarrollado para la base de datos ***seguridad\_empresa***, utilizando el motor **PostgreSQL**.

El propósito central de este proyecto es demostrar cómo se aplican de manera práctica los mecanismos esenciales de seguridad en bases de datos corporativas, abordando los siguientes pilares fundamentales:

* **Control de Acceso y Mínimo Privilegio**: Creación de roles diferenciados (*admin\_rrhh*, *lector\_rrhh*, *usuario\_consulta*) y asignación precisa de permisos para evitar accesos indebidos.
* **Confidencialidad de la Información Sensible**: Implementación de ***vistas seguras*** que ocultan datos privados como **salarios** y **fechas de nacimiento**, garantizando la protección de ***PII*** (*Personal Identifiable Information*).
* **Integridad, Auditoría y Trazabilidad**: Desarrollo de ***triggers en PL/pgSQL*** que registran cada operación relevante (*INSERT*, *UPDATE*, *DELETE*) en una tabla forense (*audit\_log*) utilizando el formato **JSONB**, permitiendo reconstruir cualquier cambio.
* **Disponibilidad y Resiliencia Operativa**: Configuración y documentación de un esquema de ***backup y restauración***, que incluye respaldos completos y reproducción de WAL, asegurando capacidad de ***Recuperación a un Punto Exacto en el Tiempo (PITR)***.

Este proyecto refleja una arquitectura sólida, segura y alineada con buenas prácticas profesionales en el manejo de datos corporativos.
