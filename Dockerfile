# =============================================================================
# Dockerfile: Keycloak 26.x on Railway – Embedded storage (single-container)
# Docker image source: https://hub.docker.com/r/keycloak/keycloak
# Project:          https://github.com/keycloak/keycloak
# License:          Apache-2.0
# =============================================================================

FROM keycloak/keycloak:26.6.4

ARG BUILD_YEAR=2026

LABEL org.opencontainers.image.title="Keycloak" \
      org.opencontainers.image.description="Open source identity and access management for modern applications." \
      org.opencontainers.image.source="https://github.com/keycloak/keycloak" \
      org.opencontainers.image.vendor="Red Hat" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.created="${BUILD_YEAR}-07-03T00:00:00Z"

ENV KC_DB=dev-file \
    KC_PROXY=edge \
    KC_HTTP_ENABLED=true \
    KC_LOG_LEVEL=info \
    KC_METRICS_ENABLED=false \
    KEYCLOAK_ADMIN=admin \
    KEYCLOAK_ADMIN_PASSWORD=keycloak123 \
    TZ=UTC

RUN mkdir -p /opt/keycloak/data &\
    chown 1000:1000 /opt/keycloak || true

USER 1000:1000

HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=5 \
    CMD curl -f http://localhost:8080/health/ready || exit 1

EXPOSE 8080

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev"]








