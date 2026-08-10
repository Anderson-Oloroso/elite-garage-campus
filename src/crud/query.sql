-- =========================================
-- CRUD clients
-- =========================================
USE elite_garage_campus;

DELIMITER //
CREATE PROCEDURE sp_create_client(IN p_first_name VARCHAR(30), IN p_last_name VARCHAR(30), p_email VARCHAR(100))
BEGIN 
	DECLARE p_id INT;
	INSERT INTO clients (first_name, last_name, email)
		VALUES
			(p_first_name, p_last_name, p_email);      
	SET p_id = last_insert_id();
    SELECT p_id;
END//
DELIMITER ;

CALL sp_create_client('Sofi', 'De la Cruz', 'sofi@correo.com');
SELECT * FROM clients; 	

	DELIMITER //
	CREATE PROCEDURE sp_update_client(IN p_id INT,IN p_first_name VARCHAR(30),IN p_last_name VARCHAR(30),IN p_email VARCHAR(100))
	BEGIN
	  IF p_id IS NULL OR p_id <= 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID inválido';
	  END IF;
	  IF p_first_name IS NULL OR TRIM(p_first_name) = '' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'first_name no puede estar vacío';
	  END IF;
	  IF p_last_name IS NULL OR TRIM(p_last_name) = '' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'last_name no puede estar vacío';
	  END IF;
	  IF p_email IS NULL OR TRIM(p_email) = '' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'email no puede estar vacío';
	  END IF;	
      UPDATE clients
	  SET first_name = p_first_name,
		  last_name  = p_last_name,
		  email = p_email
	  WHERE id = p_id;
	END //

DELIMITER ;

CALL sp_update_client(11, 'Sofia', 'Arrivillaga', 'sofia.arrivillaga@correo.com');
SELECT * FROM clients;

DELIMITER //
CREATE PROCEDURE sp_select_client(IN p_id INT)
BEGIN 
	IF p_id IS NULL THEN
		SELECT * FROM clients;
	END IF;
	IF p_id <= 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID inválido';
	END IF;
	IF NOT EXISTS (SELECT 1 FROM clients WHERE id = p_id) THEN
	  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID no encontrado';
      SELECT * FROM clients;
	END IF;
	SELECT * FROM clients WHERE id = p_id;
END //

DELIMITER ;

CALL sp_select_client(2);

