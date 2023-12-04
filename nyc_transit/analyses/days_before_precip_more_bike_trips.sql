.echo on

with trips_day_count as (
-- Get the total bike trips by date
SELECT
DATE_TRUNC('day', started_at_ts) as started_at_date,
count(*) as total_trips
FROM {{ ref('mart__fact_all_bike_trips') }}
GROUP BY 1
),
days_preceding as (
-- Get dates and the snow or prcp field for the following day
SELECT
date,
LEAD(snow) OVER (ORDER BY date) AS lead_snow,
LEAD(prcp) OVER (ORDER BY date) AS lead_prcp,
FROM {{ ref('stg__central_park_weather') }}
),
days_prec_snow_prcp as (
-- Determine the dates immeadiately preceding precipitation or snow
SELECT date
FROM days_preceding
WHERE COALESCE(lead_snow, 0) > 0 or COALESCE(lead_prcp, 0) > 0
),
days_with as (
-- Determine the dates with precipitatoin or snow
SELECT
date
FROM {{ ref('stg__central_park_weather') }}
WHERE prcp > 0 or snow > 0
),
trips_prec  as (
-- Determine the avg total trips on days preceding snow or prcp
SELECT
AVG(cnt.total_trips) as avg_trips_days_prec_snow_prcp
FROM days_prec_snow_prcp prec
JOIN trips_day_count cnt ON prec.date = cnt.started_at_date
),
trips_with as (
-- Determine the avg total trips on days with snow or prcp
SELECT
AVG(cnt.total_trips) as avg_trips_days_with_snow_prcp
FROM days_with w
JOIN trips_day_count cnt ON w.date = cnt.started_at_date
)
-- Final select to show the avg for days with prcp or snow and days preceding prcp or snow
-- ANSWER: The average bike trips are higher on days preceding snow or prcp than days with snow or prcp
SELECT
avg_trips_days_prec_snow_prcp,
avg_trips_days_with_snow_prcp
FROM trips_prec, trips_with
