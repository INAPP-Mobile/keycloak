# Keycloak — Open Source Identity & Access Management

Deploy [Keycloak](https://github.com/keycloak/keycloak) on Railway with a single click. Keycloak is an enterprise-grade identity and access management solution for modern applications and services, supporting OIDC, SAML 2.0, social login, and role-based authorization.

## About Hosting on Railway

This template runs Keycloak in standalone mode using embedded file-based storage (no external database required). Perfect for development, proof-of-concepts, or lightweight deployments where simplicity outweighs horizontal scalability needs.

**Key features:**
- Single-container deployment — no sidecar databases
- OIDC & SAML authentication providers
- Role-based access control (RBAC)
- User federation with LDAP/Active Directory
- Event listener and admin REST APIs
- Automatic port binding to Railway's `PORT` variable (8080)

## Dependencies for Keycloak

This template runs as a single-container application. No additional Railway services are required for the default configuration.

### Deployment Dependencies

None — Keycloak uses embedded file-based storage by default for standalone operation. For production workloads, connect PostgreSQL as your database:

1. Add a [PostgreSQL](https://railway.new/template) service to your project
2. Set `KC_DB=postgres` and configure database URL via environment variables

## Variables

| Variable | Description | Type | Required | Default |
|----------|-------------|------|----------|---------|
| KEYCLOAK_HOSTNAME | Public hostname used by Keycloak (e.g. your-app.up.railway.app). Set from Railway dashboard after deployment. | `text` | Yes | — |
| KEYCLOAK_ADMIN_PASSWORD | Admin password for the initial Keycloak admin account. Must be at least 12 characters. Change immediately after first login. | `secret(64)` | Yes | `changeme123456` |

## Deployment Guide

### 1-Click Deploy

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/template/{{ template_code }})

### Manual Setup

1. Click "New Project" on [Railway.app](https://railway.app)
2. Select "Import from Git Repository" and connect this repo
3. Railway automatically detects the Dockerfile and begins building
4. After build completes, go to **Environment → Variables** in your project dashboard:
   - Set `KEYCLOAK_HOSTNAME` to your project URL (e.g., `https://your-project.up.railway.app`)
   - Set `KEYCLOAK_ADMIN_PASSWORD` to a secure password (minimum 12 characters)

### Verification

Once deployed, verify Keycloak is running:

```bash
curl https://<your-keycloak-url>/health/ready
# Expected: {"status":"UP"}
```

Access the admin console: `https://<your-hostname>/admin`

## Database Migration (Standalone → Production)

Keycloak's embedded file storage is sufficient for development but **not recommended** for production. To migrate to PostgreSQL:

1. Add PostgreSQL service via Railway's marketplace
2. Update your Keycloak environment variables:
   ```bash
   KC_DB=postgres
   KC_DB_URL=jdbc:postgresql://<pg-host>:5432/<db-name>
   KC_DB_USERNAME=<username>
   KC_DB_PASSWORD=<password>
   KC_DB_SCHEMA=public
   ```

## Security Considerations

- **Change default admin password immediately** on first login
- Always set `KEYCLOAK_HOSTNAME` to your actual domain
- For HTTPS in production, configure SSL certificates via Railway's managed TLS or a reverse proxy
- Never commit `.env` files containing secrets
- Enable audit logging and review Keycloak's security best practices

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Health check fails at deploy | Wait 120s — Keycloak needs time for initialization on first deploy |
| Admin login returns 403 | Verify `KEYCLOAK_HOSTNAME` is set to your actual Railway project URL |
| Session expires after reboot | Embedded storage resets data. Use PostgreSQL for persistent sessions. |

## Resources

- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [Keycloak Docker Examples](https://github.com/keycloak/keycloak/tree/main/quarkus/confguration#docker)
- [Railway Documentation](https://docs.railway.app/)
- [OIDC Specification](https://openid.net/specs/openid-connect-core-1_0.html)
