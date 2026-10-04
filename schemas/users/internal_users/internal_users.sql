CREATE TABLE IF NOT EXISTS internal_user_statuses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_internal_user_status_name UNIQUE (name)
);

INSERT IGNORE INTO
    internal_user_statuses (id, name)
VALUES (1, 'Активний'),
    (2, 'Тимчасово заблокований'),
    (3, 'Заблокований'),
    (4, 'Видалений'),
    (5, 'Автоматично заблокований');

CREATE TABLE IF NOT EXISTS operator_statuses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_operator_status_name UNIQUE (name)
);

INSERT IGNORE INTO
    operator_statuses (id, name)
VALUES (1, 'Активний'),
    (2, 'Призупинений'),
    (3, 'Видалений');

CREATE TABLE IF NOT EXISTS admin_statuses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_admin_status_name UNIQUE (name)
);

INSERT IGNORE INTO
    admin_statuses (id, name)
VALUES (1, 'Активний'),
    (2, 'Призупинений'),
    (3, 'Видалений');

CREATE TABLE IF NOT EXISTS internal_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    status_id INT NOT NULL DEFAULT 6,
    avatar_file_path VARCHAR(255) NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    last_login_at DATETIME NULL,
    CONSTRAINT uq_internal_user_login UNIQUE (login),
    CONSTRAINT uq_internal_user_email UNIQUE (email),
    CONSTRAINT uq_internal_user_phone UNIQUE (phone),
    CONSTRAINT fk_internal_user_status FOREIGN KEY (status_id) REFERENCES internal_user_statuses (id),
    INDEX idx_intl_user_last_name_first_name (last_name, first_name)
);

CREATE TABLE IF NOT EXISTS operators (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    CONSTRAINT uq_operator_user UNIQUE (user_id),
    CONSTRAINT fk_operator_user FOREIGN KEY (user_id) REFERENCES internal_users (id)
);

CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    CONSTRAINT uq_admin_user UNIQUE (user_id),
    CONSTRAINT fk_admin_user FOREIGN KEY (user_id) REFERENCES internal_users (id)
);