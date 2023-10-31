# Import duckdb package
import duckdb

# Connect to main database
con = duckdb.connect('main.db')

# Create list of table names
tables = ['bike_data','central_park_weather','fhv_bases','fhv_tripdata','fhvhv_tripdata','green_tripdata','yellow_tripdata']

# Loop through the table name list and use fetchall() method to access the row count
# https://duckdb.org/docs/guides/python/execute_sql.html
# Print table name and row count
for i in tables:
   row_count = con.sql(f'''SELECT COUNT(*) as 'row_count' FROM {i};''').fetchall()
   print(f'{i} {row_count[0][0]}')

# Close main.db connection
con.close()
