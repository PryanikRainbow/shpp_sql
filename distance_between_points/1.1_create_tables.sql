CREATE TABLE IF NOT EXISTS `cross` (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(10) NULL UNIQUE,
    location POINT NOT NULL SRID 4326,

    SPATIAL INDEX idx_cross_location (location)
);

CREATE TABLE IF NOT EXISTS road_segment_types (
    id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS road_segments (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cross_1 INT UNSIGNED NOT NULL,
    cross_2 INT UNSIGNED NOT NULL,
    type_id TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1 - road',
    distance_m DOUBLE NULL,

    FOREIGN KEY (cross_1) REFERENCES `cross` (id),
    FOREIGN KEY (cross_2) REFERENCES `cross` (id),
    FOREIGN KEY (type_id) REFERENCES road_segment_types (id),

    CONSTRAINT chk_different_cross CHECK (cross_1 <> cross_2)
);