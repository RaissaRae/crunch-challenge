-- contracts -- table, creates physical table in databricks

{{ config(
    materialized='table',
    contract={
        "enforced": true
    }
) }}

SELECT 
    -- creating unique id
    CAST(row_number() OVER (ORDER BY tpep_pickup_datetime) AS INT) as trip_id,
    
    -- rename so easier to read
    tpep_pickup_datetime as pickup_datetime,
    tpep_dropoff_datetime as dropoff_datetime,

    -- no negatives in amount col
    CAST(
        CASE 
            WHEN fare_amount < 0 OR fare_amount IS NULL THEN 0 
            ELSE fare_amount 
        END AS DECIMAL(10, 2)
    ) AS fare_amount,

    
    -- Calculate trip duration in minutes
    --TIMESTAMPDIFF(MINUTE, tpep_pickup_datetime, tpep_dropoff_datetime) as trip_duration_in_minutes
    {{ trip_duration('tpep_pickup_datetime', 'tpep_dropoff_datetime') }} as trip_duration_in_minutes


FROM samples.nyctaxi.trips
WHERE 
    -- Filter out bad data
    tpep_pickup_datetime IS NOT NULL 
    AND tpep_dropoff_datetime IS NOT NULL
    AND tpep_pickup_datetime < tpep_dropoff_datetime