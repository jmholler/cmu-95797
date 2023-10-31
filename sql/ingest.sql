-- create bike_data table with headers and filename column
create table bike_data as select * from
read_csv_auto('./data/citibike-tripdata*.csv.gz', union_by_name=True, filename=True, header=True);

-- create central_park_weather table with headers and filename column
create table central_park_weather as select * from
read_csv_auto('./data/central_park_weather*.csv', union_by_name=True, filename=True, header=True);

-- create fhv_bases table with headers and filename column
create table fhv_bases as select * from
read_csv_auto('./data/fhv_bases*.csv', union_by_name=True, filename=True, header=True);

-- create fhv_tripdata table with filename column
create table fhv_tripdata as select * from
read_parquet('./data/taxi/fhv_tripdata*.parquet', union_by_name=True, filename=True);

-- create fhvhv_tripdata table with filename column
create table fhvhv_tripdata as select * from
read_parquet('./data/taxi/fhvhv_tripdata*.parquet', union_by_name=True, filename=True);

-- create green_tripdata table with filename column
create table green_tripdata as select * from
read_parquet('./data/taxi/green_tripdata*.parquet', union_by_name=True, filename=True);

-- create yellow_tripdata table with filename column
create table yellow_tripdata as select * from
read_parquet('./data/taxi/yellow_tripdata*.parquet', union_by_name=True, filename=True);
