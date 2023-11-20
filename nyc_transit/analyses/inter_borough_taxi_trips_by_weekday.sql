.echo on

with total_trips as (

-- By weekday, count of total trips
SELECT weekday(t.pickup_datetime) as weekday, count(*) as count_total_trips
FROM {{ ref('mart__fact_all_taxi_trips') }} t
GROUP BY weekday

)

, different_boroughs as (

-- By weekday, count trips starting and ending in a different borough
SELECT weekday(tpu.pickup_datetime) as weekday, COUNT(*) as total_trips_diff_borough 
FROM {{ ref('mart__fact_all_taxi_trips') }} tpu
-- Join taxi zones to pickup locations to get pickup boroughs
JOIN {{ ref('taxi+_zone_lookup') }} tz_tpu ON tpu.PUlocationID = tz_tpu.LocationID
-- Join taxi zones to dropoff locations to get dropoff boroughs
JOIN {{ ref('taxi+_zone_lookup') }} tz_tdo ON tpu.DOlocationID = tz_tdo.LocationID
WHERE tz_tpu.Borough != tz_tdo.Borough
GROUP BY weekday

)

-- By weekday, count of total trips, count trips starting and ending in a different borough, and percentage (that weekday)
-- with different start/end boroughs
SELECT tt.weekday as weekday, tt.count_total_trips as count_total_trips, db.total_trips_diff_borough as total_trips_diff_borough, (db.total_trips_diff_borough / tt.count_total_trips) * 100 as percent_diff_start_end_borough
FROM total_trips tt
JOIN different_boroughs db ON tt.weekday = db.weekday
