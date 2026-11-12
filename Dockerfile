FROM python:3.9-slim

WORKDIR /app

# Git commits the updated index.html; perl is used by update_index.sh
RUN apt-get update && apt-get install -y --no-install-recommends git perl ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . /app

RUN chmod +x /app/.github/scripts/entrypoint.sh

ENTRYPOINT ["/app/.github/scripts/entrypoint.sh"]
