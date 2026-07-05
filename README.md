# Deploy and Host Keycloak on Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/railway-keycloak)

## About Hosting — What Keycloak Does

Keycloak is a comprehensive open-source identity and access management (IAM) solution that provides enterprise-grade authentication and authorization services out of the box. It enables secure single sign-on (SSO), user federation, social login integration, and advanced security features for your applications without building them from scratch.

### Key Functionalities
- **Single Sign-On (SSO)** – Users authenticate once to access multiple interconnected applications securely.
- **OIDC & SAML Support** – Standards-based protocol support for seamless modern authentication flows.
- **Social Login Integration** – Built-in connectors for Google, GitHub, Facebook, Microsoft Azure AD, LinkedIn, and more.
- **User Federation** – Connects with LDAP/Active Directory or other external identity providers to unify user directories.
- **Password-less Authentication** – Native support for WebAuthn, FIDO2 standards, and magic link authentication.
- **Fine-grained Authorization** – Role-based (RBAC) and attribute-based (ABAC) access control policies.
- **Event Listeners & Realms** – Isolates tenants, applications, and provides customizable hooks for advanced workflows.

### Why Railway is Ideal for Keycloak
Deploying Keycloak on Railway simplifies infrastructure management while maximizing reliability:
- **Zero Infrastructure Maintenance** – No servers to provision, patch, update, or scale manually.
- **Automatic HTTPS/TLS Termination** – Secure communication established by default with minimal configuration.
- **Seamless Scale-to-Zero & Auto-resume** – Highly cost-effective for development and test environments.
- **Managed Databases** – Easily attach a PostgreSQL companion database for robust, persistent identity storage.
- **Secure Secrets Management** – Environment variables are handled securely within the Railway platform.

---

## Why Deploy Keycloak

Keycloak delivers enterprise IAM capabilities without the complexity or vendor lock-in of proprietary solutions:

| Feature | Benefit |
|---------|---------|
| **Open Source & Self-hosted** | Complete control over your identity infrastructure; no licensing fees or vendor dependency. |
| **Protocol Agnostic** | Supports OIDC, SAML 2.0, LDAP, and OAuth 2.1 within a single unified platform. |
| **Highly Customizable UI** | Fully branded login pages that match your application's design system perfectly. |
| **Granular Authorization** | Enforce client-specific roles, dynamic resource policies, and sophisticated access rules. |
| **Production-Ready HA** | Designed for clustering to achieve high availability and horizontal scalability. |
| **Docker-Native Container** | Simple deployment via Docker Compose or orchestration platforms like Kubernetes. |
| **Vibrant Community Ecosystem** | Mature project with extensive documentation, plugins, and active support. |

In short, Keycloak on Railway provides a cost-effective, powerful identity layer that lets you focus on building your application logic rather than managing security infrastructure.

---

## Common Use Cases

### 1. SaaS Multi-Tenant Authentication
Build secure, isolated authentication for each organization in your SaaS platform. Assign unique tenants with custom roles, branded login pages, and federated identities from Microsoft AD or Google Workspace.

### 2. Enterprise Single Sign-On (SSO)
Consolidate access to internal tools via a central portal. Sync with corporate Active Directory through LDAP, enforce MFA policies, and support SAML SSO for legacy applications.

### 3. Microservices Authorization Gateway
Act as the central authentication hub for your microservices architecture. Each service consumes OIDC/OAuth2 tokens from Keycloak, enforcing authorization at the API layer while reducing security code duplication.

### 4. Customer Identity & Access Management (CIAM)
Provide a scalable identity layer for customer-facing applications with millions of users. Features like social linking, profile management APIs, password-less onboarding, and advanced consent flows cater to modern user expectations.

Other scenarios include federated identity for distributed teams, legacy application security without code modifications, and building custom authentication pipelines via Service Provider Interfaces (SPIs).

---

## Dependencies for Running This Template

- **Railway Container Hosting** – Any plan supporting Docker containers.
- **Companion PostgreSQL Database** – Highly recommended for production use. Attach a Railway PostgreSQL add-on or your own external Postgres instance. SQLite is supported but not suitable for high-scale deployments.
- **Environment Variables** – All required variables from the Configuration section must be defined before first deployment to ensure correct runtime behavior.

---

## Configuration — Reference .env.example Variables

Set these environment variables via Railway's dashboard or your local Docker setup:

| Variable | Description | Default | Notes |
|----------|-------------|---------|-------|
| `DB_TYPE` | Database engine to use (`postgres` or `sqlite`) | `postgres` | Use `postgres` for production. |
| `PG_HOSTNAME` | PostgreSQL host address (when DB_TYPE=postgres) | — | Set via Railway companion service. |
| `PG_PORT` | Port for Postgres database | `5432` | Standard Postgres port. |
| `PG_DATABASE` | Name of the Keycloak database | `keycloak` | Database should exist before deployment. |
| `PG_USERNAME` | Username for Keycloak DB connection | `keycloak` | User must have proper permissions. |
| `PG_PASSWORD` | Password for the DB user | — | Use strong passwords in production. |
| `KEYCLOAK_ADMIN_USERNAME` | Initial admin console username | `admin` | Used to access the Admin Console. |
| `KEYCLOAK_ADMIN_PASSWORD` | Initial admin password (minimum 12 characters) | `changeme123456789` | **Change immediately after first login.** |
| `KC_PROXY` | Proxy header mode (`edge` or `passthrough`) | `edge` | Railway terminates TLS at the edge; use `edge`. |
| `KC_HTTP_ENABLED` | Enable HTTP vs HTTPS mode (`true`/`false`) | `false` | Set to `false` when using reverse proxy with TLS. |
| `KEYCLOAK_HOSTNAME` | Public hostname (domain, without scheme) of your instance | — | Must be configured before first login. |

For production deployments, always configure a strong admin password and verify your hostname prior to the initial login to prevent issuer URL configuration issues.

---

*This README provides an overview of deploying Keycloak on Railway. For advanced configuration details, please consult the [official Keycloak documentation](https://www.keycloak.org/documentation.html).