CREATE TABLE IF NOT EXISTS streets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    INDEX idx_street_name (name)
);

CREATE TABLE IF NOT EXISTS buildings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    street_id INT NOT NULL,
    number VARCHAR(100) NOT NULL,
    type ENUM('private_house', 'apartment_building') NOT NULL,
    entrances_quantity TINYINT NULL,
    FOREIGN KEY (street_id) REFERENCES streets(id),
    CONSTRAINT uq_street_id_building_number UNIQUE (street_id, number),
    INDEX idx_building_type (type)
);

