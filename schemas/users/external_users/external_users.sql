CREATE TABLE IF NOT EXISTS external_user_statuses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_ext_user_status_name UNIQUE (name)
);

INSERT IGNORE INTO
    external_user_statuses (id, name)
VALUES (1, 'Активний'),
    (2, 'Тимчасово заблокований'),
    (3, 'Заблокований'),
    (4, 'Видалений'),
    (5, 'Автоматично заблокований'),
    (6, 'Очікує підтвердження');

CREATE TABLE IF NOT EXISTS external_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birth_date DATE NULL,
    status_id INT NOT NULL DEFAULT 6, -- 6 - awaiting approval
    avatar_file_path VARCHAR(255) NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    last_login_at DATETIME NULL,
    INDEX idx_extl_user_phone (phone), -- Phone must be unique for all non-deleted and non-auto-blocked external users.
    CONSTRAINT uq_extl_user_email UNIQUE (email),
    CONSTRAINT uq_extl_user_login UNIQUE (login),
    INDEX idx_extl_user_last_name_first_name (last_name, first_name),
    CONSTRAINT fk_extl_user_status FOREIGN KEY (status_id) REFERENCES external_user_statuses (id)
);

INSERT IGNORE INTO
    passenger_statuses (id, name)
VALUES (
        (1, 'Активний'),
        (2, 'Тимчасово заблокований'),
        (3, 'Заблокований'),
        (4, 'Видалений'),
        (5, 'Авоматично Заблокований')
        -- (6, 'Очікує підтвердження'),
    );

CREATE TABLE IF NOT EXISTS payment_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_payment_type_name UNIQUE (name)
);

INSERT IGNORE INTO
    payment_types (id, name)
VALUES (1, 'Готівка'),
    (2, 'Банківська картка');

CREATE TABLE IF NOT EXISTS passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    preferred_payment_type_id INT DEFAULT 1 NOT NULL,
    status_id INT NOT NULL DEFAULT 1, -- 1 - awaiting approval
    avatar_file_path VARCHAR(255) NULL,
    description VARCHAR(725) NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    last_visit_at DATETIME NULL,
    average_rating DECIMAL(3, 2) NULL,
    rating_count INT NOT NULL DEFAULT 0,
    CONSTRAINT uq_passenger_user UNIQUE (user_id),
    CONSTRAINT fk_passenger_user FOREIGN KEY (user_id) REFERENCES external_users (id),
    CONSTRAINT fk_passenger_status FOREIGN KEY (status_id) REFERENCES passenger_statuses (id),
    CONSTRAINT fk_payment_type_passenger FOREIGN KEY (preferred_payment_type_id) REFERENCES payment_types (id)
);

INSERT IGNORE INTO
    driver_statuses (id, name)
VALUES (1, 'Активний'),
    (2, 'Тимчасово заблокований'),
    (3, 'Заблокований'),
    (4, 'Видалений'),
    (5, 'Автоматично заблокований'),
    (6, 'Очікує підтвердження');

CREATE TABLE IF NOT EXISTS drivers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    status_id INT NOT NULL DEFAULT 6, -- default - awaiting approval
    avatar_file_path VARCHAR(255) NULL,
    description VARCHAR(725) NULL,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    approved_at DATETIME NULL,
    updated_at DATETIME NULL,
    last_visit_at DATETIME NULL,
    average_rating DECIMAL(3, 2) NULL,
    rating_count INT NOT NULL DEFAULT 0,
    -- (@TODO another fields, maybe :) )
    CONSTRAINT uq_driver_user UNIQUE (user_id),
    CONSTRAINT fk_driver_user FOREIGN KEY (user_id) REFERENCES external_users (id),
    CONSTRAINT fk_driver_status FOREIGN KEY (status_id) REFERENCES driver_statuses (id)
);

-- @TODO some ideas:
-- passenger-pets
-- passenger-childs
-- passenger-discount
-- passenger-important-places

-- ext_user_settings-types ?
--- external_user_setting