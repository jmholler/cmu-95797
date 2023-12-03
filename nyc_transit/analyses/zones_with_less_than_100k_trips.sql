.echo on

SELECT loc.Zone as Zone, COUNT(*) as Trips
FROM {{ ref('mart__fact_all_taxi_trips') }} taxi
JOIN {{ ref('mart__dim_locations') }} loc ON taxi.PUlocationID = loc.LocationID
GROUP BY all
HAVING Trips < 100000
ORDER BY 1
