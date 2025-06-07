You can enable and configure LDAP with the following environment variables:

| Environment Variable  | Default   | Example   | Description   |
| :-------------------- | :-------- | :-------- | :------------ |
| `TA_LDAP` | `false` | `true` | Set to anything besides empty string to use LDAP authentication **instead** of local user authentication. |
| `TA_LDAP_SERVER_URI`  | `null` | `ldap://ldap-server:389` | Set to the uri of your LDAP server. |
| `TA_LDAP_DISABLE_CERT_CHECK` | `null` | `true` | Set to anything besides empty string to disable certificate checking when connecting over LDAPS. |
| `TA_LDAP_BIND_DN` | `null` | `uid=search-user,ou=users,dc=your-server` | DN of the user that is able to perform searches on your LDAP account. |
| `TA_LDAP_BIND_PASSWORD` | `null` | `yoursecretpassword` | Password for the search user. |
| `TA_LDAP_USER_ATTR_MAP_USERNAME`  | `uid` | `uid` | Bind attribute used to map LDAP user's username |
| `TA_LDAP_USER_ATTR_MAP_PERSONALNAME` | `givenName` |`givenName` | Bind attribute used to match LDAP user's First Name/Personal Name. |
| `TA_LDAP_USER_ATTR_MAP_SURNAME` | `sn` |`sn` | Bind attribute used to match LDAP user's Last Name/Surname. |
| `TA_LDAP_USER_ATTR_MAP_EMAIL` | `mail` |`mail` | Bind attribute used to match LDAP user's EMail address |
| `TA_LDAP_USER_BASE` | `null` | `ou=users,dc=your-server` | Search base for user filter. |
| `TA_LDAP_USER_FILTER` | `null` | `(objectClass=user)` | Filter for valid users. Login usernames are matched using the attribute specified in `TA_LDAP_USER_ATTR_MAP_USERNAME` and should not be specified in this filter. |
| `TA_LOGIN_AUTH_MODE` | `ldap` | `ldap_local` | Selects authentication backends. Valid values: `ldap` (LDAP only), `local` (local database only), `ldap_local` (both active). Overrides `TA_LDAP`/`TA_ENABLE_AUTH_PROXY`. |

**Important Notes:**
- When using `ldap_local` mode:
  - Users can log in with credentials from either system
  - Shared usernames can use either password (consider password policy alignment)
  - Local database accounts can be created to manage LDAP user privileges
- Recommended workflow:
  1. Use `ldap_local` during initial setup
  2. Create local admin accounts
  3. Assign privileges to LDAP users via the admin interface
  4. Switch to `ldap` mode for production

When using LDAP authentication, the `TA_LOGIN_AUTH_MODE` setting controls backend behavior:
- `ldap`: Only LDAP authentication
- `ldap_local`: Both LDAP and local database authentication (allows using either backend's credentials)
The `TA_USERNAME`/`TA_PASSWORD` credentials provide admin access when `ldap_local` is active.
