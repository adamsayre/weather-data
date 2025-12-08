{{ config(
    materialized='incremental',
    unique_key='weather_observation_key',
    partition_by=['observation_date'],
    file_format='delta'
) }}

WITH raw_data AS (
    SELECT * FROM {{ source('silver', 'openmeteo_hourly_historical') }}
    
    {% if is_incremental() %}
      WHERE ingestion_timestamp > (SELECT max(ingestion_timestamp) FROM {{ this }})
    {% endif %}
),

final AS (
    SELECT 
        -- a unique ID for the fact row
        md5(concat(cast(r.time as string), r.city, r.api_source)) as weather_observation_key,
        r.observation_date,
        -- foreign keys
        cast(date_format(cast(r.time as TIMESTAMP), 'yyyyMMdd') as INT) as date_key,
        hour(cast(r.time as TIMESTAMP)) * 100 as time_key, 
        -- coalesce with -1 to handle null and still output a non-null id
        md5(coalesce(r.city, "-1")) as location_key,
        md5(coalesce(r.api_source, "-1")) as source_key,
        
        -- Facts
        r.temperature_2m as temperature_celsius,
        r.temperature_2m_f as temperature_fahrenheit,
        r.relativehumidity_2m as relative_humidity_pct,
        r.surface_pressure,
        r.precipitation as precipitation_mm,
        r.windspeed_10m as wind_speed_mps,
        r.winddirection_10m as wind_direction_degrees,
        r.cloudcover as cloud_cover_pct,
        
        -- Metadata
        r.ingestion_timestamp,
        cast(r.time as TIMESTAMP) as original_observation_timestamp

    FROM raw_data r
)

SELECT * FROM final