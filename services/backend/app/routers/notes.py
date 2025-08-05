# [task-3]
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List

from .. import crud, models, db

router = APIRouter(
    prefix="/notes",
    tags=["notes"],
    responses={404: {"description": "Not found"}},
)

@router.post("/", response_model=models.Note, status_code=status.HTTP_201_CREATED)
async def create_note(note: models.NoteIn, db_session: AsyncSession = Depends(db.get_db)):
    """Create a new note."""
    return await crud.create_note(db_session=db_session, note=note)

@router.get("/", response_model=models.Pagination)
async def read_notes(
    db_session: AsyncSession = Depends(db.get_db),
    skip: int = 0,
    limit: int = 10,
):
    """Retrieve all notes with pagination."""
    notes = await crud.get_notes(db_session, skip=skip, limit=limit)
    total = await crud.get_notes_count(db_session)
    
    # Convert SQLAlchemy models to Pydantic models for the response
    notes_out = [models.Note.model_validate(note) for note in notes]

    return models.Pagination(total=total, limit=limit, offset=skip, data=notes)


@router.get("/{note_id}", response_model=models.Note)
async def read_note(note_id: int, db_session: AsyncSession = Depends(db.get_db)):
    """Retrieve a single note by its ID."""
    db_note = await crud.get_note(db_session, note_id=note_id)
    if db_note is None:
        raise HTTPException(status_code=404, detail="Note not found")
    return db_note

@router.put("/{note_id}", response_model=models.Note)
async def update_note(
    note_id: int,
    note: models.NoteUpdate,
    db_session: AsyncSession = Depends(db.get_db),
):
    """Update a note."""
    db_note = await crud.update_note(db_session, note_id=note_id, note_data=note)
    if db_note is None:
        raise HTTPException(status_code=404, detail="Note not found")
    return db_note

@router.delete("/{note_id}", response_model=models.Note)
async def delete_note(note_id: int, db_session: AsyncSession = Depends(db.get_db)):
    """Delete a note."""
    db_note = await crud.delete_note(db_session, note_id=note_id)
    if db_note is None:
        raise HTTPException(status_code=404, detail="Note not found")
    return db_note