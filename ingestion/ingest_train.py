import pandas as pd
from sqlalchemy import create_engine

from config import DB_URL, DATA_PATH, CHUNK_SIZE, INGEST_MODE, VALIDATION_CHUNKS
from logger import get_logger
from schemas import TRAIN_SCHEMA, validate_schema
from copy_utils import copy_csv_to_table

logger = get_logger("ingest_train")
engine = create_engine(DB_URL)

FILE_NAME = "train_v2.csv"
TABLE_NAME = "train"
SCHEMA_NAME = "raw"


def validate_mode():
    file_path = f"{DATA_PATH}/{FILE_NAME}"
    logger.info("VALIDATE mode: raw.train")

    for i, chunk in enumerate(pd.read_csv(file_path, chunksize=CHUNK_SIZE)):
        validate_schema(chunk, TRAIN_SCHEMA, "raw.train")

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
    logger.info("COPY mode: raw.train")
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
