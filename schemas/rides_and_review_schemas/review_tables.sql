-- @TODO polymorhic?)
CREATE TABLE IF NOT EXISTS passenger_account_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ride_id INT NOT NULL,
    rating TINYINT NOT NULL,
    comment VARCHAR(1000) NULL, -- internal (available for driver and internal users)
    requires_support TINYINT(1) NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_passenger_account_review_ride UNIQUE (ride_id),
    CONSTRAINT fk_passenger_account_review_ride FOREIGN KEY (ride_id) REFERENCES rides (id)
);

CREATE TABLE IF NOT EXISTS driver_account_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ride_id INT NOT NULL,
    rating TINYINT NOT NULL,
    comment VARCHAR(1000) NULL, -- internal (available for driver and internal users)
    requires_support TINYINT(1) NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_driver_account_review_ride UNIQUE (ride_id),
    CONSTRAINT fk_passenger_account_review_ride FOREIGN KEY (ride_id) REFERENCES rides (id)
);