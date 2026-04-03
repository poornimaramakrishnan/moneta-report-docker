# ──────────────────────────────────────────────────────────────
# Moneta Report Generator - Docker Distribution
# No source code included. Installs from private GitHub repo.
# ──────────────────────────────────────────────────────────────
FROM python:3.12-slim AS builder

ARG GITHUB_TOKEN
ENV PIP_NO_CACHE_DIR=1

RUN pip install --upgrade pip && \
    pip install "moneta-report-generator @ git+https://${GITHUB_TOKEN}@github.com/poornimaramakrishnan/moneta-report-generator.git@main"

# ── runtime stage (no token in final image) ──────────────────
FROM python:3.12-slim

LABEL maintainer="poornima2489@gmail.com"
LABEL description="Moneta Excel Report Generator - generates professional financial reports from JSON data"

COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/moneta-report /usr/local/bin/moneta-report

WORKDIR /data

ENTRYPOINT ["moneta-report"]
CMD ["--help"]
