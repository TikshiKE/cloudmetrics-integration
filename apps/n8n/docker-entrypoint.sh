#!/bin/sh

mkdir -p /home/node/.n8n

if [ -z "$N8N_ENCRYPTION_KEY" ]; then
  echo "ERROR: N8N_ENCRYPTION_KEY is required"
  exit 1
fi

export N8N_LISTEN_ADDRESS="${N8N_LISTEN_ADDRESS:-0.0.0.0}"
export N8N_PORT="${PORT:-${N8N_PORT:-5678}}"
export N8N_PROXY_HOPS="${N8N_PROXY_HOPS:-1}"

MARKER_IMPORT=/home/node/.n8n/.workflows_imported
MARKER_OWNER=/home/node/.n8n/.owner_setup_done
DB=/home/node/.n8n/database.sqlite

n8n_http_ok() {
  node -e "fetch('http://127.0.0.1:'+process.env.N8N_PORT+'/healthz').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))" 2>/dev/null
}

n8n_api_ready() {
  node -e "fetch('http://127.0.0.1:'+process.env.N8N_PORT+'/rest/settings').then(r=>process.exit(r.status<500?0:1)).catch(()=>process.exit(1))" 2>/dev/null
}

wait_for_n8n() {
  echo "==> Waiting for n8n healthz..."
  i=0
  while [ "$i" -lt 180 ]; do
    if n8n_http_ok; then
      echo "==> n8n healthz OK"
      return 0
    fi
    i=$((i + 1))
    sleep 1
  done
  echo "ERROR: n8n healthz timeout"
  return 1
}

wait_for_migrations() {
  echo "==> Waiting for migrations to finish..."
  i=0
  while [ "$i" -lt 180 ]; do
    if n8n_api_ready; then
      echo "==> n8n API ready"
      sleep 5
      return 0
    fi
    i=$((i + 1))
    sleep 2
  done
  echo "WARN: migration wait timed out"
  return 0
}

get_project_id() {
  [ -f "$DB" ] || return 0
  sqlite3 "$DB" "SELECT id FROM project ORDER BY \"createdAt\" LIMIT 1;" 2>/dev/null || true
}

get_user_id() {
  [ -f "$DB" ] || return 0
  sqlite3 "$DB" "SELECT id FROM \"user\" ORDER BY \"createdAt\" LIMIT 1;" 2>/dev/null || true
}

setup_owner() {
  if [ -f "$MARKER_OWNER" ]; then
    echo "==> Owner already configured, skipping"
    return 0
  fi

  if [ -z "$N8N_OWNER_EMAIL" ] || [ -z "$N8N_OWNER_PASSWORD" ]; then
    return 0
  fi

  echo "==> Configuring instance owner (${N8N_OWNER_EMAIL})..."
  attempt=0
  while [ "$attempt" -lt 30 ]; do
    status=$(node -e "
      const port = process.env.N8N_PORT || '5678';
      const body = JSON.stringify({
        email: process.env.N8N_OWNER_EMAIL,
        firstName: process.env.N8N_OWNER_FIRST_NAME || 'Admin',
        lastName: process.env.N8N_OWNER_LAST_NAME || 'Demo',
        password: process.env.N8N_OWNER_PASSWORD,
      });
      fetch('http://127.0.0.1:' + port + '/rest/owner/setup', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body,
      })
        .then(async (r) => {
          const text = await r.text();
          console.log(String(r.status));
          console.error(text);
        })
        .catch(() => console.log('0'));
    " 2>&1 | head -1)

    echo "    owner setup attempt $((attempt + 1)): HTTP ${status:-?}"

    if [ "$status" = "200" ] || [ "$status" = "400" ] || [ "$status" = "409" ]; then
      touch "$MARKER_OWNER"
      echo "==> Owner ready"
      return 0
    fi

    attempt=$((attempt + 1))
    sleep 5
  done

  echo "WARN: owner setup did not complete"
  return 0
}

import_snowflake_credentials() {
  if [ -z "$SNOWFLAKE_ACCOUNT" ] || [ -z "$SNOWFLAKE_USER" ] || [ -z "$SNOWFLAKE_PASSWORD" ]; then
    return 0
  fi

  echo "==> Importing Snowflake credentials (Snowflake CloudMetrics)..."
  node -e "
    const fs = require('fs');
    const payload = [{
      id: 'snowflake-cloudmetrics',
      name: 'Snowflake CloudMetrics',
      type: 'snowflake',
      data: {
        account: process.env.SNOWFLAKE_ACCOUNT,
        database: process.env.SNOWFLAKE_DATABASE || 'CLOUDMETRICS',
        warehouse: process.env.SNOWFLAKE_WAREHOUSE || 'DEV_WH',
        username: process.env.SNOWFLAKE_USER,
        password: process.env.SNOWFLAKE_PASSWORD,
        schema: process.env.SNOWFLAKE_SCHEMA || 'MARTS',
        role: process.env.SNOWFLAKE_ROLE || 'SYSADMIN',
      },
    }];
    fs.writeFileSync('/tmp/snowflake-credentials.json', JSON.stringify(payload));
  "

  if n8n import:credentials --input=/tmp/snowflake-credentials.json; then
    echo "==> Snowflake credentials ready"
  else
    echo "WARN: Snowflake credentials import failed"
  fi
  rm -f /tmp/snowflake-credentials.json
}

import_workflows() {
  if [ -f "$MARKER_IMPORT" ]; then
    echo "==> Workflows already imported, skipping"
    return 0
  fi

  attempt=0
  while [ "$attempt" -lt 30 ]; do
    project_id=$(get_project_id)
    user_id=$(get_user_id)
    echo "==> Importing workflows (attempt $((attempt + 1)), project=${project_id:-none}, user=${user_id:-none})..."

    import_ok=true
    for wf in /opt/workflows/*.json; do
      [ -f "$wf" ] || continue
      echo "    $wf"
      if [ -n "$project_id" ]; then
        n8n import:workflow --input="$wf" --projectId="$project_id" || import_ok=false
      elif [ -n "$user_id" ]; then
        n8n import:workflow --input="$wf" --userId="$user_id" || import_ok=false
      else
        n8n import:workflow --input="$wf" || import_ok=false
      fi
      if [ "$import_ok" = false ]; then
        echo "    ERROR: import failed for $wf"
      fi
    done

    if [ "$import_ok" = true ]; then
      touch "$MARKER_IMPORT"
      echo "==> Workflows imported successfully"
      return 0
    fi

    attempt=$((attempt + 1))
    sleep 10
  done

  echo "WARN: workflow import failed"
  return 0
}

echo "==> Starting n8n..."
n8n start &
n8n_pid=$!

if wait_for_n8n; then
  wait_for_migrations
  setup_owner
  import_snowflake_credentials
  import_workflows
else
  echo "ERROR: n8n never became healthy"
fi

echo "==> n8n is running on port ${N8N_PORT}"
wait "$n8n_pid"
