import React from "react";
import "./NoteCard.css";

const NoteCard = ({ note, onEdit }) => {
  return (
    <div className="note-card">
      <h3>{note.title}</h3>
      <p>{note.content}</p>
      <button onClick={() => onEdit(note)} className="edit-button">
        Edit
      </button>
    </div>
  );
};

export default NoteCard;
