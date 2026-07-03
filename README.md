[![](https://railway.com/button/deploy.svg)](https://railway.app/template/TEMPLATE_CODE)\n\n## Dependencies for Keycloak template on Railway.app

- A Railway account at railway.app
- PostgreSQL database service (Railway Provisioned Postgres recommended)
- Minimum 512MB RAM for container

### Deployment Dependencies

- KEYCLOAK_ADMIN_USERNAME: Admin username (default: admin)
- KEYCLOAK_ADMIN_PASSWORD: Password >= 12 chars
- DB_TYPE: Database engine (postgres or sqlite, default: postgres)
- KC_PROXY: Proxy mode (edge for Railway TLS termination, default: edge)
- KC_HTTP_ENABLED: Enable HTTP mode (true/false, default: true)

---
