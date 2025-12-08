{{ config(
    materialized='incremental',
    unique_key='location_key'
) }}

WITH source_data AS (
    SELECT DISTINCT 
        city, 
        latitude, 
        longitude
    FROM {{ source('silver', 'openmeteo_hourly_historical') }}
    WHERE city IS NOT NULL
)

SELECT
    -- Generate a deterministic hash based on the business key (City)
    -- 'London' always gets the same ID, even on full refresh
    md5(city) as location_key, 
    city,
    latitude,
    longitude
FROM source_data

{% if is_incremental() %}
  -- Prevent duplicates if the city already exists
  WHERE md5(city) NOT IN (SELECT location_key FROM {{ this }})
{% endif %}