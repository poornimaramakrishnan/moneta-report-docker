# syntax=docker/dockerfile:1
# ──────────────────────────────────────────────────────────────
# Moneta Report Generator - Docker Distribution
# No source code included. Installs from private GitHub repo.
# Token is injected via BuildKit secret mount - never stored in
# any image layer and produces no lint warnings.
# ──────────────────────────────────────────────────────────────
FROM python:3.12-slim AS builder

ENV PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

# Install git (required by pip to clone from GitHub) then clean up apt cache
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# The secret is mounted at /run/secrets/github_token for the
# duration of this single RUN step only - not cached, not logged.
RUN --mount=type=secret,id=github_token \
    pip install --upgrade pip && \
    pip install "moneta-report-generator @ git+https://$(cat /run/secrets/github_token)@github.com/poornimaramakrishnan/moneta-report-generator.git@main"

# ── runtime stage (no token in final image) ──────────────────
FROM python:3.12-slim

LABEL maintainer="poornima2489@gmail.com"
LABEL description="Moneta Excel Report Generator - generates professional financial reports from JSON data"

COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/moneta-report /usr/local/bin/moneta-report

WORKDIR /data

ENTRYPOINT ["moneta-report"]
CMD ["--help"]
