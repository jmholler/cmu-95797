.echo on

with zone_diff as (
SELECT
   loc.Zone,
   taxi.pickup_datetime,
   -- Use lead or lag to find the next trip per zone for each record
   LEAD(taxi.pickup_datetime) OVER (PARTITION BY loc.Zone ORDER BY taxi.pickup_datetime ASC) AS next_zone_pickup,
   -- Then find the time difference between the pick up time for the current record
   DATEDIFF('minute', taxi.pickup_datetime, next_zone_pickup) as time_diff
FROM {{ ref('mart__fact_all_taxi_trips') }} taxi
JOIN {{ ref('mart__dim_locations') }} loc ON taxi.PUlocationID = loc.LocationID
)
-- Then use this result to calculate the average time between pick ups per zone
SELECT
   Zone,
   AVG(time_diff) as avg_time_btw_pickup
FROM zone_diff
GROUP BY 1
ORDER BY 1
