# [task-3]

# Team Notes Backend Service

This is the FastAPI backend service for the Team Notes application.

## Local Development

### Prerequisites

- Python 3.12+
- Poetry

### Setup

1.  **Install dependencies:**

    ```bash
    poetry install
    ```

2.  **Run the application:**

    The application will be served using Uvicorn.

    ```bash
    poetry run uvicorn app.main:app --reload
    ```

    The API will be available at `http://127.0.0.1:8000`.

### Running Tests

To run the tests, use pytest:

```bash
poetry run pytest
```

To get a coverage report:

```bash
poetry run pytest --cov=app
```

## Docker

### Build the Image

To build the Docker image:

```bash
docker build -t team-notes-backend .
```

### Run the Container

To run the Docker container:

```bash
docker run -p 8000:8000 team-notes-backend
```

The API will be available at `http://localhost:8000`.
