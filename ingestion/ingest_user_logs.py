import pandas as pd
from sqlalchemy import create_engine

from config import DB_URL, DATA_PATH, CHUNK_SIZE, INGEST_MODE, VALIDATION_CHUNKS
from logger import get_logger
from schemas import USER_LOGS_SCHEMA, validate_schema
from copy_utils import copy_csv_to_table

logger = get_logger("ingest_user_logs")
engine = create_engine(DB_URL)

FILE_NAME = "user_logs_v2.csv"
TABLE_NAME = "user_logs"
SCHEMA_NAME = "raw"


def validate_mode():
    file_path = f"{DATA_PATH}/{FILE_NAME}"
    logger.info("VALIDATE mode: raw.user_logs")

    for i, chunk in enumerate(pd.read_csv(file_path, chunksize=CHUNK_SIZE)):
        validate_schema(chunk, USER_LOGS_SCHEMA, "raw.user_logs")

        chunk_memory_mb = chunk.memory_usage(deep=True).sum() / (1024 ** 2)
        logger.info(f"Chunk {i} memory: {chunk_memory_mb:.2f} MB")

        chunk.to_sql(
            name=TABLE_NAME,
            schema=SCHEMA_NAME,
            con=engine,
            if_exists="append",
            index=False,
            method="multi",
        )

        if i + 1 >= VALIDATION_CHUNKS:
            logger.info("Validation phase complete. Stopping early.")
            break


def copy_mode():
    logger.info("COPY mode: raw.user_logs")
    copy_csv_to_table(
        file_path=f"{DATA_PATH}/{FILE_NAME}",
        schema=SCHEMA_NAME,
        table=TABLE_NAME,
    )


if __name__ == "__main__":
    if INGEST_MODE == "validate":
        validate_mode()
    elif INGEST_MODE == "copy":
        copy_mode()
    else:
        raise ValueError("Invalid INGEST_MODE")
