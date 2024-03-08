import asyncio
import kopf

LOCK: asyncio.Lock

@kopf.on.startup()
async def startup_fn(logger, **kwargs):
    global LOCK
    logger.info("Initialising the task-lock...")
    print("Hello World!",flush=True)
    LOCK = asyncio.Lock()  # uses the running asyncio loop