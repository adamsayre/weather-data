{{ config(
    materialized='table'
) }}

WITH date_range AS (
    SELECT explode(sequence(to_date('2020-01-01'), to_date('2030-12-31'), interval 1 day)) as full_date
)

SELECT 
    cast(date_format(full_date, 'yyyyMMdd') as INT) as date_key,
    full_date,
    year(full_date) as year,
    month(full_date) as month,
    date_format(full_date, 'MMMM') as month_name,
    dayofweek(full_date) as day_of_week,
    date_format(full_date, 'EEEE') as day_name,
    case when dayofweek(full_date) in (1, 7) then true else false end as is_weekend,
    quarter(full_date) as quarter,
    CASE 
        WHEN month(full_date) in (12, 1, 2) THEN 'Winter'
        WHEN month(full_date) in (3, 4, 5) THEN 'Spring'
        WHEN month(full_date) in (6, 7, 8) THEN 'Summer'
        ELSE 'Autumn' 
    END as season
FROM date_range