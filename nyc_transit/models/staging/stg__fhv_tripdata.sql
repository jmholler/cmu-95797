with source as (

	select * from {{ source('main', 'fhv_tripdata') }}

),

renamed as (

	select
	   -- removing excess white space in dispatching_base_num
	   RTRIM(dispatching_base_num) as dispatch_base_num
	  ,pickup_datetime
	  ,dropoff_datetime
	  ,pulocationid as pickup_location_id
	  ,dolocationid as dropoff_location_id
	  --removed SR_Flag as 100% NULL

	  -- affiliated_base_number is expected to be B0 followed by four numbers.  There are also some
	  -- issues with lower case and trim as well as duplicates (ex: 'B01234     B01234')
	  -- so I converted affiliated_base_number to UPPER_CASE, trimmed from RIGHT.
	  -- Then, in case statement I took only those values that match the pattern 'B0' followed by four numbers.
	  -- This was the best way I could think of that didn't involve getting too much into REGEX.

	  ,(CASE
		WHEN UPPER(RTRIM(SUBSTRING(affiliated_base_number, -6))) NOT LIKE 'B0____' THEN NULL 
		ELSE UPPER(RTRIM(SUBSTRING(affiliated_base_number, -6)))
	   END) as aff_base_number

	   -- Getting only the filename and not path
	  ,substring(filename,13) as filename


	from source

	-- DROPOFF_DATETIME has some dates well into the future, like 2031, so excluding future dates
	-- Needed to CAST to timestamp to convert the string to a TIMESTAMP

	where dropoff_datetime < try_cast('2023-01-01 00:00:00' as TIMESTAMP)

)

select * from renamed
