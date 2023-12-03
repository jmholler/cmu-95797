.echo on

SELECT
   yel.fare_amount,
   AVG(yel.fare_amount) OVER() as avg_fare,
   AVG(yel.fare_amount) OVER(PARTITION BY loc.Borough) as avg_borough_fare,
   AVG(yel.fare_amount) OVER(PARTITION BY loc.Zone) as avg_zone_fare
FROM {{ ref('stg__yellow_tripdata') }} yel
JOIN {{ ref('mart__dim_locations') }} loc ON yel.PUlocationID = loc.LocationID
-- I am limiting the output for filesize
LIMIT 100000