DELIMITER // 
CREATE PROCEDURE sp_delete_client(IN p_id INT)
BEGIN 
	IF p_id <= 0 OR p_id IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID inválido';
	END IF;
	IF NOT EXISTS (SELECT 1 FROM clients WHERE id = p_id) THEN
	  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID no encontrado';
      SELECT * FROM clients;
	END IF;
    IF EXISTS (SELECT * FROM vehicles WHERE client_id = p_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no puede ser eliminado debido a que tiene una relacion con la tabla vehiculos';
	END IF;
    DELETE FROM clients WHERE id = p_id;
END //
DELIMITER ;

CALL sp_delete_client(11);
SELECT * FROM clients;

-- ===========================================
-- CRUD vehicles
-- ===========================================
DELIMITER //
CREATE PROCEDURE sp_create_vehicle(IN p_client_id INT, IN p_make VARCHAR(50), IN p_model VARCHAR(50), IN p_plate VARCHAR(7), IN p_year_made YEAR
)
BEGIN
  DECLARE p_id INT;
  INSERT INTO vehicles (client_id, make, model, plate, year_made)
  VALUES (p_client_id, p_make, p_model, p_plate, p_year_made);
  SET p_id = LAST_INSERT_ID();
  SELECT p_id AS id;
END//
DELIMITER ;

CALL sp_create_vehicle(1, 'Toyota', 'Corolla', 'ABC1234', 2019);
SELECT * FROM vehicles;



DELIMITER //
CREATE PROCEDURE sp_update_vehicle(IN p_id INT, IN p_client_id INT, IN p_make VARCHAR(50), IN p_model VARCHAR(50), IN p_plate VARCHAR(7), IN p_year_made YEAR
)
BEGIN
  IF p_id IS NULL OR p_id <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID inválido';
  END IF;

  IF p_make IS NULL OR TRIM(p_make) = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'make no puede estar vacío';
  END IF;

  IF p_model IS NULL OR TRIM(p_model) = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'model no puede estar vacío';
  END IF;

  IF p_plate IS NULL OR TRIM(p_plate) = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'plate no puede estar vacío';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM vehicles WHERE id = p_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID no encontrado';
  END IF;

  UPDATE vehicles
  SET client_id = p_client_id,
      make = p_make,
      model = p_model,
      plate = p_plate,
      year_made  = p_year_made
  WHERE id = p_id;
END//
DELIMITER ;

CALL sp_update_vehicle(1, 1, 'Nissan', 'Sentra', 'XYZ5678', 2020);
SELECT * FROM vehicles;



DELIMITER //
CREATE PROCEDURE sp_select_vehicle(IN p_id INT)
BEGIN
  IF p_id IS NULL THEN
    SELECT * FROM vehicles;
  END IF;

  IF p_id <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID inválido';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM vehicles WHERE id = p_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID no encontrado';
    SELECT * FROM vehicles;
  END IF;

  SELECT * FROM vehicles WHERE id = p_id;
END//
DELIMITER ;

CALL sp_select_vehicle(1);



DELIMITER //
CREATE PROCEDURE sp_delete_vehicle(IN p_id INT)
BEGIN
  IF p_id IS NULL OR p_id <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID inválido';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM vehicles WHERE id = p_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID no encontrado';
    SELECT * FROM vehicles;
  END IF;

  -- validación por FK con appointments
  IF EXISTS (SELECT 1 FROM appointments WHERE vehicle_id = p_id) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El vehículo no puede ser eliminado debido a que tiene una relación con la tabla appointments';
  END IF;

  DELETE FROM vehicles WHERE id = p_id;
END//
DELIMITER ;

CALL sp_delete_vehicle(1);
SELECT * FROM vehicles;

-- =================================================
-- CRUD Services
-- =================================================

DELIMITER //
CREATE PROCEDURE sp_create_service(IN p_name_service VARCHAR(50), IN p_category VARCHAR(50), IN p_base_price FLOAT(7,2), IN p_duration INT)
BEGIN
	IF p_name_service IS NULL OR TRIM(p_name_service) = '' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Por favor ingrese el nombre del nuevo servicio';
	END IF;
    IF p_category IS NULL OR TRIM(p_category) = '' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Por favor Ingrese una categoria válida';
	END IF;
    IF p_base_price IS NULL OR p_base_price <=0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Precio base no válido';
	END IF;
    IF p_duration IS NULL OR p_duration <= 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La duración no es válida';
    END IF;
    INSERT INTO services (name_service, category, base_price, duration_min) VALUES (p_name_service, p_category, p_base_price, p_duration);
END //
DELIMITER ;

CALL sp_create_service('Cambio de aceite', 'Mantenimiento preventivo', '300', 30);
SELECT * FROM services;

DELIMITER //
CREATE PROCEDURE sp_select_service(IN p_id INT)
BEGIN 
	IF p_id IS NULL OR p_id <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'EL id no es válido';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM services WHERE id = p_id) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun servicio con dicho id';
    END IF;
    SELECT * FROM services WHERE id = p_id;
END //
DELIMITER ;

CALL sp_select_service(11);


DELIMITER //
CREATE PROCEDURE sp_delete_service(IN p_id INT)
BEGIN
	IF p_id IS NULL OR p_id <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'EL id no es válido';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM services WHERE id = p_id) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun servicio con dicho id';
    END IF;
    IF EXISTS (SELECT * FROM appointments WHERE id = p_id) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar este servicio debido a que tiene registros vinculados en la tabla citas (appointments)';
    END IF;
    DELETE FROM services WHERE id = p_id;
END //
DELIMITER ;

