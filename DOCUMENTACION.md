
# 📄 Reporte de Implementación de Seguridad en Bases de Datos (PostgreSQL)

## 1. Introducción y Principios de Seguridad
Este reporte documenta la implementación completa de un sistema de **Seguridad y Administración** para la base de datos ficticia `empresa_segura`, utilizando **PostgreSQL**. La arquitectura se basa en los siguientes principios:

- **🔑 Principio de Mínimo Privilegio**: Limitar el acceso de los usuarios a solo los recursos y permisos estrictamente necesarios.
- **🛡️ Modelo de Confidencialidad, Integridad y Disponibilidad (CID)**: Asegurar que los datos sensibles están protegidos, que son exactos y que siempre son accesibles.

---

## 2. Control de Acceso y Gestión de Usuarios

Se establecieron tres roles/usuarios distintos para aislar las responsabilidades y mitigar el riesgo operativo:

| Rol             | Permisos Otorgados                            | Justificación de Mínimo Privilegio                                           |
|-----------------|----------------------------------------------|-------------------------------------------------------------------------------|
| `admin_rrhh`    | SELECT, INSERT, UPDATE, DELETE solo en la tabla `empleados` | Restricción total a una sola tabla. Previene la alteración de información financiera o estructural. |
| `analista_bi`   | SELECT en **ALL TABLES IN SCHEMA public**    | Solo capacidad de lectura. Garantiza que los informes y análisis no comprometan la integridad de los datos. |
| `desarrollador` | SELECT, INSERT, UPDATE en **ALL TABLES IN SCHEMA public** | Otorga permisos para el ciclo de desarrollo, excluyendo explícitamente DELETE para prevenir pérdidas de datos catastróficas. |

🔐 **Política de Expiración**:  
PostgreSQL no gestiona la expiración de contraseñas directamente con la cláusula `CREATE USER`. Esta política debe implementarse mediante un servidor de autenticación externo (como **LDAP**) o una herramienta de gestión de cuentas que rote las contraseñas cada **90 días**.

---

## 3. Seguridad a Nivel de Datos mediante Vistas

Se utilizaron vistas como capa de abstracción para imponer seguridad y validación sin modificar la tabla base:

| Vista               | Mecanismo de Seguridad                                | Justificación |
|--------------------|-------------------------------------------------------|---------------|
| `empleados_publico` | Ocultamiento de campos sensibles (`salary`, `birth_date`) | Confidencialidad. Aplica seguridad a nivel de columna, restringiendo el acceso a PII. |
| `resumen_departamental` | Uso de funciones de agregación (`AVG`, `COUNT`)     | Privacidad. Impide que un usuario pueda trazar información individual (salarios), solo permitiendo el acceso a datos estadísticos consolidados. |
| `empleados_activos` | Uso de `WITH CHECK OPTION` y `CURRENT_DATE`         | Integridad. Garantiza que cualquier INSERT o UPDATE ejecutada a través de la vista valide la condición de "empleado activo" (`hire_date <= CURRENT_DATE`). |

---

## 4. Auditoría Transaccional y Trazabilidad

Se implementó un sistema de **logging forense** en la tabla `empleados` mediante **Funciones y Triggers (PL/pgSQL)**:

- **Tabla `audit_log`**: Captura metadatos clave (`operacion`, `usuario` usando `CURRENT_USER`, `timestamp`). Se utiliza el tipo de dato **JSONB** para un almacenamiento eficiente y rápido acceso.  
- **Uso de Triggers `AFTER`**: Asegura que solo se registren las transacciones que se completaron con éxito.  
- **Registro de Valores `OLD` y `NEW`**: Para las operaciones de `UPDATE`, se registran los valores anteriores y nuevos usando `jsonb_build_object` dentro del bloque PL/pgSQL. Esto permite una trazabilidad completa de los cambios.

---

## 5. Disponibilidad y Estrategia de Backup

Se configuró una estrategia de **Recuperación a un Punto en el Tiempo (PITR)** para maximizar la disponibilidad de los datos:

- **Habilitación del Write-Ahead Log (WAL)**: Equivalente de PostgreSQL al Binary Log. Registra todas las transacciones SQL en archivos secuenciales (`pg_wal`).  
- **Estrategia Híbrida**: Combina el **Backup Base** (generado por `pg_basebackup` o `pg_dump`) para la estructura y la base, con la **Reproducción de WAL** para capturar las transacciones posteriores.  
- **Proceso de Restauración**: La simulación demostró que, al aplicar el backup base y luego reproducir los archivos WAL, se restablece la BD a un punto exacto en el tiempo entre backups, minimizando la pérdida de datos y garantizando la disponibilidad de la información.

