/* Partition Sensor for input table
Looks for a table under `table` in unity catalog for a partition_column matching the input partition_value
Inputs:
- table_name: str unity catalog full table name e.g. catalog.schema.table
- partition_column: str, name of column that table_name is partitioned by
- partition_value: str, value being searched for in partition_column
*/
with parts as (
  select distinct identifier(:partition_column)
  from identifier(:table_name)
)

select assert_true(count(*) = 1, "Partition not present") as null_if_partition_present
from parts
where identifier(:partition_column) = :partition_value
