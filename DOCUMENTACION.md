<div style="text-align:center; font-family:Georgia;">

<h1><i><u>Trabajo de Base de Datos – Proyecto RRHH</u></i></h1>

<h3><i>Autora: <b>Valery Alarcón</b></i></h3>
<h3><i>Docente: <b>Hely Suárez</b></i></h3>

</div>

---

<h2><u><i>Objetivo</i></u></h2>

<p style="font-size:17px;">
Diseñar e implementar una base de datos para el área de Recursos Humanos en PostgreSQL, 
incluyendo la creación de tablas, vistas, roles, usuarios y la asignación de permisos adecuados.
</p>

---

<h2><u><i>1. Tablas creadas</i></u></h2>

<h3><i>✧ Tabla <b>empleados</b></i></h3>
<ul>
  <li>id_empleado (PK)</li>
  <li>nombre</li>
  <li>apellido</li>
  <li>fecha_contratacion</li>
  <li>salario</li>
  <li>id_departamento (FK)</li>
</ul>

<h3><i>✧ Tabla <b>departamentos</b></i></h3>
<ul>
  <li>id_departamento (PK)</li>
  <li>nombre</li>
</ul>

<h3><i>✧ Tabla <b>historial_salarios</b></i></h3>
<ul>
  <li>id_historial (PK)</li>
  <li>id_empleado (FK)</li>
  <li>salario_anterior</li>
  <li>fecha_cambio</li>
</ul>

---

<h2><u><i>2. Vistas creadas</i></u></h2>

<h3><i>✧ Vista <b>vista_empleados_salario_alto</b></i></h3>
<p>Muestra los empleados con salario superior al promedio.</p>

<h3><i>✧ Vista <b>vista_empleados_por_fecha</b></i></h3>
<p>Ordena empleados por fecha de contratación.</p>

---

<h2><u><i>3. Roles definidos</i></u></h2>

<h3 style="color:#1a73e8;"><i>🔹 Rol <b>lector_rrhh</b></i></h3>
<p>Permite únicamente realizar consultas (SELECT) sobre las tablas y vistas.</p>

<h3 style="color:#d93025;"><i>🔹 Rol <b>admin_rrhh</b></i></h3>
<p>
Permite acceso total (ALL PRIVILEGES) a todas las tablas y vistas.  
Incluye login, contraseña y fecha de expiración de 90 días.
</p>

---

<h2><u><i>4. Usuario creado</i></u></h2>

<h3><i>👤 Usuario <b>usuario_consulta</b></i></h3>
<p>
Se le asigna el rol <b>lector_rrhh</b>.<br>
Contraseña: <b>User123.</b>
</p>

---

<h2><u><i>5. Sentencias SQL</i></u></h2>

<p><u>Crear rol lector:</u></p>

```sql
CREATE ROLE lector_rrhh;
