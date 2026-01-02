import pandas as pd
from sqlalchemy import create_engine

from config import DB_URL, DATA_PATH, CHUNK_SIZE
from logger import get_logger
from schemas import MEMBERS_SCHEMA, validate_schema

logger = get_logger("ingest_members")
engine = create_engine(DB_URL)

FILE_NAME = "members_v3.csv"
TABLE_NAME = "members"
SCHEMA_NAME = "raw"


def main():
    file_path = f"{DATA_PATH}/{FILE_NAME}"
    total_rows = 0

    logger.info("Starting ingestion: raw.members")

    for chunk_idx, chunk in enumerate(
        pd.read_csv(file_path, chunksize=CHUNK_SIZE)
    ):
        if chunk_idx == 0:
            validate_schema(chunk, MEMBERS_SCHEMA, "raw.members")
            logger.info("Schema validation passed")

        rows = len(chunk)

        chunk.to_sql(
            name=TABLE_NAME,
            schema=SCHEMA_NAME,
            con=engine,
            if_exists="append",
            index=False,
            method="multi",
        )

        total_rows += rows
        logger.info(f"Inserted {rows} rows (total: {total_rows})")

    logger.info("Completed ingestion: raw.members")


if __name__ == "__main__":
    main()
