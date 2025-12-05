# weather-data portfolio project

by Adam Kleiman, created 2025-11-20

## Architecture

This weather reporting and prediction data pipeline follows the databricks **medallion architecture**. It uses a **write, audit, publish pattern** and is designed to be **idempotent** and act only on a **single partition**.

The **medallion architecture** denotes ascending levels of data quality and reliability:
* Bronze: 
    * Ingests raw data from source with no transformations. 
    * Data typically in SCD (slowly-changing dimension) type 1 tables, partitioned by observation date
    * Uses a Databricks/ipython notebook and databricks job scheduling to run
* Silver
    * Uses a "write, audit, publish" pattern (see below)
    * Also uses Databricks/ipython notebooks with databricks job scheduling
    * Applies business logic and check data for issues before promoting partitions into a production table
* Gold
    * A Kimball-style dimensional model - the fact is the hourly weather observation for a given city in this example.
    * Uses dbt to transform, govern, and materialize the model
    * Dashboards and ML models can consume the gold layer data ensuring only clean and conformed data makes it to stakeholders or downstream use cases.

The **write, audit, publish pattern**:
* The transformations write new data to a “staging” location
* Runs self-audit before promoting data to a higher environment. If the audit fails, stop the pipeline so debugging can proceed
* If audits pass, publish the partition to the “production” location

All pipelines act on a **single partition**, never the entire table.

**Idempotency** means each job should produce the same partition if run at a future date. 


## Outputs

1. Dashboard reporting the gold-layer data
2. (in progress) ML forecasts of temperature for each city.

## Kimball Model

Fact: fact_weather_observation
* Dim: dim_date
* Dim: dim_time
* Dim: dim_location
* Dim: dim_source

All dim tables are SCD type 1 tables. I don't see dates, times, locations, or others needing to change more frequently. If I add something else like "weather type" that may evolve over time I'll introduce a SCD type 2 table to the mix.

