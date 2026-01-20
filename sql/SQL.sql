CREATE DATABASE traffic_accidents_india;
USE traffic_accidents_india;

SELECT COUNT(*) AS row_count
FROM accidents_raw;

SELECT * FROM accidents_raw;

SELECT state_ut_city
FROM accidents_raw
WHERE state_ut_city LIKE 'Total%';

SELECT `State/UT/City`
FROM accidents_raw
WHERE `State/UT/City` LIKE 'Total%';

SELECT
    `State/UT/City`                           AS region,
    `Total Traffic Accidents - Cases`         AS total_cases_reported,
    (
        `Road Accidents - Cases`
      + `Railway Accidents - Cases`
      + `Railway Crossing Accidents - Cases`
    )                                         AS sum_of_modes_cases,
    (
        `Total Traffic Accidents - Cases`
      - (
            `Road Accidents - Cases`
          + `Railway Accidents - Cases`
          + `Railway Crossing Accidents - Cases`
        )
    )                                         AS difference
FROM accidents_raw
WHERE `State/UT/City` NOT LIKE 'Total%'
ORDER BY ABS(difference) DESC
LIMIT 15;

SELECT
    `State/UT/City`                           AS region,
    `Total Traffic Accidents - Injured`       AS total_injured_reported,
    (
        `Road Accidents - Injured`
      + `Railway Accidents - Injured`
      + `Railway Crossing Accidents - Injured`
    )                                         AS sum_of_modes_injured,
    (
        `Total Traffic Accidents - Injured`
      - (
            `Road Accidents - Injured`
          + `Railway Accidents - Injured`
          + `Railway Crossing Accidents - Injured`
        )
    )                                         AS difference
FROM accidents_raw
WHERE `State/UT/City` NOT LIKE 'Total%'
ORDER BY ABS(difference) DESC
LIMIT 15;

SELECT
    `State/UT/City`                       AS region,
    `Total Traffic Accidents - Died`      AS total_died_reported,
    (
        `Road Accidents - Died`
      + `Railway Accidents - Died`
      + `Railway Crossing Accidents - Died`
    )                                     AS sum_of_modes_died,
    (
        `Total Traffic Accidents - Died`
      - (
            `Road Accidents - Died`
          + `Railway Accidents - Died`
          + `Railway Crossing Accidents - Died`
        )
    )                                     AS difference
FROM accidents_raw
WHERE `State/UT/City` NOT LIKE 'Total%'
ORDER BY ABS(difference) DESC
LIMIT 15;

CREATE OR REPLACE VIEW accidents_base AS
SELECT
    `State/UT/City`                                 AS region,
    `Total Traffic Accidents - Cases`               AS total_cases,
    `Total Traffic Accidents - Injured`             AS total_injured,
    `Total Traffic Accidents - Died`                AS total_died,

    `Road Accidents - Cases`                        AS road_cases,
    `Road Accidents - Injured`                      AS road_injured,
    `Road Accidents - Died`                         AS road_died,

    `Railway Accidents - Cases`                     AS rail_cases,
    `Railway Accidents - Injured`                   AS rail_injured,
    `Railway Accidents - Died`                      AS rail_died,

    `Railway Crossing Accidents - Cases`            AS crossing_cases,
    `Railway Crossing Accidents - Injured`          AS crossing_injured,
    `Railway Crossing Accidents - Died`             AS crossing_died
FROM accidents_raw
WHERE `State/UT/City` NOT LIKE 'Total%';


CREATE OR REPLACE VIEW accidents_risk_metrics AS
SELECT
    region,
    total_cases,
    total_injured,
    total_died,

    -- Rates
    ROUND(total_died / total_cases, 4)    AS fatality_rate,
    ROUND(total_injured / total_cases, 4) AS injury_rate,

    -- Severity Index
    ROUND(
        (total_died * 2 + total_injured) / total_cases,
        4
    ) AS severity_index,

    -- Mode breakdown (kept for later)
    road_cases,
    rail_cases,
    crossing_cases
FROM accidents_base;

SELECT *
FROM accidents_risk_metrics
ORDER BY severity_index DESC
LIMIT 10;

SELECT
    region,
    severity_index,
    NTILE(3) OVER (ORDER BY severity_index DESC) AS risk_bucket
FROM accidents_risk_metrics;

SELECT
    region,
    severity_index,
    CASE
        WHEN NTILE(3) OVER (ORDER BY severity_index DESC) = 1 THEN 'High Risk'
        WHEN NTILE(3) OVER (ORDER BY severity_index DESC) = 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM accidents_risk_metrics;

CREATE OR REPLACE VIEW accidents_tableau_base AS
SELECT
    region,
    total_cases,
    total_injured,
    total_died,

    fatality_rate,
    injury_rate,
    severity_index,

    CASE
        WHEN NTILE(3) OVER (ORDER BY severity_index DESC) = 1 THEN 'High Risk'
        WHEN NTILE(3) OVER (ORDER BY severity_index DESC) = 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category,

    road_cases,
    rail_cases,
    crossing_cases
FROM accidents_risk_metrics;

SELECT * FROM accidents_tableau_base