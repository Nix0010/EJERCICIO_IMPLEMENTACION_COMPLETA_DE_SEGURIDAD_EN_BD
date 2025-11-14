_Reporte de Implementación de Seguridad en Bases de Datos_
=========================================================

### _PostgreSQL_

#### _Estudiante: **Valery Alarcón**_

#### _Docente: **Hely Suárez**_

---

 _1. Introducción y Principios de Seguridad_
----------------------------------------------

Este reporte describe la implementación del sistema de **Seguridad, Control de Acceso y Auditoría** para la base de datos _seguridad_empresa_, utilizando **PostgreSQL**.  
El diseño se fundamenta en los principios esenciales de seguridad:

- _Principio de Mínimo Privilegio_: cada usuario solo accede a lo estrictamente necesario.
- _Confidencialidad, Integridad y Disponibilidad (CID)_: asegurar que la información sea confiable, precisa y accesible.
- _Trazabilidad y responsabilidad_: todas las operaciones críticas quedan registradas.

---

 _2. Control de Acceso y Roles Implementados_
------------------------------------------------

Para garantizar la seguridad, se establecieron **roles y usuarios** con permisos claramente delimitados.

###  _Rol: admin_rrhh_

- **Tipo:** Rol administrativo con inicio de sesión.
- **Permisos:** `SELECT`, `INSERT`, `UPDATE`, `DELETE` sobre todas las tablas y vistas.
- **Función:** Gestionar la información del área de RRHH.
- **Seguridad:** Contraseña con expiración (`VALID UNTIL 90 days`).

---

###  _Rol: lector_rrhh_

- **Tipo:** Rol de lectura.
- **Permisos:**
  - `SELECT` en todas las tablas (`empleados`, `departamentos`, `historial_salarios`).
  - `SELECT` en vistas públicas:
    - `vista_empleados_sin_datos_sensibles`
    - `vista_empleados_por_fecha`
    - `vista_empleados_salario_alto`
- **Función:** Consultas sin riesgo de modificar datos sensibles.

---

###  _Usuario: usuario_consulta_

- **Permisos:** Exclusivamente hereda el rol `lector_rrhh`.
- **Función:** Acceder a reportes y realizar consultas seguras.

---

 _3. Seguridad a Nivel de Datos mediante Vistas_
--------------------------------------------------

Para proteger información sensible se implementaron vistas que ocultan campos privados y validan los datos que ingresan a través de ellas.

| _Vista_                               | _Mecanismo de Seguridad_          | _Finalidad_                                      |
|---------------------------------------|------------------------------------|--------------------------------------------------|
| `vista_empleados_sin_datos_sensibles` | Oculta `salary` y `birth_date`     | Protección de datos personales (PII).            |
| `vista_empleados_salario_alto`        | Filtra solo salarios elevados      | Consultas segmentadas sin exponer datos completos. |
| `vista_empleados_por_fecha`           | `WITH CHECK OPTION` en `hire_date` | Garantiza integridad en cambios.                 |

Estas vistas permiten compartir información sin comprometer la privacidad ni la integridad del sistema.

---

 _4. Auditoría Transaccional y Registro de Cambios_
-----------------------------------------------------

Se implementó un sistema de auditoría para registrar toda operación crítica realizada sobre la tabla `empleados`.

### ✔ _Tabla de Auditoría: `audit_log`_

Registra:

- Tabla afectada  
- Tipo de operación (_INSERT_, _UPDATE_, _DELETE_)  
- Usuario que ejecuta la acción  
- Fecha y hora  
- Datos `OLD` y `NEW` en formato **JSONB**

### ✔ _Triggers AFTER_

Se crearon los triggers:

- **AFTER INSERT**
- **AFTER UPDATE**
- **AFTER DELETE**

Estos mecanismos garantizan trazabilidad completa y permiten reconstruir cualquier cambio ejecutado por los usuarios del sistema.

---

 _5. Estrategia de Backup y Disponibilidad_
---------------------------------------------

Para asegurar la disponibilidad del sistema se implementaron procesos de respaldo y restauración:

- **Backups completos** mediante `pg_dump`.
- **Restauraciones** con `pg_restore`.
- Revisión y documentación de la configuración **WAL (Write-Ahead Log)**.

Esto permite recuperar la base de datos ante:

- fallos del sistema,  
- pérdida de datos,  
- errores humanos,  
- corrupción de archivos.

La estrategia garantiza continuidad operativa y mínima pérdida de información.

---

