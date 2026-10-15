INSERT INTO road_segment_types (id, name)
VALUES
    (1, 'road'),
    (2, 'bridge');

--for distance_between_points_with_bridges_improved.png
INSERT INTO `cross` (id, name, location)
VALUES
    (1,  'A', ST_SRID(POINT(33.1750, 49.0120), 4326)),
    (2,  'B', ST_SRID(POINT(33.1885, 49.0255), 4326)),
    (3,  'C', ST_SRID(POINT(33.1710, 49.0285), 4326)),
    (4,  'D', ST_SRID(POINT(33.2085, 49.0255), 4326)),
    (5,  'E', ST_SRID(POINT(33.2250, 49.0390), 4326)),
    (6,  'F', ST_SRID(POINT(33.2120, 49.0055), 4326)),
    (7,  'G', ST_SRID(POINT(33.1650, 48.9870), 4326)),
    (8,  'H', ST_SRID(POINT(33.1970, 48.9960), 4326)),
    (9,  'I', ST_SRID(POINT(33.1835, 48.9925), 4326)),
    (10, 'J', ST_SRID(POINT(33.2320, 49.0040), 4326));

INSERT INTO road_segments (id, cross_1, cross_2, type_id)
VALUES
    (1,  2, 3, 1), -- B-C
    (2,  2, 4, 1), -- B-D
    (3,  4, 5, 1), -- D-E
    (4,  4, 6, 1), -- D-F
    (5,  6, 10, 1), -- F-J
    (6,  6, 8, 1), -- F-H
    (7,  8, 9, 2), -- H-I (bridge)
    (8,  9, 7, 1), -- I-G
    (9,  7, 1, 1), -- G-A
    (10, 1, 2, 2), -- A-B (bridge)
    (11, 2, 6, 1); -- B-F

UPDATE road_segments rs
JOIN `cross` c1 ON c1.id = rs.cross_1
JOIN `cross` c2 ON c2.id = rs.cross_2
SET rs.distance_m = ST_Distance_Sphere(c1.location, c2.location);