# [task-3]
from datetime import datetime
import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker
from sqlalchemy.pool import StaticPool
from app.main import app
from app import crud, models
from app.db import get_db, Base

# Use an in-memory SQLite database for testing
DATABASE_URL = "sqlite+aiosqlite:///:memory:"

engine = create_async_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = async_sessionmaker(autocommit=False, autoflush=False, bind=engine)

async def override_get_db():
    """Dependency override to use the test database."""
    async with TestingSessionLocal() as session:
        yield session

@pytest.fixture(scope="function", autouse=True)
async def setup_database():
    """Create and drop database tables for each test function."""
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)

app.dependency_overrides[get_db] = override_get_db

@pytest.mark.asyncio
async def test_create_note():
    """Test creating a new note."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.post("/notes/", json={"title": "Test Note", "content": "Test content"})
        assert response.status_code == 201
        data = response.json()
        assert data["title"] == "Test Note"
        assert data["content"] == "Test content"
        assert "id" in data

@pytest.mark.asyncio
async def test_read_note():
    """Test reading a single note."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # First, create a note
        response = await ac.post("/notes/", json={"title": "Test Note", "content": "Test content"})
        note_id = response.json()["id"]

        # Then, read the note
        response = await ac.get(f"/notes/{note_id}")
        assert response.status_code == 200
        data = response.json()
        assert data["title"] == "Test Note"
        assert data["id"] == note_id

@pytest.mark.asyncio
async def test_read_nonexistent_note():
    """Test reading a note that does not exist."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/notes/999")
    assert response.status_code == 404

@pytest.mark.asyncio
async def test_read_notes():
    """Test reading multiple notes with pagination."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Create a few notes
        await ac.post("/notes/", json={"title": "Note 1", "content": "Content 1"})
        await ac.post("/notes/", json={"title": "Note 2", "content": "Content 2"})

        # Read the notes
        response = await ac.get("/notes/")
        assert response.status_code == 200
        data = response.json()
        assert data["total"] == 2
        assert len(data["data"]) == 2
        assert data["data"][0]["title"] == "Note 1"

@pytest.mark.asyncio
async def test_read_notes_empty_db():
    """Test reading notes from an empty database."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/notes/")
    assert response.status_code == 200
    data = response.json()
    assert data["total"] == 0
    assert len(data["data"]) == 0

@pytest.mark.asyncio
async def test_read_notes_with_pagination():
    """Test reading multiple notes with pagination parameters."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Create a few notes
        await ac.post("/notes/", json={"title": "Note 1", "content": "Content 1"})
        await ac.post("/notes/", json={"title": "Note 2", "content": "Content 2"})
        await ac.post("/notes/", json={"title": "Note 3", "content": "Content 3"})

        # Read the notes with pagination
        response = await ac.get("/notes/?skip=1&limit=1")
        assert response.status_code == 200
        data = response.json()
        assert data["total"] == 3
        assert len(data["data"]) == 1
        assert data["data"][0]["title"] == "Note 2"

@pytest.mark.asyncio
async def test_update_note():
    """Test updating a note."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Create a note
        response = await ac.post("/notes/", json={"title": "Old Title", "content": "Old Content"})
        note_id = response.json()["id"]

        # Update the note
        response = await ac.put(f"/notes/{note_id}", json={"title": "New Title"})
        assert response.status_code == 200
        data = response.json()
        assert data["title"] == "New Title"
        assert data["content"] == "Old Content" # Content should not be changed

@pytest.mark.asyncio
async def test_update_note_no_data():
    """Test updating a note with no data."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Create a note
        response = await ac.post("/notes/", json={"title": "Old Title", "content": "Old Content"})
        note_id = response.json()["id"]

        # Update the note with no data
        response = await ac.put(f"/notes/{note_id}", json={})
        assert response.status_code == 200
        data = response.json()
        assert data["title"] == "Old Title"
        assert data["content"] == "Old Content"

@pytest.mark.asyncio
async def test_update_note_partial():
    """Test updating a note with partial data."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Create a note
        response = await ac.post("/notes/", json={"title": "Old Title", "content": "Old Content"})
        note_id = response.json()["id"]

        # Update the note with partial data
        response = await ac.put(f"/notes/{note_id}", json={"content": "New Content"})
        assert response.status_code == 200
        data = response.json()
        assert data["title"] == "Old Title" # Title should not be changed
        assert data["content"] == "New Content"

@pytest.mark.asyncio
async def test_delete_note():
    """Test deleting a note."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Create a note
        response = await ac.post("/notes/", json={"title": "To Be Deleted", "content": "Delete me"})
        note_id = response.json()["id"]

        # Delete the note
        response = await ac.delete(f"/notes/{note_id}")
        assert response.status_code == 200

        # Verify it's gone
        response = await ac.get(f"/notes/{note_id}")
        assert response.status_code == 404

@pytest.mark.asyncio
async def test_update_nonexistent_note():
    """Test updating a note that does not exist."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.put("/notes/999", json={"title": "New Title"})
    assert response.status_code == 404

@pytest.mark.asyncio
async def test_delete_nonexistent_note():
    """Test deleting a note that does not exist."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.delete("/notes/999")
    assert response.status_code == 404

