import psycopg2 #PostgreSQL adapter
from config import DB_URL

def copy_csv_to_table(file_path:str, schema:str, table:str) -> None:
    conn = psycopg2.connect(DB_URL)
    cur = conn.cursor()
    
    with open(file_path, "r", encoding="utf-8") as f:
        next(f) #skip header
        cur.copy_expert(
            f"""
            COPY {schema}.{table}
            FROM STDIN
            WITH (FORMAT CSV)
            """,
            f,
        )
    conn.commit()
    cur.close()
    conn.close()