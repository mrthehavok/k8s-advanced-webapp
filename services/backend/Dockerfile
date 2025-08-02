# [task-3]
# ---- Builder Stage ----
FROM python:3.12-slim as builder

# Set working directory
WORKDIR /app

# Install poetry
RUN pip install poetry

# Copy dependency definition files
COPY pyproject.toml poetry.lock ./

# Install dependencies
# --no-root: Don't install the project itself, only dependencies
# --only main: Don't install development dependencies
RUN poetry config virtualenvs.in-project true && \
    poetry install --no-root --only main

# ---- Final Stage ----
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /app/.venv ./.venv

# Activate virtual environment
ENV PATH="/app/.venv/bin:$PATH"

# Copy application code
COPY ./app ./app

# Expose port and run application
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]