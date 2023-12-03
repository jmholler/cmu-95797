.echo on

SELECT * FROM {{ ref('events') }}
QUALIFY ROW_NUMBER() OVER (PARTITION BY event_id ORDER BY insert_timestamp desc) = 1
