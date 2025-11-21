# promote_staging_to_prod.py

# TODO: prints not pushed up to databricks, probably have to start a logger

if __name__ == "__main":
    import sys
    import argparse

    parser = argparse.ArgumentParser(description="Copy a specific partition from source to target.")
    parser.add_argument("--source_table", required=True, help="Source database.table, in catalog.schema.table format")
    parser.add_argument("--target_table", required=True, help="Target database.table, in catalog.schema.table format")
    parser.add_argument("--partition_col", required=True, help="Name of the partition column")
    parser.add_argument("--partition_val", required=True, help="Value of the partition column")
    args = parser.parse_args()

    print(f"Starting Partition Copy Job")
    print(f"Source: {args.source_table}")
    print(f"Target: {args.target_table}")
    print(f"Partition: {args.partition_col} = {args.partition_val}")

    d = spark.sql(
        f"""
        INSERT OVERWRITE TABLE {args.destination_table}
        PARTITION ({args.partition_col})
        SELECT * FROM {args.source_table}
        where partition_col = {args.partition_val})
        """
    )
    print("Done with job :) have a nice day")
