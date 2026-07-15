# Deploy and Host Keycloak on Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/keycloak-1)

Keycloak is an open-source identity and access management (IAM) solution developed by Red Hat. It provides single sign-on (SSO), social login, OIDC/OAuth 2.0/SAML authentication, and centralized user management — deployed on Railway as two services: **Keycloak** + a sibling **PostgreSQL 16** database.

## About Hosting Keycloak on Railway

Keycloak gives you enterprise-grade authentication without the complexity of managing a dedicated identity infrastructure:

- **Single Sign-On** — authenticate once across all your applications
- **Protocol Support** — OIDC, OAuth 2.0, SAML 2.0, and LDAP federation
- **Social Login** — built-in support for Google, GitHub, Facebook, and more
- **User Federation** — sync users from LDAP/Active Directory
- **Centralized Management** — admin console for users, roles, and permissions
- **Railway-native** — one-click deploy, auto-generated admin secret, persistent Postgres volume

Deploying on Railway means automatic HTTPS, zero-config storage via the Postgres volume mount, and a sibling database service — no infrastructure setup required.

## Why Deploy Keycloak

- **Free & Open Source** — Apache 2.0 license, no licensing costs
- **Production-Ready** — used by enterprises worldwide, backed by Red Hat
- **Self-Hosted** — your data stays on your infrastructure, no third-party dependency
- **Extensible** — custom authenticators, event listeners, and themes
- **Automatic Secrets** — admin password and DB credentials generated on first deploy

## Common Use Cases

1. **Internal App Authentication** — secure your company's internal tools with a single login portal
2. **B2B SaaS Identity** — offer SSO and SAML/OIDC to your enterprise customers
3. **API Security** — protect REST APIs with OAuth 2.0 access tokens and PKCE flows
4. **Multi-App Ecosystem** — unify authentication across microservices with a shared identity provider

## Architecture

This template deploys **two services** in one project:

| Service | Base image | Role |
|---------|-----------|------|
| `keycloak` | `keycloak/keycloak:26.6.4` | Identity & access management |
| `postgres` | `postgres:16-alpine` | Persistent database |

Both services are connected via Railway's private network. The postgres service is created with a sibling-service pattern (a Dockerfile-based service) rather than the Railway Postgres plugin, to avoid the known `lost+found/` PGDATA crash that affects the plugin's `postgres-ssl:18` image.

### Why a sibling postgres service, not the plugin?

The Railway Postgres plugin (`postgres-ssl:18`) forces `PGDATA` to start with the volume mount path, which traps the ext4 `lost+found/` directory inside `PGDATA`. `initdb` then crashes on first marketplace deploy with `directory exists but is not empty`. The upstream `postgres:16-alpine` image has no such enforcement, and pairs cleanly with a parent-mount volume geometry (mount at `/var/lib/postgresql`, set `PGDATA=/var/lib/postgresql/data`).

## Dependencies

- A Railway account at <https://railway.app>
- Both services are pre-configured in the template — no manual setup required

## Configuration

The following environment variables can be configured via the Railway dashboard on the **keycloak** service tile:

| Variable | Default | Description |
|----------|---------|-------------|
| `KC_HOSTNAME` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL Keycloak generates links with (Keycloak 26.x: `KC_HOSTNAME`). Includes `https://` prefix because Railway terminates TLS upstream. |
| `KC_BOOTSTRAP_ADMIN_USERNAME` | `admin` | Initial admin username (Keycloak 26.x: replaces deprecated `KEYCLOAK_ADMIN`). |
| `KC_BOOTSTRAP_ADMIN_PASSWORD` | `${{secret(32)}}` | Initial admin password. Auto-generated on first deploy. After the admin user is created, changing this has no effect — use the Admin UI to rotate. |
| `KC_DB_URL` | `jdbc:postgresql://keycloak:keycloak_pw_2026@postgres.railway.internal:5432/keycloak` | PostgreSQL JDBC URL. The password (`keycloak_pw_2026`) MUST match `POSTGRES_PASSWORD` on the postgres tile. |
| `KC_DB_USERNAME` | `keycloak` | PostgreSQL username. Must match `POSTGRES_USER` on the postgres tile. |
| `KC_DB_PASSWORD` | `keycloak_pw_2026` | PostgreSQL password. Must match `POSTGRES_PASSWORD` on the postgres tile. |
| `KC_PROXY` | `edge` | Proxy mode: `edge` (Railway TLS), `passthrough`, or `reencrypt`. |
| `KC_PROXY_HEADERS` | `xforwarded` | Proxy headers handling (Keycloak 26.x: `KC_PROXY_HEADERS`). Set to `xforwarded` when behind a reverse proxy so Keycloak honors `X-Forwarded-*` headers. |
| `KC_HTTP_ENABLED` | `true` | Plain HTTP listener. Required when `KC_PROXY=edge`. |
| `KC_LOG_LEVEL` | `info` | Log verbosity: `info` \| `debug` \| `trace` \| `warn` \| `error` \| `fatal`. |

The **postgres** service tile has its own variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `POSTGRES_USER` | `keycloak` | Superuser. Must equal `KC_DB_USERNAME` on the keycloak tile. |
| `POSTGRES_PASSWORD` | `keycloak_pw_2026` | Superuser password. Must equal `KC_DB_PASSWORD` on the keycloak tile. |
| `POSTGRES_DB` | `keycloak` | Default database. |
| `PGDATA` | `/var/lib/postgresql/data` | Data directory. Must match the volume mount path (parent mount at `/var/lib/postgresql`). |

### Why are the passwords hardcoded?

Cross-service `${{...}}` macros (like `${{postgres.POSTGRES_PASSWORD}}`) **resolve to empty strings in marketplace deploys** — this is a confirmed Railway platform limitation. To keep both services in sync, the same literal password (`keycloak_pw_2026`) is set on both tiles. **If you change one, change the other.**

For production deployments, rotate the password by:

1. Updating `POSTGRES_PASSWORD` on the postgres tile
2. Updating `KC_DB_PASSWORD` AND `KC_DB_URL` on the keycloak tile to match
3. Redeploying both services

## After Deploy

1. Wait for both services to show **Online** status (Keycloak takes ~60–90s for the first start)
2. Open the Keycloak URL shown on the **keycloak** service tile
3. Log in with the admin credentials (the password is in the keycloak service's **Variables** tab → `KC_BOOTSTRAP_ADMIN_PASSWORD`)
4. Create your first realm and users

## Local Development

For local testing, run:

```bash
docker compose up  # not included — add a docker-compose.yml if needed
```

For Railway deployment from this directory:

```bash
railway link
railway up
```

## References

- Keycloak 26.x docs: <https://www.keycloak.org/documentation>
- Railway template docs: <https://docs.railway.app/reference/templates>
