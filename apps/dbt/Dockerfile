FROM python:3.12-slim

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends git \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt docker-entrypoint.sh ./
RUN pip install --no-cache-dir -r requirements.txt \
  && chmod +x /app/docker-entrypoint.sh

ARG GITHUB_REPO=TikshiKE/cloudmetrics-integration
ARG GITHUB_REF=master
RUN git clone --depth 1 --branch "${GITHUB_REF}" \
    "https://github.com/${GITHUB_REPO}.git" /tmp/repo \
  && mv /tmp/repo/dbt/cloudmetrics /app/cloudmetrics \
  && rm -rf /tmp/repo

ENTRYPOINT ["/app/docker-entrypoint.sh"]
