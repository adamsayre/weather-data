Select 
    time,
    temperature_2m,
    relativehumidity_2m,
    surface_pressure,
    precipitation,
    windspeed_10m,
    winddirection_10m,
    cloudcover,
    city,
    latitude,
    longitude,
    api_source,
    ingestion_timestamp,
    observation_date,
    temperature_2m_f
from {{ source('silver', 'openmeteo_hourly_historical') }}