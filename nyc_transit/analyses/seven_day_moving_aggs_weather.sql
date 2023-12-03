.echo on

SELECT
date,
MIN(prcp) OVER seven_days AS prcp_min_7_day,
MAX(prcp) OVER seven_days AS prcp_max_7_day,
AVG(prcp) OVER seven_days AS prcp_avg_7_day,
SUM(prcp) OVER seven_days AS prcp_sum_7_day,
MIN(snow) OVER seven_days AS min_snow_7_day,
MAX(snow) OVER seven_days AS max_snow_7_day,
AVG(snow) OVER seven_days AS avg_snow_7_day,
SUM(snow) OVER seven_days AS sum_snow_7_day,
FROM {{ ref('stg__central_park_weather') }}
WINDOW seven_days AS (
	ORDER BY date ASC
	RANGE BETWEEN INTERVAL 3 DAYS PRECEDING AND
		      INTERVAL 3 DAYS FOLLOWING)
