.echo on

SELECT
   date,
   AVG(prcp) OVER (ORDER BY date ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) as seven_day_moving_avg_prcp
FROM {{ ref('stg__central_park_weather') }}
