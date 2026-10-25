import os
from contextlib import closing

from fastapi import FastAPI, HTTPException

app = FastAPI(title="Coditude Assessment API", version="1.0.0")

@app.get("/health")
@app.get("/api/health")
def health():
    return {"status": "ok"}

@app.get("/")
@app.get("/api/")
def root():
    return {"service": "python-backend", "environment": os.getenv("APP_ENV", "local")}

@app.get("/db-health")
def db_health():
    """Optional database connectivity check; fails clearly when DB settings are absent."""
    host = os.getenv("DB_HOST")
    name = os.getenv("DB_NAME", "appdb")
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    if not all([host, user, password]):
        raise HTTPException(status_code=503, detail="Database configuration is not available")
    try:
        import psycopg
        with closing(psycopg.connect(host=host, dbname=name, user=user, password=password,
                                     connect_timeout=3, sslmode="require")) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1")
                cur.fetchone()
        return {"status": "ok", "database": "reachable"}
    except Exception:
        raise HTTPException(status_code=503, detail="Database is not reachable")
