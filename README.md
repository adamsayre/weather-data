# weather-data portfolio project

by Adam Kleiman, created 2025-11-20

## Architecture

This weather reporting and prediction data product follows the databricks "medallion" architecture:
* Bronze: ingest raw data from source, no transformation if applicable, land data in partitions on `bronze` schema
* Silver: use a "write, audit, publish" methodology, apply transformations or business logic, and check data for issues. If audit passes, promote the partition to `silver` schema
* Gold: a kimball dimensional model - tables living in the `gold` schema, use a write, audit, publish to promote changes into the model

Finally, ML models can consume the gold layer data ensuring only clean and understood data makes it into the model.

## Products

1. Dashboard reporting the gold-layer data
2. ML forecasts of temperature for each city.

## Kimball Model

Fact: fact_weather_observation
* Dim: dim_date
* Dim: dim_time
* Dim: dim_location
* Dim: dim_source

All dim tables are SCD type 1 tables. I don't see dates, times, locations, or others needing to change more frequently. If I add something else like "weather type" that may evolve over time I'll introduce a SCD type 2 table to the mix.

