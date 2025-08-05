import React from "react";
import "./NoteCard.css";

const NoteCard = ({ note, onEdit, onDelete }) => {
  return (
    <div className="note-card">
      <h3>{note.title}</h3>
      <p>{note.content}</p>
      <div className="note-card-buttons">
        <button onClick={() => onEdit(note)} className="edit-button">
          Edit
        </button>
        <button onClick={() => onDelete(note.id)} className="delete-button">
          Delete
        </button>
      </div>
    </div>
  );
};

export default NoteCard;
