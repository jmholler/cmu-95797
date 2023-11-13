with source as (

    select * from {{ source('main', 'fhv_tripdata') }}

),

renamed as (

    select
        trim(upper(dispatching_base_num)) as dispatching_base_num, --from repo: some ids are lowercase -- need to clean up for FK's
        pickup_datetime,
        dropoff_datetime,
        pulocationid,
        dolocationid,
        --sr_flag, always null so chuck it
        trim(upper(affiliated_base_number)) as affiliated_base_number, -- from repo: need to clean up for FK's
        filename

    from source

)

select * from renamed