CALL sp_delete_service(11);
SELECT * FROM services;

DELIMITER //
CREATE PROCEDURE sp_update_service(IN p_id INT,IN p_name_service VARCHAR(50), IN p_category VARCHAR(50), IN p_base_price FLOAT(7,2), IN p_duration INT)
BEGIN 
	IF p_id IS NULL OR p_id <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'EL id no es válido';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM services WHERE id = p_id) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun servicio con dicho id';
    END IF;
    IF p_name_service IS NULL
		OR TRIM(p_name_service) = ''
        OR p_category IS NULL
        OR TRIM(p_category) = ''
	THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puede haber ningún campo vacío o nulo';
    END IF;
    IF p_base_price <= 0 OR p_base_price IS NULL OR p_duration IS NULL OR p_duration <= 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El precio o la duracion no pueden estar vacios o nulos';
    END IF;
    UPDATE services SET
		name_service = p_name_service,
        category = p_category,
        base_price = p_base_price,
        duration_min = p_duration
	WHERE id = p_id;
END //
DELIMITER ;

CALL sp_update_service(10,'Lavado Premium Plus', 'Estética', 100.00, 60);
SELECT * FROM services;

-- =================================================
-- CRUD Mechanics
-- =================================================

DELIMITER //
CREATE PROCEDURE sp_create_mechanic(
    IN p_name_mechanic VARCHAR(50),
    IN p_speciality VARCHAR(40),
    IN p_state ENUM('activo', 'inactivo')
)
BEGIN
    IF p_name_mechanic IS NULL OR TRIM(p_name_mechanic) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Por favor ingrese el nombre del mecánico';
    END IF;

    IF p_speciality IS NULL OR TRIM(p_speciality) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Por favor ingrese una especialidad válida';
    END IF;

    IF p_state IS NULL THEN
        SET p_state = 'activo';
    END IF;

    INSERT INTO mechanics(name_mechanic, speciality, state)
    VALUES (p_name_mechanic, p_speciality, p_state);
END //
DELIMITER ;

CALL sp_create_mechanic('Juan Pérez', 'Motor', 'activo');
SELECT * FROM mechanics;

DELIMITER //
CREATE PROCEDURE sp_select_mechanic(IN p_id INT)
BEGIN
    IF p_id IS NULL OR p_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id no es válido';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM mechanics WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningún mecánico con dicho id';
    END IF;

    SELECT * FROM mechanics WHERE id = p_id;
END //
DELIMITER ;

CALL sp_select_mechanic(1);

