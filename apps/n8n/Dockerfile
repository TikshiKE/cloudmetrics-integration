FROM n8nio/n8n:1.77.4

USER root
RUN apk add --no-cache sqlite
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY workflows /opt/workflows
RUN chmod +x /docker-entrypoint.sh
USER node

ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

ENTRYPOINT ["/docker-entrypoint.sh"]
