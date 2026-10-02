CREATE TABLE IF NOT EXISTS passenger_statuses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_passenger_status_name UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(100) NOT NULL,
    email VARCHAR(255) NULL,
    phone VARCHAR(15) NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    status_id INT NOT NULL,
    avatar_file_path VARCHAR(255) NULL,
    description VARCHAR(725) NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    last_login_at DATETIME NULL,
    CONSTRAINT uq_passenger_phone UNIQUE (phone),
    CONSTRAINT uq_passenger_email UNIQUE (email),
    CONSTRAINT uq_passwnger_login UNIQUE (login),
    INDEX idx_passenger_last_name_first_name (last_name, first_name),
    FOREIGN KEY (status_id) REFERENCES passenger_statuses (id)
    -- ONE of values must br required: email or phone, or both -too (@TODO check)
);

-- @TODO some ideas:
-- passenger-pets
-- passenger-childs
-- passenger-discount