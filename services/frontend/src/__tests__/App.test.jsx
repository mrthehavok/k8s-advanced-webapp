import React from "react";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import "@testing-library/jest-dom";
import App from "../App";
import { ThemeProvider } from "../contexts/ThemeContext";

global.fetch = jest.fn();

const mockNotes = [
  { id: 1, title: "Test Note 1", content: "Content 1" },
  { id: 2, title: "Test Note 2", content: "Content 2" },
];

// Mock matchMedia
Object.defineProperty(window, "matchMedia", {
  writable: true,
  value: jest.fn().mockImplementation((query) => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: jest.fn(), // deprecated
    removeListener: jest.fn(), // deprecated
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
  })),
});

const renderWithTheme = (ui, options) => {
  return render(<ThemeProvider>{ui}</ThemeProvider>, options);
};

describe("App component", () => {
  beforeEach(() => {
    fetch.mockClear();
    localStorage.clear();
  });

  test("renders header, loading state, and then displays notes", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({ data: mockNotes }),
    });

    process.env.VITE_APP_VERSION = 'v2-test';
    renderWithTheme(<App />);

    expect(screen.getByText("Notes - v2-test")).toBeInTheDocument();
    expect(screen.getByText("Loading...")).toBeInTheDocument();

    await waitFor(() => {
      expect(screen.getByText("Test Note 1")).toBeInTheDocument();
      expect(screen.getByText("Test Note 2")).toBeInTheDocument();
    });
  });

  test("adds a new note", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({ data: mockNotes }),
    });
    renderWithTheme(<App />);
    await waitFor(() => expect(fetch).toHaveBeenCalledTimes(1));

    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({ id: 3, title: "New Note", content: "New Content" }),
    });
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({
        data: [
          ...mockNotes,
          { id: 3, title: "New Note", content: "New Content" },
        ],
      }),
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

  test("updates a note's title and content", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({ data: mockNotes }),
    });
    renderWithTheme(<App />);
    await waitFor(() =>
      expect(screen.getByText("Test Note 1")).toBeInTheDocument()
    );

    const editButtons = screen.getAllByText("Edit");

    fetch.mockResolvedValueOnce({ ok: true, json: async () => ({}) });
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({
        data: [
          { id: 1, title: "Updated Note", content: "Updated Content" },
          mockNotes[1],
        ],
      }),
    });

    fireEvent.click(editButtons[0]);

    await waitFor(() => {
      expect(screen.getByText("Edit Note")).toBeInTheDocument();
    });

    fireEvent.change(screen.getByDisplayValue("Test Note 1"), {
      target: { value: "Updated Note" },
    });
    fireEvent.change(screen.getByDisplayValue("Content 1"), {
      target: { value: "Updated Content" },
    });

    fireEvent.click(screen.getByText("Save"));

    await waitFor(() => {
      expect(screen.getByText("Updated Note")).toBeInTheDocument();
      expect(screen.getByText("Updated Content")).toBeInTheDocument();
    });
  });

  test("deletes a note", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({ data: mockNotes }),
    });
    renderWithTheme(<App />);
    await waitFor(() =>
      expect(screen.getByText("Test Note 1")).toBeInTheDocument()
    );

    fetch.mockResolvedValueOnce({ ok: true, json: async () => ({}) });
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({
        data: [mockNotes[1]],
      }),
    });

    const deleteButtons = screen.getAllByText("Delete");
    fireEvent.click(deleteButtons[0]);

    await waitFor(() => {
      expect(screen.queryByText("Test Note 1")).not.toBeInTheDocument();
      expect(screen.getByText("Test Note 2")).toBeInTheDocument();
    });
  });

  test("filters notes and restores list when search is cleared", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({ data: mockNotes }),
    });
    renderWithTheme(<App />);
    await waitFor(() =>
      expect(screen.getByText("Test Note 1")).toBeInTheDocument()
    );

    const searchInput = screen.getByPlaceholderText("Search notes...");
    fireEvent.change(searchInput, {
      target: { value: "Note 2" },
    });

    await waitFor(() => {
      expect(screen.queryByText("Test Note 1")).not.toBeInTheDocument();
      expect(screen.getByText("Test Note 2")).toBeInTheDocument();
    });

    // Clear the search
    fireEvent.change(searchInput, {
      target: { value: "" },
    });

    await waitFor(() => {
      expect(screen.getByText("Test Note 1")).toBeInTheDocument();
      expect(screen.getByText("Test Note 2")).toBeInTheDocument();
    });
  });

  test("toggles theme", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({ data: mockNotes }),
    });
    renderWithTheme(<App />);
    await waitFor(() =>
      expect(screen.getByText("Test Note 1")).toBeInTheDocument()
    );

    const themeToggleButton = screen.getByText("Switch to Dark Mode");
    fireEvent.click(themeToggleButton);

    await waitFor(() => {
      expect(screen.getByText("Switch to Light Mode")).toBeInTheDocument();
    });

    expect(localStorage.getItem("theme")).toBe("dark");
  });

  test("shows an error message when fetch fails", async () => {
    fetch.mockRejectedValueOnce(new Error("Failed to fetch notes"));
    renderWithTheme(<App />);

    await waitFor(() => {
      expect(screen.getByText("Failed to fetch notes")).toBeInTheDocument();
    });
  });
});
