select
   loc.Borough as Borough
   ,count(*) as Trips
from {{ ref('mart__fact_all_taxi_trips') }} taxi
join {{ ref('mart__dim_locations') }} loc ON taxi.PUlocationID = loc.LocationID
group by loc.Borough
