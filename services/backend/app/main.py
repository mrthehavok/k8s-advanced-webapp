# [task-3]
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from .db import create_tables
from .routers import notes

@asynccontextmanager
async def lifespan(app: FastAPI):
    # On startup
    await create_tables()
    yield
    # On shutdown
    # (add cleanup logic here if needed)

app = FastAPI(
    title="Team Notes Backend",
    description="FastAPI backend for the Team Notes application.",
    version="0.1.0",
    lifespan=lifespan
)

# CORS configuration
origins = [
    "*",  # Allow all origins for now, as per instructions
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(notes.router)

# Health check endpoints
@app.get("/healthz", tags=["Health"])
async def healthz():
    """Liveness probe."""
    return {"status": "ok"}

@app.get("/readyz", tags=["Health"])
async def readyz():
    """Readiness probe."""
    # In a real application, this might check database connectivity, etc.
    return {"status": "ready"}