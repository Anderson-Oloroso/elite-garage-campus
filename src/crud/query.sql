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
		  email       = p_email
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