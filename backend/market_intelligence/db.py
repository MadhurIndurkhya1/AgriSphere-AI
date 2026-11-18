"""MySQL connection helper for Member 5. Uses the project's existing .env convention."""
import os
import mysql.connector
from dotenv import load_dotenv

load_dotenv()

def get_db_connection():
    required = ("DB_HOST", "DB_USER", "DB_NAME")
    missing = [key for key in required if not os.getenv(key)]
    if missing:
        raise RuntimeError("Missing database configuration: " + ", ".join(missing))
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD", ""),
        database=os.getenv("DB_NAME"),
        connection_timeout=8,
    )
