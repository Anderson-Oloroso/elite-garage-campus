USE elite_garage_campus;

-- Insertar registros en la tabla clientes
INSERT INTO clients (id, first_name, last_name, email) VALUES
(1, 'Carlos', 'Mendoza', 'carlos.mendoza@gmail.com'),
(2, 'Ana', 'Rodriguez', 'ana.rodriguez@gmail.com'),
(3, 'Luis', 'Fernandez', 'luis.fernandez@gmail.com'),
(4, 'Sofia', 'Castillo', 'sofia.castillo@gmail.com'),
(5, 'Jorge', 'Morales', 'jorge.morales@gmail.com'),
(6, 'Elena', 'Gomez', 'elena.gomez@gmail.com'),
(7, 'Daniel', 'Ramirez', 'daniel.ramirez@gmail.com'),
(8, 'Laura', 'Torres', 'laura.torres@gmail.com'),
(9, 'Miguel', 'Herrera', 'miguel.herrera@gmail.com'),
(10, 'Valentina', 'Perez', 'valentina.perez@gmail.com');


-- Insertar registros en la tabla vehiculos
INSERT INTO vehicles (id, client_id, make, model, plate, year_made) VALUES
(1, 1, 'Toyota', 'Corolla', 'ABC1234', 2020),
(2, 2, 'Honda', 'Civic', 'DEF5678', 2021),
(3, 3, 'Ford', 'Mustang', 'GHI9012', 2019),
(4, 4, 'Chevrolet', 'Camaro', 'JKL3456', 2022),
(5, 5, 'BMW', 'M3', 'MNO7890', 2023),
(6, 6, 'Mercedes-Benz', 'C200', 'PQR1234', 2021),
(7, 7, 'Audi', 'A4', 'STU5678', 2020),
(8, 8, 'Nissan', 'Sentra', 'VWX9012', 2018),
(9, 9, 'Mazda', 'CX-5', 'YZA3456', 2022),
(10, 10, 'Volkswagen', 'Golf', 'BCD7890', 2019);


-- Insertar registros en la tabla servicios
INSERT INTO services (id, name_service, category, base_price, duration_min) VALUES
(1, 'Cambio de aceite', 'Mantenimiento', 75.00, 45),
(2, 'Alineacion y balanceo', 'Mantenimiento', 90.00, 60),
(3, 'Cambio de frenos', 'Frenos', 250.00, 120),
(4, 'Diagnostico computarizado', 'Diagnostico', 60.00, 40),
(5, 'Cambio de bateria', 'Electricidad', 150.00, 50),
(6, 'Cambio de bujias', 'Motor', 120.00, 90),
(7, 'Revision de suspension', 'Suspension', 180.00, 100),
(8, 'Cambio de refrigerante', 'Mantenimiento', 80.00, 60),
(9, 'Reparacion de aire acondicionado', 'Climatizacion', 300.00, 180),
(10, 'Lavado premium', 'Estetica', 100.00, 90);


-- Insertar registros en la tabla mecanicos
INSERT INTO mechanics (id, name_mechanic, speciality, state) VALUES
(1, 'Pedro Alvarez', 'Motor', 'activo'),
(2, 'Mario Sanchez', 'Frenos', 'activo'),
(3, 'Andres Gutierrez', 'Electricidad', 'activo'),
(4, 'Ricardo Torres', 'Diagnostico', 'activo'),
(5, 'Fernando Castro', 'Suspension', 'activo'),
(6, 'Diego Ramirez', 'Climatizacion', 'activo'),
(7, 'Sebastian Lopez', 'Mantenimiento', 'activo'),
(8, 'Alejandro Vargas', 'Estetica', 'inactivo'),
(9, 'Gabriel Rojas', 'Motor', 'activo'),
(10, 'Nicolas Martinez', 'Frenos', 'activo');


-- Insertar registros en la tabla servicios y sus relaciones con vehiculos, servicios y mecanicos
INSERT INTO appointments (id, vehicle_id, service_id, mechanic_id, date_programmed, state) VALUES
(1, 1, 1, 7, '2026-08-10', 'COMPLETADA'),
(2, 2, 2, 7, '2026-08-11', 'COMPLETADA'),
(3, 3, 3, 2, '2026-08-12', 'EN_PROCESO'),
(4, 4, 4, 4, '2026-08-13', 'PENDIENTE'),
(5, 5, 5, 3, '2026-08-14', 'PENDIENTE'),
(6, 6, 6, 1, '2026-08-15', 'COMPLETADA'),
(7, 7, 7, 5, '2026-08-16', 'EN_PROCESO'),
(8, 8, 8, 7, '2026-08-17', 'CANCELADA'),
(9, 9, 9, 6, '2026-08-18', 'PENDIENTE'),
(10, 10, 10, 8, '2026-08-19', 'CANCELADA');