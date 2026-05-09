import os
import logging
import uvicorn
from fastapi import FastAPI
from .healthz import router as healthz_router

logging.basicConfig(level=logging.INFO)

NODE_ID = os.getenv("NODE_ID")
SERIAL = os.getenv("DEVICE_SERIAL")
JOB_ID = os.getenv("JOB_ID")

logger = logging.getLogger("device")

app = FastAPI(title="Device")
app.include_router(healthz_router)

def main() -> None:
    logger.info(f"NODE_ID: {NODE_ID}")
    logger.info(f"SERIAL: {SERIAL}")
    logger.info(f"JOB_ID: {JOB_ID}")
    uvicorn.run(app, host="0.0.0.0", port=8000)

if __name__ == "__main__":
    main()
