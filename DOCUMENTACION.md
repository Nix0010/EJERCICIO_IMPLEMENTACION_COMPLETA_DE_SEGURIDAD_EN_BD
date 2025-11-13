# 📄 Reporte de Implementación de Seguridad en Bases de Datos

## 1. Introducción y Principios de Seguridad
Este reporte documenta la implementación de un sistema completo de seguridad y administración para la base de datos ficticia `empresa_segura` (MySQL 8.0+). La arquitectura de seguridad se fundamenta en dos pilares clave:

- **Principio de Mínimo Privilegio**: Limitar el acceso de los usuarios a solo los recursos y permisos estrictamente necesarios.
- **Modelo de Confidencialidad, Integridad y Disponibilidad (CID)**: Asegurar que los datos sensibles están protegidos, que son exactos y que siempre son accesibles.

---

## 2. Control de Acceso y Gestión de Usuarios

Se establecieron tres roles de usuario distintos para aislar las responsabilidades y mitigar el riesgo operativo:

| Rol             | Permisos Otorgados                        | Justificación de Mínimo Privilegio                                           |
|-----------------|------------------------------------------|-------------------------------------------------------------------------------|
| `admin_rrhh`    | SELECT, INSERT, UPDATE, DELETE solo en la tabla `empleados` | Restricción total a una sola tabla. Previene la alteración de información financiera o estructural. |
| `analista_bi`   | SELECT en `empresa_segura.*`             | Solo capacidad de lectura. Garantiza que los informes y análisis no comprometan la integridad de los datos. |
| `desarrollador` | SELECT, INSERT, UPDATE en `empresa_segura.*` | Otorga permisos para el ciclo de desarrollo, excluyendo explícitamente DELETE para prevenir pérdidas de datos catastróficas. |

🔐 **Política de Expiración**:  
La cláusula `PASSWORD EXPIRE INTERVAL 90 DAY` se aplicó a todos los usuarios. Esta medida de seguridad fuerza la rotación trimestral de contraseñas, reduciendo el riesgo de credenciales comprometidas.

---

## 3. Seguridad a Nivel de Datos mediante Vistas

Se utilizaron vistas como una capa de abstracción para imponer seguridad y validación sin modificar la tabla base:

| Vista               | Mecanismo de Seguridad                               | Justificación |
|--------------------|------------------------------------------------------|---------------|
| `empleados_publico` | Ocultamiento de campos sensibles (`salary`, `birth_date`) | Confidencialidad. Aplica seguridad a nivel de columna (Column-level Security), restringiendo el acceso a PII. |
| `resumen_departamental` | Uso de funciones de agregación (`AVG`, `COUNT`) | Privacidad. Impide que un usuario pueda trazar información individual (salarios), solo permitiendo el acceso a datos estadísticos consolidados. |
| `empleados_activos` | Uso de `WITH CHECK OPTION`                           | Integridad. Garantiza que cualquier INSERT o UPDATE ejecutada a través de la vista valide la condición de "empleado activo" (`hire_date <= CURDATE()`). |

---

## 4. Auditoría Transaccional y Trazabilidad

Se implementó un sistema de logging forense en la tabla `empleados` (la más crítica) mediante triggers:

- **Tabla `audit_log`**: Captura metadatos clave (`operacion`, `usuario`, `timestamp`).  
- **Uso de Triggers `AFTER`**: Asegura que solo se registren las transacciones que se completaron con éxito.  
- **Registro de Valores `OLD` y `NEW`**: Para las operaciones de UPDATE, se registraron tanto los valores anteriores como los nuevos en un campo `datos_json`. Esto permite una trazabilidad completa de los cambios, crucial para investigaciones de seguridad.

---

## 5. Disponibilidad y Estrategia de Backup

Se configuró una estrategia de **Recuperación a un Punto en el Tiempo (PITR)** para maximizar la disponibilidad de los datos:

- **Habilitación del Binary Log (`log-bin`)**: Fundamental para el backup incremental, ya que registra todas las transacciones SQL en archivos secuenciales.  
- **Estrategia Híbrida**: Combina el Backup Completo (`mysqldump`) para la estructura y la base, con el Backup Incremental (`mysqlbinlog`) para capturar las transacciones posteriores.  
- **Proceso de Restauración**: La simulación demostró que, al aplicar el backup completo seguido del incremental, se restablece la BD a un punto exacto en el tiempo entre backups, minimizando la pérdida de datos y garantizando la disponibilidad de la información.
