# src/function_code/lambda_function.py
import json
import os
import psycopg2 # You need this library for PostgreSQL
import time

# Get connection details from environment variables
DB_HOST = os.environ['DB_HOST'] 
DB_USER = os.environ['DB_USER'] 
DB_NAME = os.environ['DB_NAME']
DB_PASSWORD = os.environ['DB_PASSWORD']

def lambda_handler(event, context):
    conn = None
    try:
        # 1. Establish the connection using the standard credentials
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        
        # 2. Execute a simple query (e.g., check version)
        with conn.cursor() as cur:
            cur.execute("SELECT version();")
            db_version = cur.fetchone()[0]
        
        db_status = f"SUCCESS! Connected to DB version: {db_version}"

    except Exception as e:
        db_status = f"DB Connection Failed: {e}"
        # If connection fails, return an error status
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "Database connection failed", "details": str(e)})
        }
    finally:
        if conn:
            conn.close()

    # Successful response
    response_data = {
        "message": "Local Lambda tested successfully with direct DB connection.",
        "timestamp": time.time(),
        "database_status": db_status
    }

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(response_data)
    }