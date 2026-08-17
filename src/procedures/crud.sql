-- =================================================
-- CRUD Citas
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
