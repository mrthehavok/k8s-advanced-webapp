import React from "react";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import "@testing-library/jest-dom";
import App from "../App";

global.fetch = jest.fn();

const mockNotes = [
  { id: 1, title: "Test Note 1", content: "Content 1" },
  { id: 2, title: "Test Note 2", content: "Content 2" },
];

describe("App component", () => {
  beforeEach(() => {
    fetch.mockClear();
  });

  test("renders loading state and then displays notes", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => mockNotes,
    });

    render(<App />);

    expect(screen.getByText("Loading...")).toBeInTheDocument();

    await waitFor(() => {
      expect(screen.getByText("Test Note 1")).toBeInTheDocument();
      expect(screen.getByText("Test Note 2")).toBeInTheDocument();
    });
  });

  test("adds a new note", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => mockNotes,
    });
    render(<App />);
    await waitFor(() => expect(fetch).toHaveBeenCalledTimes(1));

    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({ id: 3, title: "New Note", content: "New Content" }),
    });
    // This is for the refetch after adding
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => [
        ...mockNotes,
        { id: 3, title: "New Note", content: "New Content" },
      ],
    });

    fireEvent.change(screen.getByPlaceholderText("Title"), {
      target: { value: "New Note" },
    });
    fireEvent.change(screen.getByPlaceholderText("Content"), {
      target: { value: "New Content" },
    });
    fireEvent.click(screen.getByText("Add Note"));

    await waitFor(() => {
      expect(fetch).toHaveBeenCalledTimes(3);
      expect(screen.getByText("New Note")).toBeInTheDocument();
    });
  });

  test("deletes a note", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => mockNotes,
    });
    render(<App />);
    await waitFor(() =>
      expect(screen.getByText("Test Note 1")).toBeInTheDocument()
    );

    fetch.mockResolvedValueOnce({
      ok: true,
    });
    // This is for the refetch after deleting
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => [mockNotes[1]],
    });

    const deleteButtons = screen.getAllByText("Delete");
    fireEvent.click(deleteButtons[0]);

    await waitFor(() => {
      expect(fetch).toHaveBeenCalledTimes(3);
      expect(screen.queryByText("Test Note 1")).not.toBeInTheDocument();
    });
  });

  test("shows an error message when fetch fails", async () => {
    fetch.mockRejectedValueOnce(new Error("Failed to fetch notes"));
    render(<App />);

    await waitFor(() => {
      expect(screen.getByText("Failed to fetch notes")).toBeInTheDocument();
    });
  });
});
