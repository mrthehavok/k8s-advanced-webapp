# [task-3]
from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import List, Optional

# Pydantic model for creating a note
class NoteIn(BaseModel):
    title: str
    content: str

# Pydantic model for updating a note
class NoteUpdate(BaseModel):
    title: Optional[str] = None
    content: Optional[str] = None

# Pydantic model for representing a note in the database
class Note(BaseModel):
    id: int
    title: str
    content: str
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)

# Pydantic model for the response when fetching multiple notes
class NoteOut(BaseModel):
    id: int
    title: str
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)

# Pydantic model for pagination
class Pagination(BaseModel):
    total: int
    limit: int
    offset: int
    data: List[NoteOut]