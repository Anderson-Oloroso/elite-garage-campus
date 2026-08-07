# Análisis de requerimientos 🔧

## Requerimientos funcionales ✨

1. **Entidades detectadas:**

    - `clientes`: Se registrarán los datos de los clientes a los cuales se les prestarán los servicios
    - `vehiculos`: Se registrarán los vehículos que ingresen al taller para sus restectivas citas.
    - `servicios`: Estará registrando los catálogos de los servicios que el taller mecánico ofrece.
    - `mecanicos`: Registrará todos los mecánicos con los que el taller cuenta.
    - `citas`: Registrará todo lo relacionado a las citas, sus reservas y estado de trabajo.

2. **Relaciones:**

    - `cliente - vehiculos`: Relación de el cliente hacia su respectivo auto. **Relación 1 a muchos**
    - `vehiculos - citas`: Relación de el vehículo con su cita agendada. **Relación 1 a muchos**
    - `servicios - citas`: Relación con el servicio y la cita, para el vehiculo. **Relación 1 a 1**
    - `mecanico - citas`: Relacion del mecánico con las citas. **Relación muchos a 1**

3. **Reglas**:

    - Mantener la cardinalidad.
    - Sin datos duplicados.
    - El cliente puede tener varios vehícuolos pero no viceversa.
    - Un vehiculo puede tener varias citas, pero no viceversa.
    - Por cada cita solo se efectuará un servicio, si el cliente necesita otro servicio, tendrá que agendar una nueva cita.
    - Una cita puede tener varios mecánicos, pero no viceversa.

---