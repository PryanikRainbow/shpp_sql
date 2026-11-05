-- Дороги недоцільні для цієї задачі.
-- marker_points — точки-маркери на відкритій площі.
-- Завдання: знайти найближчий електросамокат,
-- залишений після ночі :D (ЯК ПРИКЛАД)

DROP TEMPORARY TABLE IF EXISTS marker_points;

CREATE TEMPORARY TABLE marker_points (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    location POINT NOT NULL SRID 4326
);

INSERT INTO marker_points (name, location)
VALUES
    ('A', ST_SRID(POINT(33.1750, 49.0120), 4326)),
    ('B', ST_SRID(POINT(33.1885, 49.0255), 4326)),
    ('C', ST_SRID(POINT(33.1710, 49.0285), 4326)),
    ('D', ST_SRID(POINT(33.2085, 49.0255), 4326)),
    ('E', ST_SRID(POINT(33.2250, 49.0390), 4326)),
    ('F', ST_SRID(POINT(33.2120, 49.0055), 4326)),
    ('G', ST_SRID(POINT(33.1650, 48.9870), 4326)),
    ('H', ST_SRID(POINT(33.1970, 48.9960), 4326)),
    ('I', ST_SRID(POINT(33.1835, 48.9925), 4326)),
    ('J', ST_SRID(POINT(33.2320, 49.0040), 4326));

DROP PROCEDURE IF EXISTS findNearbyPoint;

DELIMITER $$

CREATE PROCEDURE findNearbyPoint(
    IN p_start_point_id INT UNSIGNED,
    IN p_step_radius_m DOUBLE,
    IN p_max_distance_m DOUBLE
)
nearbyPoint: BEGIN
    DECLARE steps INT UNSIGNED DEFAULT 0;
    DECLARE current_radius_m DOUBLE DEFAULT 0;
    DECLARE target_distance DOUBLE DEFAULT NULL;
    DECLARE target_point_id INT UNSIGNED DEFAULT NULL;
    DECLARE target_point_name VARCHAR(50) DEFAULT NULL;
    DECLARE start_location POINT DEFAULT NULL;

    IF (
        p_step_radius_m IS NULL
        OR p_step_radius_m <= 0
        OR p_max_distance_m IS NULL
        OR p_max_distance_m <= 0
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Radius must be greater than zero';
    END IF;

    SELECT m.location
    INTO start_location
    FROM marker_points m
    WHERE m.id = p_start_point_id;

    IF start_location IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Start point not found';
    END IF;

    WHILE (target_point_id IS NULL AND current_radius_m < p_max_distance_m) DO
        SET current_radius_m = current_radius_m + p_step_radius_m;
        IF current_radius_m > p_max_distance_m THEN
            SET current_radius_m = p_max_distance_m;
        END IF;
        SET steps = steps + 1;

        SELECT
            m.id,
            m.name,
            ST_Distance_Sphere(m.location, start_location)
        INTO
            target_point_id,
            target_point_name,
            target_distance
        FROM marker_points m
        WHERE m.id != p_start_point_id
            AND ST_Distance_Sphere(m.location, start_location) <= current_radius_m
        ORDER BY
            ST_Distance_Sphere(m.location, start_location),
            m.id
        LIMIT 1;
    END WHILE;

    SELECT
        target_point_id AS id,
        target_point_name AS name,
        ROUND(target_distance, 2) AS distance_m,
        steps;
END $$

DELIMITER ;

-- CALL findNearbyPoint(1, 500, 5000);