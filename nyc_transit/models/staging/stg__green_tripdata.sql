with source as (

	select * from {{ source('main', 'green_tripdata') }}

),

renamed as (

	select
	  vendorid
	  ,lpep_pickup_datetime as meter_start_datetime
	  ,lpep_dropoff_datetime as meter_end_datetime
	  ,store_and_fwd_flag as trip_store_flag
	   -- Changing to NULL ratecodeid value of '98.999999999999999996' as does not seem to be valid ratecodeid
	  ,(CASE
	       WHEN try_cast(ratecodeid as bigint) > 5 THEN NULL
	       ELSE try_cast(ratecodeid as bigint)
	   END) as ratecodeid
	  ,pulocationid as pickup_location_id
	  ,dolocationid as dropoff_location_id
	  ,try_cast(passenger_count as bigint) as passenger_count
	  ,trip_distance
	  ,fare_amount
	  ,extra
	  ,mta_tax
	  ,tip_amount
	  ,tolls_amount
	  -- removed ehail_fee as 100% are NULL
	  ,improvement_surcharge
	  ,total_amount
	  ,try_cast(payment_type as bigint) as payment_type
	  ,try_cast(trip_type as bigint) as trip_type
	  ,congestion_surcharge
	   -- Getting only the filename and not path
	  ,substring(filename, 13) as filename



	from source

	where
	lpep_pickup_datetime < try_cast('2023-01-01 00:00:00' as TIMESTAMP)
	OR lpep_dropoff_datetime < try_cast('2023-01-01 00:00:00' as TIMESTAMP)
	OR trip_distance >= 0

)

select * from renamed
