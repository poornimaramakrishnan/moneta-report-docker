# syntax=docker/dockerfile:1
# ──────────────────────────────────────────────────────────────
# Moneta Report Generator - Docker Distribution
# Installs from PyPI - no auth required, no secrets needed.
# ──────────────────────────────────────────────────────────────
FROM python:3.12-slim AS builder

ENV PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

RUN pip install --upgrade pip && \
    pip install "moneta-report-generator==1.0.2"

# ── runtime stage ─────────────────────────────────────────────
FROM python:3.12-slim

LABEL maintainer="poornima2489@gmail.com"
LABEL description="Moneta Excel Report Generator - generates professional financial reports from JSON data"

COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/moneta-report /usr/local/bin/moneta-report

WORKDIR /data

ENTRYPOINT ["moneta-report"]
CMD ["--help"]
