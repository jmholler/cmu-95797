.echo on

SELECT loc.Borough as Borough, loc.Zone as Zone, AVG(taxi.duration_min) as Avg_Duration
FROM {{ ref('mart__fact_all_taxi_trips') }} taxi
JOIN {{ ref('mart__dim_locations') }} loc ON taxi.PUlocationID = loc.LocationID
GROUP BY all
ORDER BY 1, 2
