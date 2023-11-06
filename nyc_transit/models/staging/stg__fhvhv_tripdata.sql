with source as (

	select * from {{ source('main', 'fhvhv_tripdata') }}

),

renamed as (

	select
	  hvfhs_license_num
	  ,dispatching_base_num as dispatch_base_num
	  ,originating_base_num
	  ,request_datetime as pickup_request_datetime
	  ,on_scene_datetime as driver_on_scene_datetime
	  ,pickup_datetime
	  ,dropoff_datetime
	  ,pulocationid as pickup_location_id
	  ,dolocationid as dropoff_location_id
	  ,trip_miles
	  ,trip_time
	  ,base_passenger_fare
	  ,tolls
	  ,bcf
	  ,sales_tax
	  ,congestion_surcharge
	  ,airport_fee
	  ,tips
	  ,driver_pay
	  ,shared_request_flag as shared_ride_request_flag
	  ,shared_match_flag as shared_ride_match_flag
	   -- The only non-NULL distinct values for access_a_ride_flag were 'N' and ' ' so I have converted ' ' to 'Y'
	  ,(CASE
	        WHEN access_a_ride_flag = ' ' THEN 'Y'
		ELSE access_a_ride_flag
	   END) as mta_access_ride_flag
	  ,wav_request_flag
	  ,wav_match_flag
	   -- Getting only the filename and not path
	  ,substring(filename, 13) as filename


	from source

)

select * from renamed
