Tube Archivist can authenticate users against any OpenID Connect (OIDC)
provider — Authentik, Keycloak, Auth0, Google, etc. — giving a real "Log in
with SSO" button next to (or instead of) the local login form.

You enable and configure OIDC with the following environment variables:

| Environment Variable  | Default   | Example   | Description   |
| :-------------------- | :-------- | :-------- | :------------ |
| `TA_LOGIN_AUTH_MODE`  | `single`  | `oidc_local` | Selects authentication backends. Use `oidc` or `oidc_local` (see below). |
| `TA_OIDC_CLIENT_ID`   | `null`    | `tubearchivist` | Client ID of the OIDC application registered at your provider. |
| `TA_OIDC_CLIENT_SECRET` | `null`  | `yoursecret` | Client secret for the (confidential) OIDC application. |
| `TA_OIDC_AUTHORIZATION_ENDPOINT` | `null` | `https://idp.example.com/application/o/authorize/` | Provider authorization endpoint. |
| `TA_OIDC_TOKEN_ENDPOINT` | `null` | `https://idp.example.com/application/o/token/` | Provider token endpoint. |
| `TA_OIDC_USER_ENDPOINT` | `null`  | `https://idp.example.com/application/o/userinfo/` | Provider userinfo endpoint. |
| `TA_OIDC_JWKS_ENDPOINT` | `null`  | `https://idp.example.com/application/o/tubearchivist/jwks/` | Provider JWKS endpoint, used to verify the `id_token` signature. |
| `TA_OIDC_SCOPES`      | `openid profile email groups` | `openid profile email` | Space-separated scopes to request. |
| `TA_OIDC_SIGN_ALGO`   | `RS256`   | `RS256`   | Signing algorithm of the `id_token`. |
| `TA_OIDC_USERNAME_CLAIM` | `preferred_username` | `preferred_username` | Claim used as the Tube Archivist account name. Falls back to `sub`. |
| `TA_OIDC_GROUPS_CLAIM` | `groups` | `groups` | Claim that holds the user's group memberships. |
| `TA_OIDC_ADMIN_GROUP` | `null`    | `tubearchivist-admins` | Members of this group are promoted to **superuser** (implies staff) on login. |
| `TA_OIDC_STAFF_GROUP` | `null`    | `tubearchivist-staff` | Members of this group are promoted to **staff** on login. |
| `TA_OIDC_CREATE_USER` | `true`    | `false`   | Auto-create unknown users on their first login. Set `false` to only allow pre-existing accounts. |
| `TA_OIDC_BUTTON_LABEL` | `Log in with SSO` | `Log in with Authentik` | Text shown on the SSO button. |

The client secret can also be supplied from a file with `TA_OIDC_CLIENT_SECRET_FILE` (see [secret files](../installation/docker-compose.md)).

## Auth Login Modes

OIDC adds two values to `TA_LOGIN_AUTH_MODE`:

| Value         | Behavior |
| :------------ | :------- |
| `oidc`        | OIDC only. The local username/password form is hidden — SSO is the only way in. |
| `oidc_local`  | OIDC and local Django backends together. Shows both the SSO button and the local form. |

Use **`oidc_local`** for most setups: it keeps a break-glass local admin (the
one defined by `TA_USERNAME`/`TA_PASSWORD`) usable alongside SSO, which makes it
easy to recover if the identity provider is unavailable and to promote SSO users
from the user management screen. Switch to **`oidc`** once SSO is proven, for
SSO-only enforcement.

API token authentication (the browser extension and mobile app) is unaffected
by either mode and continues to work.

## Identity provider setup

Create one **confidential** OIDC/OAuth2 application at your provider with:

- **Redirect URI**: `<TA_HOST>/api/oidc/callback/` — e.g.
  `https://tubearchivist.example.com/api/oidc/callback/` (exact match, trailing
  slash included). The redirect is derived from `TA_HOST`, so set `TA_HOST`
  correctly when running behind a reverse proxy.
- **Grant type / flow**: Authorization Code (with PKCE — Tube Archivist sends
  `S256`).
- **Scopes**: `openid`, `profile`, `email`. Group membership for
  `TA_OIDC_ADMIN_GROUP`/`TA_OIDC_STAFF_GROUP` is read from the `groups` claim,
  which most providers include in the `profile` scope.

Copy the client ID, client secret, and the four endpoints into the variables
above. With Authentik the endpoints follow
`https://<authentik>/application/o/authorize|token|userinfo/` (global) and
`https://<authentik>/application/o/<application-slug>/jwks/` (per-application).

## Group based privileges

New OIDC users are created without administrative rights (no dashboard access /
downloads). To grant them automatically, set `TA_OIDC_ADMIN_GROUP` (and/or
`TA_OIDC_STAFF_GROUP`) and put the user in that group at your provider — they
are promoted on their next login. Like the LDAP backend this is **promote-only**
(it never removes a manually granted role).

Alternatively run `oidc_local`, log in once as the SSO user to create their
local account, then log in as the local admin and assign privileges in the user
management screen at `https://youriporfqdn.local/settings/user/`.
