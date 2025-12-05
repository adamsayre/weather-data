{{ config(
    materialized='table'
) }}

WITH hour_sequence AS (
    SELECT explode(sequence(0, 23)) as hour_val
)

SELECT 
    hour_val * 100 as time_key,
    hour_val as hour_24,
    hour_val || ":00" as hour_text,
    CASE 
        WHEN hour_val = 0 THEN 12 
        WHEN hour_val <= 12 THEN hour_val 
        ELSE hour_val - 12 
    END as hour_12,
    CASE WHEN hour_val < 12 THEN 'AM' ELSE 'PM' END as am_pm,
    CASE 
        WHEN hour_val BETWEEN 5 AND 11 THEN 'Morning'
        WHEN hour_val BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN hour_val BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night' 
    END as time_of_day_bucket
FROM hour_sequence