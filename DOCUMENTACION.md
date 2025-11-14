# Reporte de Implementación de Seguridad en Bases de Datos

*Motor de Base de Datos:* **PostgreSQL**

**Estudiante:** Valery Alarcón
**Docente:** Hely Suárez

---

## 1. Introducción y Principios de Seguridad

Este reporte describe la implementación del sistema de ***Seguridad, Control de Acceso y Auditoría*** para la base de datos *seguridad\_empresa*, utilizando **PostgreSQL**.

El diseño se fundamenta en los siguientes principios esenciales de seguridad:

* ***Principio de Mínimo Privilegio:*** Cada usuario solo accede a los datos y funcionalidades estrictamente necesarios.
* ***Confidencialidad, Integridad y Disponibilidad (CID):*** Asegurar que la información sea privada, confiable, precisa y accesible cuando se requiera.
* ***Trazabilidad y Responsabilidad:*** Todas las operaciones críticas quedan registradas para su posterior revisión.

---

## 2. Control de Acceso y Roles Implementados

Para garantizar la seguridad, se establecieron ***roles y usuarios*** con permisos claramente delimitados, basados en el principio de mínimo privilegio.

### Rol: *admin\_rrhh*
* **Tipo:** Rol administrativo con inicio de sesión.
* **Función:** Gestión completa de la información del área de RRHH.
* **Permisos:** *SELECT, INSERT, UPDATE, DELETE* sobre todas las tablas y vistas.
* **Seguridad:** Contraseña con expiración (*VALID UNTIL 90 days*).

### Rol: *lector\_rrhh*
* **Tipo:** Rol de lectura (usado para agrupar permisos).
* **Función:** Consultas sin riesgo de modificar datos sensibles.
* **Permisos:** *SELECT* en todas las tablas y en las vistas públicas de seguridad.

### Usuario: *usuario\_consulta*
* **Permisos:** Exclusivamente hereda el rol *lector\_rrhh*.
* **Función:** Acceder a reportes y realizar consultas seguras.

---

## 3. Seguridad a Nivel de Datos mediante Vistas

Para proteger la ***Confidencialidad*** (*PII*) y la ***Integridad***, se implementaron vistas de seguridad.

| Vista | Mecanismo de Seguridad | Finalidad |
| :--- | :--- | :--- |
| **vista\_empleados\_sin\_datos\_sensibles** | Oculta campos sensibles como *salary* y *birth\_date*. | ***Protección de datos personales (PII)***. |
| **vista\_empleados\_salario\_alto** | Filtra solo empleados con salarios elevados. | Consultas segmentadas sin exponer la base de datos completa. |
| **vista\_empleados\_por\_fecha** | Cláusula ***WITH CHECK OPTION*** en *hire\_date*. | ***Garantiza la integridad*** en inserciones/cambios realizados a través de la vista. |

---

## 4. Auditoría Transaccional y Registro de Cambios

Se implementó un sistema de auditoría forense para registrar toda operación crítica realizada sobre la tabla *empleados*, garantizando la ***Trazabilidad***.

### Tabla de Auditoría: *audit\_log*
Esta tabla forense registra metadatos y el estado de los datos (*OLD* y *NEW*) en formato ***JSONB***, permitiendo la reconstrucción precisa de los eventos.

### Triggers *AFTER*
Se crearon ***triggers de tipo AFTER*** (*AFTER INSERT, AFTER UPDATE, AFTER DELETE*), que garantizan la trazabilidad completa al ejecutarse después de la modificación, registrando cada cambio ejecutado por los usuarios del sistema.

---

## 5. Estrategia de Backup y Disponibilidad

Para asegurar la ***Disponibilidad*** y la resiliencia operativa, se documentó un esquema de respaldo:

* **Backups completos:** Uso de la herramienta ***pg\_dump***.
* **Restauraciones:** Mediante ***pg\_restore***.
* **Recuperación a un punto exacto (*PITR*):** Revisión de la configuración del ***WAL (Write-Ahead Log)***.

Esta estrategia permite recuperar la base de datos ante fallos, pérdida de datos o errores humanos, garantizando la ***continuidad operativa*** y mínima pérdida de información.
