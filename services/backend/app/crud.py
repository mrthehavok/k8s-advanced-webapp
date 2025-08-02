# [task-3]
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from . import db, models

async def get_note(db_session: AsyncSession, note_id: int):
    """Retrieve a single note by its ID."""
    result = await db_session.execute(select(db.Note).filter(db.Note.id == note_id))
    return result.scalar_one_or_none()

async def get_notes(db_session: AsyncSession, skip: int = 0, limit: int = 10):
    """Retrieve a list of notes with pagination."""
    result = await db_session.execute(
        select(db.Note).offset(skip).limit(limit)
    )
    return result.scalars().all()

async def get_notes_count(db_session: AsyncSession):
    """Get the total number of notes."""
    result = await db_session.execute(select(func.count()).select_from(db.Note))
    return result.scalar_one()

async def create_note(db_session: AsyncSession, note: models.NoteIn):
    """Create a new note."""
    db_note = db.Note(title=note.title, content=note.content)
    db_session.add(db_note)
    await db_session.commit()
    await db_session.refresh(db_note)
    return db_note

async def update_note(db_session: AsyncSession, note_id: int, note_data: models.NoteUpdate):
    """Update an existing note."""
    db_note = await get_note(db_session, note_id)
    if db_note:
        update_data = note_data.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_note, key, value)
        await db_session.commit()
        await db_session.refresh(db_note)
    return db_note

async def delete_note(db_session: AsyncSession, note_id: int):
    """Delete a note."""
    db_note = await get_note(db_session, note_id)
    if db_note:
        await db_session.delete(db_note)
        await db_session.commit()
    return db_note