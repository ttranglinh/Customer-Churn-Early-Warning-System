"""
Schema contracts for raw CSV ingestion.
These schemas define what we EXPECT to receive from source files,
not what we wish the data looked like.

No business logic here.
No cleaning here.
Only validation.
"""

# ---------------------------
# Helper validation function
# ---------------------------
import pandas as pd
from typing import Dict


def validate_schema(
    df: pd.DataFrame,
    expected_schema: Dict[str, str],
    table_name: str
) -> None:
    """
    Validate that a DataFrame matches the expected schema.

    Parameters
    ----------
    df : pd.DataFrame
        Incoming data chunk
    expected_schema : Dict[str, str]
        Mapping of column_name -> pandas dtype as string
    table_name : str
        Used for clearer error messages

    Raises
    ------
    ValueError
        If columns are missing or unexpected
    TypeError
        If column dtypes do not match expectation
    """

    # 1. Column presence check
    missing_cols = set(expected_schema.keys()) - set(df.columns)
    extra_cols = set(df.columns) - set(expected_schema.keys())

    if missing_cols:
        raise ValueError(
            f"[{table_name}] Missing columns: {missing_cols}"
        )

    if extra_cols:
        raise ValueError(
            f"[{table_name}] Unexpected columns: {extra_cols}"
        )

    # 2. Data type check
    for col, expected_dtype in expected_schema.items():
        actual_dtype = str(df[col].dtype)

        if actual_dtype != expected_dtype:
            raise TypeError(
                f"[{table_name}] Column '{col}' expected dtype "
                f"'{expected_dtype}', got '{actual_dtype}'"
            )


# ---------------------------
# Raw table schemas
# ---------------------------

MEMBERS_SCHEMA = {
    "msno": "object",
    "city": "int64",
    "bd": "int64",
    "gender": "object",
    "registered_via": "int64",
    "registration_init_time": "int64",
}


TRANSACTIONS_SCHEMA = {
    "msno": "object",
    "payment_method_id": "int64",
    "payment_plan_days": "int64",
    "plan_list_price": "int64",
    "actual_amount_paid": "int64",
    "is_auto_renew": "int64",
    "transaction_date": "int64",
    "membership_expire_date": "int64",
    "is_cancel": "int64",
}


USER_LOGS_SCHEMA = {
    "msno": "object",
    "date": "int64",
    "num_25": "int64",
    "num_50": "int64",
    "num_75": "int64",
    "num_985": "int64",
    "num_100": "int64",
    "num_unq": "int64",
    "total_secs": "float64",
}


TRAIN_SCHEMA = {
    "msno": "object",
    "is_churn": "int64",
}