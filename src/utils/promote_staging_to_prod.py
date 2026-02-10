# promote_staging_to_prod.py

import logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

if __name__ == "__main":
    import sys
    import argparse
    logger.info(f"Starting Partition Copy Job")

    parser = argparse.ArgumentParser(description="Copy a specific partition from source to target.")
    parser.add_argument("--source_table", required=True, help="Source database.table, in catalog.schema.table format")
    parser.add_argument("--target_table", required=True, help="Target database.table, in catalog.schema.table format")
    parser.add_argument("--partition_col", required=True, help="Name of the partition column")
    parser.add_argument("--partition_val", required=True, help="Value of the partition column")
    args = parser.parse_args()

    logger.info(f"Source: {args.source_table}")
    logger.info(f"Target: {args.target_table}")
    logger.info(f"Partition: {args.partition_col} = {args.partition_val}")

    d = spark.sql(
        f"""
        INSERT OVERWRITE TABLE {args.target_table}
        PARTITION ({args.partition_col} = {args.partition_val})
        SELECT * except({args.partition_col})
        FROM {args.source_table}
        """
    )
    logger.info(f"Output: {d}")
    logger.info("Done with job :) have a nice day")
