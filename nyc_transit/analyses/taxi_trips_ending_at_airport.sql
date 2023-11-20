.echo on

SELECT
	-- select service_zone and count trips
	tz.service_zone as "Service Zone", count(*) as "Total Trips Ending"
FROM
	{{ ref('mart__fact_all_taxi_trips') }} tdo
JOIN
	-- Join taxi zones to all taxi trips
	{{ ref('taxi+_zone_lookup') }} tz
ON
	-- Join on LocationID
	tdo.DOlocationID = tz.LocationID
WHERE
	-- Filter out any rows where service_zone not in ('Airports', 'EWR')
	tz.service_zone in ('Airports', 'EWR')
GROUP BY
	-- Group by service_zone
	tz.service_zone
