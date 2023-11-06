with source as (

	select * from {{ source('main', 'bike_data') }}

),

renamed as (

	select
	  try_cast(tripduration as bigint) as trip_duration
	  -- USING COALESCE as there are two different naming convetions for similar columns so bringing them together into one column
	  ,COALESCE(try_cast(starttime as timestamp), try_cast(started_at as timestamp)) as trip_start_time
	  ,COALESCE(try_cast(stoptime as timestamp), try_cast(ended_at as timestamp)) as trip_end_time
	  ,COALESCE(try_cast("start station id" as bigint), try_cast(start_station_id as double)) as start_station_id
	  ,COALESCE("start station name", start_station_name) as start_station_name
	  ,COALESCE(try_cast("start station latitude" as double), try_cast(start_lat as double)) as start_station_latitude
	  ,COALESCE(try_cast("start station longitude" as double), try_cast(start_lng as double)) as start_station_longitude
	  ,COALESCE(try_cast("end station id" as bigint), try_cast(end_station_id as double)) as end_station_id
	  ,COALESCE("end station name", end_station_name) as end_station_name
	  ,COALESCE(try_cast("end station latitude" as double), try_cast(end_lat as double)) as end_station_latitude
	  ,COALESCE(try_cast("end station longitude" as double), try_cast(end_lng as double)) as end_station_longitude
	  ,try_cast(bikeid as bigint)
	  ,usertype
	  ,try_cast("birth year" as bigint) as birth_year
	  ,try_cast(gender as bigint) as gender
	  ,ride_id
	  ,rideable_type
	  ,member_casual
	   -- Getting only the filename and not path
	  ,substring(filename, 8) as filename


	from source

)

select * from renamed
