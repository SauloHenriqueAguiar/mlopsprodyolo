# Multi-stage build para cache de dependências
FROM python:3.10-slim-bullseye as base

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    awscli \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Stage para dependencies (será cacheado)
FROM base as dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Stage final
FROM dependencies as production
COPY . .
RUN useradd --create-home --shell /bin/bash app && \
    chown -R app:app /app
USER app
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1
CMD ["python3", "app.py"]
