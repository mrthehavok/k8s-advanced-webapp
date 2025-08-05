# [task-3]
# ---- Builder Stage ----
FROM python:3.12-alpine as builder

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
    poetry install --no-root --only main && \
    rm -rf $(poetry config cache-dir)

# ---- Final Stage ----
FROM python:3.12-alpine

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN mkdir -p /data && chown -R appuser:appgroup /data
USER appuser

# Copy virtual environment from builder
COPY --from=builder /app/.venv ./.venv

# Activate virtual environment
ENV PATH="/app/.venv/bin:$PATH"

# Copy application code
COPY ./app ./app

# Expose port and run application
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]