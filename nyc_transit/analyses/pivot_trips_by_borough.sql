.echo on

PIVOT {{ ref('mart__fact_trips_by_borough') }}
ON Borough
USING MAX(Trips)
