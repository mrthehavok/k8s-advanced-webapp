import React, { useState, useEffect } from "react";
import "./EditNoteModal.css";

const EditNoteModal = ({ note, onSave, onClose }) => {
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");

  useEffect(() => {
    if (note) {
      setTitle(note.title);
      setContent(note.content);
    }
  }, [note]);

  if (!note) {
    return null;
  }

  const handleSave = () => {
    onSave({ ...note, title, content });
  };

  return (
    <div className="modal-overlay">
      <div className="modal-content">
        <h2>Edit Note</h2>
        <input
          type="text"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          className="modal-input"
        />
        <textarea
          value={content}
          onChange={(e) => setContent(e.target.value)}
          className="modal-textarea"
        />
        <div className="modal-actions">
          <button onClick={handleSave} className="save-button">
            Save
          </button>
          <button onClick={onClose} className="cancel-button">
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
};

export default EditNoteModal;
