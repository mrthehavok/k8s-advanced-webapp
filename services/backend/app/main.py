# [task-3]
from fastapi import FastAPI, APIRouter
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

# Define a router that will contain all API endpoints
api_router = APIRouter()

# Include the notes router under the api_router
api_router.include_router(notes.router)

# Health check endpoints
@api_router.get("/healthz", tags=["Health"])
async def healthz():
    """Liveness probe."""
    return {"status": "ok"}

@api_router.get("/readyz", tags=["Health"])
async def readyz():
    """Readiness probe."""
    # In a real application, this might check database connectivity, etc.
    return {"status": "ready"}

# Mount the main API router with the /api prefix
app.include_router(api_router, prefix="/api")