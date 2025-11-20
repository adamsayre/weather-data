# weather-data portfolio project

by Adam Kleiman, created 2025-11-20

## Architecture

This weather reporting and prediction data product follows the databricks "medallion" architecture:
* Bronze: ingest raw data from source, no transformation if applicable, land data in SCD type 1 tables
* Silver: use a "write, audit, publish" methodology, apply business logic and check data for issues before promoting data into a SCD type 2 table
* Gold: a kimball dimensional model

Finally, ML models can consume the gold layer data ensuring only clean and understood data makes it into the model.

## Products

1. Dashboard reporting the gold-layer data
2. ML forecasts of temperature for each city.