DELIMITER //
CREATE PROCEDURE sp_delete_mechanic(IN p_id INT)
BEGIN
    IF p_id IS NULL OR p_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id no es válido';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM mechanics WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningún mecánico con dicho id';
    END IF;

    IF EXISTS (SELECT 1 FROM appointments WHERE mechanic_id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar este mecánico debido a que tiene registros vinculados en appointments';
    END IF;

    DELETE FROM mechanics WHERE id = p_id;
END //
DELIMITER ;

SELECT * FROM mechanics;

DELIMITER //
CREATE PROCEDURE sp_update_mechanic(
    IN p_id INT,
    IN p_name_mechanic VARCHAR(50),
    IN p_speciality VARCHAR(40),
    IN p_state ENUM('activo', 'inactivo')
)
BEGIN
    IF p_id IS NULL OR p_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id no es válido';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM mechanics WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningún mecánico con dicho id';
    END IF;

    IF p_name_mechanic IS NULL OR TRIM(p_name_mechanic) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puede haber nombre vacío o nulo';
    END IF;

    IF p_speciality IS NULL OR TRIM(p_speciality) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puede haber especialidad vacía o nula';
    END IF;

    IF p_state IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado no puede estar vacío o ser nulo';
    END IF;

    UPDATE mechanics
    SET name_mechanic = p_name_mechanic,
        speciality = p_speciality,
        state = p_state
    WHERE id = p_id;
END //
DELIMITER ;

CALL sp_update_mechanic(1, 'Juan Pérez', 'Motor', 'inactivo');
SELECT * FROM mechanics;

-- =================================================
-- CRUD Appointments
-- =================================================

DELIMITER //
CREATE PROCEDURE sp_create_appointment(
    IN p_vehicle_id INT,
    IN p_service_id INT,
    IN p_mechanic_id INT,
    IN p_date_programmed DATE,
    IN p_state ENUM('EN_PROCESO', 'PENDIENTE', 'COMPLETADA', 'CANCELADA')
)
BEGIN
    IF p_vehicle_id IS NULL OR p_vehicle_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Por favor ingrese un vehicle_id válido';
    END IF;

    IF p_service_id IS NULL OR p_service_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Por favor ingrese un service_id válido';
    END IF;

    IF p_mechanic_id IS NULL OR p_mechanic_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Por favor ingrese un mechanic_id válido';
    END IF;

    IF p_date_programmed IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Por favor ingrese una fecha válida';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM vehicles WHERE id = p_vehicle_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun vehiculo con ese vehicle_id';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM services WHERE id = p_service_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun servicio con ese service_id';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM mechanics WHERE id = p_mechanic_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun mecanico con ese mechanic_id';
    END IF;

    IF p_state IS NULL THEN
        SET p_state = 'PENDIENTE';
    END IF;

    INSERT INTO appointments(vehicle_id, service_id, mechanic_id, date_programmed, state)
    VALUES (p_vehicle_id, p_service_id, p_mechanic_id, p_date_programmed, p_state);
END //
DELIMITER ;

CALL sp_create_appointment(1, 1, 1, '2026-08-10', 'PENDIENTE');
SELECT * FROM appointments;


DELIMITER //
CREATE PROCEDURE sp_select_appointment(IN p_id INT)
BEGIN
    IF p_id IS NULL OR p_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id no es válido';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM appointments WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun appointment con dicho id';
    END IF;

    SELECT * FROM appointments WHERE id = p_id;
END //
DELIMITER ;

CALL sp_select_appointment(1);


DELIMITER //
CREATE PROCEDURE sp_delete_appointment(IN p_id INT)
BEGIN
    IF p_id IS NULL OR p_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id no es válido';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM appointments WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun appointment con dicho id';
    END IF;

    DELETE FROM appointments WHERE id = p_id;
END //
DELIMITER ;

SELECT * FROM appointments;


DELIMITER //
CREATE PROCEDURE sp_update_appointment(
    IN p_id INT,
    IN p_vehicle_id INT,
    IN p_service_id INT,
    IN p_mechanic_id INT,
    IN p_date_programmed DATE,
    IN p_state ENUM('EN_PROCESO', 'PENDIENTE', 'COMPLETADA', 'CANCELADA')
)
BEGIN
    IF p_id IS NULL OR p_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id no es válido';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM appointments WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun appointment con dicho id';
    END IF;

    IF p_vehicle_id IS NULL OR p_vehicle_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'vehicle_id no es válido';
    END IF;

    IF p_service_id IS NULL OR p_service_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'service_id no es válido';
    END IF;

    IF p_mechanic_id IS NULL OR p_mechanic_id <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'mechanic_id no es válido';
    END IF;

    IF p_date_programmed IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha no puede ser nula';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM vehicles WHERE id = p_vehicle_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun vehiculo con ese vehicle_id';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM services WHERE id = p_service_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun servicio con ese service_id';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM mechanics WHERE id = p_mechanic_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ningun mecanico con ese mechanic_id';
    END IF;

    IF p_state IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado no puede ser nulo';
    END IF;

    UPDATE appointments
    SET vehicle_id = p_vehicle_id,
        service_id = p_service_id,
        mechanic_id = p_mechanic_id,
        date_programmed = p_date_programmed,
        state = p_state
    WHERE id = p_id;
END //
DELIMITER ;

CALL sp_update_appointment(1, 1, 1, 1, '2026-08-11', 'EN_PROCESO');
SELECT * FROM appointments;
