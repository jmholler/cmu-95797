with source as (

	select * from {{ source('main', 'fhv_bases') }}

),

renamed as (

	select
	   base_number
	  ,base_name
	  ,dba as base_dba
	  ,dba_category as base_category
	   -- Getting only the filename and not path
	  ,substring(filename, 8) as filename


	from source

)

select * from renamed
