# [task-3]
import pytest
from httpx import AsyncClient
from app.main import app

@pytest.mark.asyncio
async def test_healthz_endpoint():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/healthz")
        assert response.status_code == 200
        assert response.json() == {"status": "ok"}