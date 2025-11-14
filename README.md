# 💡 *Introducción*

Este documento presenta la implementación completa del sistema de **Seguridad, Control de Acceso y Auditoría** desarrollado para la base de datos _empresa_segura_, empleando el motor **PostgreSQL**.

El propósito central de este proyecto es demostrar cómo se aplican de manera práctica los mecanismos esenciales de seguridad en bases de datos corporativas, abordando los pilares fundamentales:

- **🔑 Control de Acceso y Mínimo Privilegio**:  
  Creación de roles diferenciados (`admin_rrhh`, `lector_rrhh`, `usuario_consulta`) y asignación precisa de permisos para evitar accesos indebidos.

- **🛡️ Confidencialidad de la Información Sensible**:  
  Implementación de **vistas seguras** que ocultan datos privados como salarios y fechas de nacimiento, garantizando protección de PII (Personal Identifiable Information).

- **📜 Integridad, Auditoría y Trazabilidad**:  
  Desarrollo de **triggers en PL/pgSQL** que registran cada operación relevante (`INSERT`, `UPDATE`, `DELETE`) en una tabla forense (`audit_log`) utilizando formato **JSONB**, permitiendo reconstruir cualquier cambio.

- **💾 Disponibilidad y Resiliencia Operativa**:  
  Configuración y documentación de un esquema de **backup y restauración**, que incluye respaldos completos y reproducción de WAL, asegurando capacidad de **recuperación a un punto exacto en el tiempo (PITR)**.

Este proyecto refleja una arquitectura sólida, segura y alineada con buenas prácticas profesionales en el manejo de datos corporativos.
