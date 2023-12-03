.echo on

SELECT taxi.*
FROM {{ ref('mart__fact_all_taxi_trips') }} taxi
LEFT JOIN {{ ref('mart__dim_locations') }} loc ON taxi.PUlocationID = loc.LocationID
WHERE loc.LocationID is null
-- I am setting limit here for filesize, etc
LIMIT 10000
