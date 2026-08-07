CREATE DATABASE elite_garage_campus;

USE elite_garage_campus;

-- Crear la tabla clientes
CREATE TABLE IF NOT EXISTS clients(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL, 
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)ENGINE=InnoDB;

-- Crear tabla vehiculos
CREATE TABLE IF NOT EXISTS vehicles(
	id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL, 
    plate VARCHAR(7) NOT NULL,
    year_made YEAR,
    CONSTRAINT fk_clients_vehicles FOREIGN KEY (client_id) REFERENCES clients(id) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=InnoDB;

-- Crear tabla servicios
CREATE TABLE IF NOT EXISTS services(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name_service VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    base_price FLOAT(7,2) NOT NULL,
    duration_min INT CHECK (duration_min > 0)
)ENGINE=InnoDB;

-- Crear tabla mecanicos
CREATE TABLE IF NOT EXISTS mechanics(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name_mechanic VARCHAR(50) NOT NULL,
    speciality VARCHAR(40) NOT NULL,
	state ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo'
)ENGINE=InnoDB;

-- Crear la tabla servicios y sus relaciones con vehiculos, servicios y mecanicos
CREATE TABLE IF NOT EXISTS appointments(
	id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT NOT NULL,
    service_id INT NOT NULL,
    mechanic_id INT NOT NULL,
    date_programmed DATE NOT NULL,
    state ENUM('EN_PROCESO', 'PENDIENTE', 'COMPLETADA', 'CANCELADA') DEFAULT 'PENDIENTE',
    CONSTRAINT fk_appoint_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON UPDATE CASCADE,
    CONSTRAINT fk_appoint_service FOREIGN KEY (service_id) REFERENCES services(id) ON UPDATE CASCADE,
    CONSTRAINT fk_appoint_mechanic FOREIGN KEY (mechanic_id) REFERENCES mechanics(id) ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE INDEX idx_fisrt_last_name ON clients(first_name, last_name); -- Crear indice para buscar por nombre y apellido en clientes
CREATE INDEX idx_make ON vehicles(make); -- Crear indice para buscar por modelo en vehiculos
CREATE INDEX idx_category ON services(category); -- Crear indice para buscar por categoria en servicios
CREATE INDEX idx_mechanics_cat ON mechanics(speciality); -- Buscar por especialidad en mecanicos
CREATe INDEX idx_state ON appointments(state); -- Buscar poe estado en servicios