@pytest.mark.asyncio
async def test_healthz():
    """Test the healthz endpoint."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/healthz")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}

@pytest.mark.asyncio
async def test_readyz():
    """Test the readyz endpoint."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/readyz")
    assert response.status_code == 200
    assert response.json() == {"status": "ready"}

@pytest.mark.asyncio
async def test_crud_update_nonexistent_note():
    """Test CRUD update on a note that does not exist."""
    async with TestingSessionLocal() as session:
        note_data = models.NoteUpdate(title="New Title")
        db_note = await crud.update_note(session, note_id=999, note_data=note_data)
        assert db_note is None

@pytest.mark.asyncio
async def test_crud_delete_nonexistent_note():
    """Test CRUD delete on a note that does not exist."""
    async with TestingSessionLocal() as session:
        db_note = await crud.delete_note(session, note_id=999)
        assert db_note is None

@pytest.mark.asyncio
async def test_get_notes_count():
    """Test getting the total number of notes."""
    async with TestingSessionLocal() as session:
        # Create a few notes
        await crud.create_note(session, models.NoteIn(title="Note 1", content="Content 1"))
        await crud.create_note(session, models.NoteIn(title="Note 2", content="Content 2"))

        # Get the count
        count = await crud.get_notes_count(session)
        assert count == 2

@pytest.mark.asyncio
async def test_crud_delete_note():
    """Test CRUD delete on a note that exists."""
    async with TestingSessionLocal() as session:
        # Create a note
        note = await crud.create_note(session, models.NoteIn(title="Note 1", content="Content 1"))

        # Delete the note
        deleted_note = await crud.delete_note(session, note_id=note.id)
        assert deleted_note is not None
        assert deleted_note.id == note.id

        # Verify it's gone
        db_note = await crud.get_note(session, note_id=note.id)
        assert db_note is None

        # Get the count
        count = await crud.get_notes_count(session)
        assert count == 0

@pytest.mark.asyncio
async def test_note_repr():
    """Test the __repr__ method of the Note model."""
    note = models.Note(id=1, title="Test Note", content="Test content", created_at=datetime.now(), updated_at=datetime.now())
    assert repr(note) == f"<Note(id=1, title='Test Note')>"
@pytest.mark.asyncio
async def test_create_note_invalid_payload():
    """Test creating a note with an invalid payload (missing title)."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.post("/notes/", json={"content": "This should fail"})
        assert response.status_code == 422  # Unprocessable Entity

@pytest.mark.asyncio
async def test_create_note_long_title():
    """Test creating a note with a title that exceeds the maximum length."""
    long_title = "a" * 256
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.post("/notes/", json={"title": long_title, "content": "Test content"})
        assert response.status_code == 422

@pytest.mark.asyncio
async def test_update_note_long_title():
    """Test updating a note with a title that exceeds the maximum length."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Create a note
        response = await ac.post("/notes/", json={"title": "Original", "content": "Content"})
        note_id = response.json()["id"]

        # Try to update with a long title
        long_title = "a" * 256
        response = await ac.put(f"/notes/{note_id}", json={"title": long_title})
        assert response.status_code == 422

@pytest.mark.asyncio
@pytest.mark.parametrize(
    "skip, limit, expected_total, expected_data_len, expected_first_title",
    [
        (0, 101, 3, 3, "Note 1"),   # limit > MAX_LIMIT_PER_PAGE
        (10, 10, 3, 0, None),       # skip > total
        (0, 0, 3, 0, None),         # limit = 0
        (-1, 5, 3, 3, "Note 1"),    # skip < 0
        (0, -1, 3, 3, "Note 1"),    # limit < 0
    ],
)
async def test_read_notes_pagination_edge_cases(skip, limit, expected_total, expected_data_len, expected_first_title):
    """Test pagination edge cases for reading notes."""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Create 3 notes
        await ac.post("/notes/", json={"title": "Note 1", "content": "Content 1"})
        await ac.post("/notes/", json={"title": "Note 2", "content": "Content 2"})
        await ac.post("/notes/", json={"title": "Note 3", "content": "Content 3"})

        response = await ac.get(f"/notes/?skip={skip}&limit={limit}")
        assert response.status_code == 200
        data = response.json()
        assert data["total"] == expected_total
        assert len(data["data"]) == expected_data_len
        if expected_first_title:
            assert data["data"][0]["title"] == expected_first_title
@pytest.mark.asyncio
async def test_db_create_tables():
    """Test that the create_tables function runs without error."""
    # This test mainly ensures the function can be called without raising an exception.
    # The setup_database fixture already handles table creation and teardown.
    try:
        await db.create_tables()
    except Exception as e:
        pytest.fail(f"db.create_tables() raised an exception: {e}")

from sqlalchemy.ext.asyncio import AsyncSession
from async_generator import anext

@pytest.mark.asyncio
async def test_get_db_dependency():
    """Test the get_db dependency injector."""
    # The dependency is already overridden for all tests,
    # but this test explicitly checks if it yields a session.
    session_generator = db.get_db()
    session = await anext(session_generator)
    assert isinstance(session, AsyncSession)
    # Ensure the generator is properly closed
    with pytest.raises(StopAsyncIteration):
        await anext(session_generator)