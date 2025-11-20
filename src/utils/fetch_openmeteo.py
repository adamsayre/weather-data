# fetch_openmeteo.py

import requests


OPEN_METEO_ARCHIVE_URL = "https://api.open-meteo.com/v1/archive"

def fetch_weather_city_date(
    city_name: str,
    lat: float,
    long: float,
    start_date_str: str,
    end_date_str: str,
    hourly_params: list,
):
    """
    Fetch hourly historical weather for a city between start date and end date 

    Params:
    city_name: name of the city
    lat: latitude of the city
    long: longitude of the city
    start_date_str: start date in YYYY-MM-DD format
    end_date_str: end date in YYYY-MM-DD format
    hourly_params: list of variable names to fetch
    """

    params = {
        "latitude": lat,
        "longitude": long,
        "start_date": start_date_str,
        "end_date": end_date_str,
        "hourly": ",".join(hourly_params),
        "timezone": "UTC",
    }

    response = requests.get(OPEN_METEO_ARCHIVE_URL, params=params, timeout=30)
    response.raise_for_status()
    return response.json()