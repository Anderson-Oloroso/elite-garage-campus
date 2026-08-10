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

