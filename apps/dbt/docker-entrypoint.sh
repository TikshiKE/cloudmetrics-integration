#!/bin/sh
set -e

if [ -z "$SNOWFLAKE_ACCOUNT" ] || [ -z "$SNOWFLAKE_USER" ] || [ -z "$SNOWFLAKE_PASSWORD" ]; then
  echo "ERROR: set SNOWFLAKE_ACCOUNT, SNOWFLAKE_USER, SNOWFLAKE_PASSWORD in Railway Variables"
  exit 1
fi

mkdir -p /root/.dbt

cat > /root/.dbt/profiles.yml <<EOF
cloudmetrics:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: ${SNOWFLAKE_ACCOUNT}
      user: ${SNOWFLAKE_USER}
      password: ${SNOWFLAKE_PASSWORD}
      role: ${SNOWFLAKE_ROLE:-SYSADMIN}
      database: CLOUDMETRICS
      warehouse: DEV_WH
      schema: STAGING
      threads: 4
      client_session_keep_alive: false
EOF

cd /app/cloudmetrics

echo "==> dbt debug"
dbt debug

echo "==> dbt run"
dbt run

echo "==> dbt test"
dbt test

echo "==> dbt finished at $(date -u +%Y-%m-%dT%H:%M:%SZ)"
