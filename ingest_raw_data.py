import os
import pandas as pd
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
from dotenv import load_dotenv


load_dotenv()


df = pd.read_csv("C:\\Users\\emman\\Documents\\Development\\Analytics\\streamwatch\\source\\watch_events_flat.csv")
df.columns = [col.upper() for col in df.columns]

df["CONTENT_RELEASE_DATE"] = pd.to_datetime(df["CONTENT_RELEASE_DATE"]).dt.strftime("%Y-%m-%d")
df["WATCH_DATE"] = pd.to_datetime(df["WATCH_DATE"]).dt.strftime("%Y-%m-%d")


conn = snowflake.connector.connect(
    user=os.getenv("SNOWFLAKE_USER"),
    password=os.getenv("SNOWFLAKE_PASSWORD"),
    account=os.getenv("SNOWFLAKE_ACCOUNT"),
    warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
    database=os.getenv("SNOWFLAKE_DATABASE"),
    schema=os.getenv("SNOWFLAKE_SCHEMA"),
    role=os.getenv("SNOWFLAKE_ROLE")
)

cursor = conn.cursor()


create_table_sql = """
CREATE OR REPLACE TABLE STREAMWATCH_DB.RAW.WATCH_EVENTS_FLAT (
    EVENT_ID VARCHAR(50),
    USER_ID VARCHAR(20),
    USER_NAME VARCHAR(100),
    USER_COUNTRY VARCHAR(60),
    USER_SUBSCRIPTION_TIER VARCHAR(20),
    CONTENT_ID VARCHAR(20),
    CONTENT_TITLE VARCHAR(255),
    CONTENT_GENRE VARCHAR(50),
    CONTENT_RELEASE_DATE DATE,
    CONTENT_DURATION_MINUTES INT,
    WATCH_DATE DATE,
    DEVICE_TYPE VARCHAR(30),
    MINUTES_WATCHED INT,
    COMPLETED_FLAG INT,
    RATING_GIVEN INT
);
"""
cursor.execute(create_table_sql)
print("Table STREAMWATCH_DB.RAW.WATCH_EVENTS_FLAT created successfully.")


success, nchunks, nrows, _ = write_pandas(
    conn=conn,
    df=df,
    table_name="WATCH_EVENTS_FLAT",
    database=os.getenv("SNOWFLAKE_DATABASE"),
    schema=os.getenv("SNOWFLAKE_SCHEMA")
)

print(f"Ingestion complete: {nrows} rows inserted into WATCH_EVENTS_FLAT.")

cursor.close()
conn.close()