{{ config(
    materialized='incremental',
    unique_key='source_key'
) }}

WITH distinct_sources AS (
    SELECT DISTINCT api_source 
    FROM {{ source('silver', 'openmeteo_hourly_historical') }}
    WHERE api_source IS NOT NULL
)

SELECT
    md5(api_source) as source_key,
    api_source as api_source_name,
    current_timestamp() as load_date
FROM distinct_sources

{% if is_incremental() %}
  WHERE md5(api_source) NOT IN (SELECT source_key FROM {{ this }})
{% endif %}