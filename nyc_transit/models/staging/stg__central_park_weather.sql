with source as (

	select * from {{ source('main', 'central_park_weather') }}

),

renamed as (

	select
	   station
	  ,name as station_name
	  ,try_cast(date as date) as date
	  ,try_cast(awnd as double) as avg_wind_speed
	  ,try_cast(prcp as double) as precip
	  ,try_cast(snow as double) as snowfall
	  ,try_cast(snwd as double) as snow_depth
	  ,try_cast(tmax as bigint) as max_temp
	  ,try_cast(tmin as bigint) as min_temp
	   -- Getting only the filename and not path
	  ,substring(filename, 8) as filename

	from source

)

select * from renamed
