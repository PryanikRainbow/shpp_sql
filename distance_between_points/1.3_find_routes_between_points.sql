-- in memory - config - TODO;
-- for distance_between_points_with_bridges_improved.png;
-- cross_1, cross_2 - points of cross_segment

SET @start_cross_id = 4; -- D
SET @finish_cross_id = 7; -- G

SET @bridge_1_id = 7;  -- H-I
SET @bridge_2_id = 10; -- A-B

SET @straight_distance_m = (
    SELECT ST_Distance_Sphere(c1.location, c2.location)
    FROM `cross` c1
    JOIN `cross` c2 ON c2.id = @finish_cross_id
    WHERE c1.id = @start_cross_id
);

SET @max_distance_m = 3 * @straight_distance_m;

-- r - routes; rs - route segments
-- r - routes; rs - route segments
WITH RECURSIVE routes AS (
    SELECT
        @start_cross_id AS current_cross,
        CAST(
            CONCAT(',', @start_cross_id, ',') AS CHAR(100)
        ) AS visited_crosses,
        CAST(0 AS DOUBLE) AS distance_m,
        0 AS has_bridge,
        0 AS steps

    UNION ALL

    SELECT
        -- Determine the next cross of the road segment.
        CASE
            WHEN rs.cross_1 = r.current_cross THEN rs.cross_2
            ELSE rs.cross_1
        END AS current_cross,
        CONCAT(
            r.visited_crosses,
            CASE
                WHEN rs.cross_1 = r.current_cross THEN rs.cross_2
                ELSE rs.cross_1
            END,
            ','
        ) AS visited_crosses,
        r.distance_m + rs.distance_m AS distance_m,
        (r.has_bridge = 1 OR rs.id IN (@bridge_1_id, @bridge_2_id)) AS has_bridge,
        r.steps + 1
    FROM routes r
    JOIN road_segments rs
        ON r.current_cross IN (rs.cross_1, rs.cross_2)
    WHERE
        (r.current_cross <> @finish_cross_id)
        -- To prevent returning to a visited point (cross)
        AND LOCATE(
            CONCAT(
                ',',
                CASE
                    WHEN rs.cross_1 = r.current_cross THEN rs.cross_2
                    ELSE rs.cross_1
                END,
                ','
            ),
            r.visited_crosses
        ) = 0
        AND (
            r.distance_m + rs.distance_m < @max_distance_m
        )

        -- Prevent crossing more than one specified bridge.
        AND NOT (
            r.has_bridge = 1
            AND rs.id IN (@bridge_1_id, @bridge_2_id)
        )
)

SELECT
    TRIM(',' FROM visited_crosses) AS route,
    ROUND(distance_m, 2) AS distance_m,
    steps
FROM routes
WHERE
    current_cross = @finish_cross_id
    AND has_bridge = 1
ORDER BY distance_m ASC
-- LIMIT 1
;

-- SELECT
--     current_cross,
--     visited_crosses,
--     ROUND(distance_m, 2) AS distance_m,
--     has_bridge,
--     steps
-- FROM routes
-- ORDER BY steps;

-- SELECT *
-- FROM routes
-- ORDER BY steps;

-- SELECT *
-- FROM routes
-- WHERE current_cross = @finish_cross_id;