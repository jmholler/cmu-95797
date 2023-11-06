with source as (

	select * from {{ source('main', 'yellow_tripdata') }}

),

renamed as (

	select
	  vendorid
	  ,tpep_pickup_datetime as meter_start_datetime
	  ,tpep_dropoff_datetime as meter_end_datetime
	   -- Changing to NULL passenger_count value of 112
	  ,(CASE
	        WHEN try_cast(passenger_count as bigint) > 10 THEN NULL
		ELSE try_cast(passenger_count as bigint)
	   END) as passenger_count
	  ,trip_distance
	   -- Changing to NULL ratecodeid value of '98.999999999999999996' as does not seem to be valid ratecodeid
	  ,(CASE
	       WHEN try_cast(ratecodeid as bigint) > 5 THEN NULL
	       ELSE try_cast(ratecodeid as bigint)
	   END) as ratecodeid
	  ,store_and_fwd_flag as trip_store_flag
	  ,pulocationid as pickup_location_id
	  ,dolocationid as dropoff_location_id
	  ,payment_type
	  ,fare_amount
	  ,extra
	  ,mta_tax
	  ,tip_amount
	  ,tolls_amount
	  ,improvement_surcharge
	  ,total_amount
	  ,congestion_surcharge
	  ,airport_fee
	   -- Getting only the filename and not path
	  ,substring(filename, 13) as filename

	from source

	where
	trip_distance >= 0
)

select * from renamed
