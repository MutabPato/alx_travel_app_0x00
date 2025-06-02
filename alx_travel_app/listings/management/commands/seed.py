import os
import functools
import mysql.connector
from dotenv import load_dotenv


class DatabaseConnection():
    """
    automatically handles opening and closing databse connections
    """
    def __init__(self):
        load_dotenv()
        self.db_name = os.getenv("DATABASE_NAME")
        self.db_user = os.getenv("DATABASE_USER")
        self.db_password = os.getenv("DATABASE_PASSWORD")
        self.db_host = os.getenv("DATABASE_HOST")
        self.conn = None

    def __enter__(self):
        print(f"DEBUG: Connecting to Database: {self.db_name} with:")
        print(f"DEBUG: User: {self.db_user}, Host: {self.db_host} and Password: {'*' * len(self.db_password) if self.db_password else 'None/Empty'}")
        print("_" * 30)

        try:
            self.conn = mysql.connector.connect(
                host=self.db_host,
                user=self.db_user,
                password=self.db_password,
                database=self.db_name
                )
            return self.conn
        except mysql.connector.Error as err:
            print(f"Error connecting to MySQL server: {err}")
            return None

    def __exit__(self, exc_type, exc_value, exc_traceback):
        if self.conn is not None:
            self.conn.close()

with DatabaseConnection() as conn:
    cursor = conn.cursor()
    with open('schema.sql', 'r') as schema_file:
        schema_script = schema_file.read()
        cursor.execute(schema_script)
        conn.commit()

    with open('seed.sql', 'r') as seed_file:
        seed_script = schema_file.read()
        cursor.execute(seed_script)
        conn.commit()
