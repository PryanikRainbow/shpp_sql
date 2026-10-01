CREATE TABLE IF NOT EXISTS countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    iso_code CHAR(3) NOT NULL, -- UA, US, etc
    phone_code VARCHAR(3) NOT NULL, -- 380, etc
    CONSTRAINT uq_country_name UNIQUE (name),
    CONSTRAINT uq_country_iso_code UNIQUE (iso_code)
);

CREATE TABLE IF NOT EXISTS regions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries (id),
    UNIQUE (country_id, name)
   );

CREATE TABLE IF NOT EXISTS districts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    region_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    FOREIGN KEY (region_id) REFERENCES regions (id),
    UNIQUE (region_id, name)
);

CREATE TABLE IF NOT EXISTS settlements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    district_id INT,
    region_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    is_region_center TINYINT(1) NOT NULL DEFAULT 0,
    is_district_center TINYINT(1) NOT NULL DEFAULT 0,
    is_capital TINYINT(1) NOT NULL DEFAULT 0,
    FOREIGN KEY (district_id) REFERENCES districts (id),
    FOREIGN KEY (region_id) REFERENCES regions (id),
    INDEX idx_settlement_name (name),
    UNIQUE (district_id, name)
);

CREATE TABLE IF NOT EXISTS streets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    settlement_id INT NOT NULL,

    FOREIGN KEY (settlement_id) REFERENCES settlements (id),
    UNIQUE (settlement_id, name)
);

CREATE TABLE IF NOT EXISTS building_type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    CONSTRAINT uq_building_type_name UNIQUE (name)
    -- 'private_house', 'apartment_building' TODO seeder
);

CREATE TABLE IF NOT EXISTS buildings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    street_id INT NOT NULL,
    building_type_id INT NOT NULL,
    number VARCHAR(100) NOT NULL,
    entrances_quantity TINYINT NULL,
    latitude DECIMAL(8, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL,
    -- location POINT NOT NULL SRID 4326,
    -- Spatial Reference System Identifier
    -- Preferred MySQL approach

    FOREIGN KEY (street_id) REFERENCES streets (id),
    FOREIGN KEY (building_type_id) REFERENCES building_type (id),
    CONSTRAINT uq_street_id_building_number UNIQUE (street_id, number),
    INDEX idx_building_coordinates (latitude, longitude)
    -- SPATIAL INDEX idx_building_location (location)
    -- Preferred MySQL approach
);