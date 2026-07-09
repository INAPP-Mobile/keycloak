# =============================================================================
# Dockerfile: Sibling PostgreSQL service for Keycloak template
# Base image:  https://hub.docker.com/_/postgres
# License:     PostgreSQL License (BSD-style)
# =============================================================================
#
# Why this exists instead of using the Railway Postgres plugin:
#   The plugin (postgres-ssl:18) forces PGDATA to start with the volume
#   mount path, which traps the ext4 `lost+found/` directory inside PGDATA.
#   initdb then crashes on first marketplace deploy with:
#     "initdb: error: directory exists but is not empty"
#
#   The upstream postgres:16-alpine image has no such path enforcement.
#   We pair it with a parent-mount volume geometry (configured via the
#   Railway template editor's Volume widget): mount the volume at the
#   PARENT path `/var/lib/postgresql` and set PGDATA=/var/lib/postgresql/data.
#   The volume's `lost+found/` then lives at `/var/lib/postgresql/lost+found`
#   — outside PGDATA — and initdb sees an empty data directory.
#
# User / Password / Database are set via the template deploy form
# (POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB env vars). The credentials
# must match KC_DB_USERNAME / KC_DB_PASSWORD on the Keycloak service —
# cross-service ${{...}} macros resolve empty in marketplace deploys, so we
# hardcode a known password (keycloak_pw_2026) on both tiles.

FROM postgres:16-alpine
