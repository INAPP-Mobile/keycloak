# =============================================================================
# Dockerfile: Keycloak 26.x on Railway – sibling PostgreSQL service
# Base image:  https://hub.docker.com/r/keycloak/keycloak (official)
# Project:     https://github.com/keycloak/keycloak
# License:     Apache-2.0
# =============================================================================
#
# Why we don't use the Railway Postgres plugin:
#   The plugin ships postgres-ssl:18 which forces PGDATA to start with the
#   volume mount path, trapping the ext4 `lost+found/` directory inside
#   PGDATA. initdb then crashes on first deploy with "directory exists but
#   is not empty". Instead, we use a sibling postgres:16-alpine service
#   (see ./postgres/) with a parent-mount volume geometry. The sibling
#   service form sets POSTGRES_USER / POSTGRES_PASSWORD / POSTGRES_DB.
#   Cross-service ${{...}} macros resolve empty in marketplace deploys, so
#   the JDBC URL here uses a literal password (keycloak_pw_2026) that
#   matches POSTGRES_PASSWORD in the sibling's form. Users overriding the
#   password MUST update both forms to keep them in sync.

FROM keycloak/keycloak:26.7.4

# Keycloak 26.x bootstrap admin env vars (replaces deprecated KEYCLOAK_ADMIN).
# KC_BOOTSTRAP_ADMIN_PASSWORD is provided by the template form (default
# ${{secret(32)}}). On first run, Keycloak creates the admin user; on
# subsequent runs, the bootstrap is skipped.
ENV KC_BOOTSTRAP_ADMIN_USERNAME=admin \
    KC_DB=postgres \
    KC_PROXY=edge \
    KC_HTTP_ENABLED=true \
    KC_LOG_LEVEL=info \
    KC_METRICS_ENABLED=false \
    TZ=UTC

# Keycloak 26.x official image already sets USER 1000 (keycloak user) and
# has /opt/keycloak writable by that uid. The build step is also baked
# into the image, so `start --optimized` uses the prebuilt server.

USER 1000:1000

HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=5 \
    CMD curl -f http://localhost:8080/health/ready || exit 1

EXPOSE 8080

# Use `start` (no --optimized flag) so the first boot runs through the
# Quarkus dev build path. Once the image is "warmed" the prebuilt server
# is cached at /opt/keycloak/lib/quarkus and subsequent restarts use it
# automatically. Using --optimized on the first ever start is rejected
# by Keycloak 26.x with: "The '--optimized' flag was used for first ever
# server start. Please don't use this flag for the first startup or use
# 'kc.sh build' to build the server first."
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
