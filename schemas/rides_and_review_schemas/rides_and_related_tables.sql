-- @TODO cuttently - notes

CREATE TABLE IF NOT EXISTS vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    driver_id INT NOT NULL,
    passenger_seats_quantity TINYINT NOT NULL,
    is_primary TINYINT(1) NOT NULL DEFAULT 0, -- Only one active machine is available per user
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    -- (@TODO another fields, maybe :) )
    CONSTRAINT fk_vehicle_driver FOREIGN KEY (driver_id) REFERENCES drivers (id),
    CONSTRAINT fk_vehicle_status FOREIGN KEY (status_id) REFERENCES vehicle_statuses (id)
);

CREATE TABLE IF NOT EXISTS ride_statuses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_ride_status_name UNIQUE (name)
);

INSERT IGNORE INTO
    ride_statuses (id, name)
VALUES (1, 'На розгляді'),
    (2, 'Водія призначено'),
    (3, 'Водій прямує до пасажира'),
    (4, 'Водій прибув'),
    (5, 'Виконується'),
    (6, 'Завершено'),
    (7, 'Скасовано пасажиром'),
    (8, 'Скасовано водієм');

CREATE TABLE IF NOT EXISTS rides (
    id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT NOT NULL,
    driver_id INT NULL,
    vehicle_id INT NULL,
    status_id INT NOT NULL DEFAULT 1,
    payment_type_id INT NOT NULL,
    -- (@TODO another fields, maybe :) )
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    accepted_at DATETIME NULL,
    started_at DATETIME NULL,
    completed_at DATETIME NULL,
    cancelled_at DATETIME NULL,
    -- (@TODO another fields, maybe :) )
    -- price ? price with tips?) Maybe :)  
    CONSTRAINT fk_ride_passenger FOREIGN KEY (passenger_id) REFERENCES passengers (id),
    CONSTRAINT fk_ride_driver FOREIGN KEY (driver_id) REFERENCES drivers (id),
    CONSTRAINT fk_ride_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles (id),
    CONSTRAINT fk_ride_status FOREIGN KEY (status_id) REFERENCES ride_statuses (id),
    CONSTRAINT fk_ride_payment_type FOREIGN KEY (payment_type_id) REFERENCES payment_types (id),
    INDEX idx_ride_passenger_created_at (passenger_id, created_at),
    -- @TODO ask a question: (user id (client or driver) + accepted_at )
    -- accepted_at - a separate index or a combined one?
);