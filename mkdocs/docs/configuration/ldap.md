!!! warning "Your help is needed"
    This functionality is currently unmaintained. Please reach out if you are interested in taking over responsibility for maintaining this.

You can enable and configure LDAP with the following environment variables:

| Environment Variable  | Default   | Example   | Description   |
| :-------------------- | :-------- | :-------- | :------------ |
| `TA_LOGIN_AUTH_MODE`  | `single`  | `ldap_local` | Selects authentication backends. See potential values below. Overrides `TA_LDAP`/`TA_ENABLE_AUTH_PROXY`. |
| `TA_LDAP` | `false` | `true` | *deprecated* (see below) Set to anything besides empty string to use LDAP authentication **instead** of local user authentication. |
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
| `TA_LDAP_PROMOTE_USERNAMES_TO_SUPERUSER` | `null` | `alice,bob` | Comma separated list of users (matched based on TA_LDAP_USER_ATTR_MAP_USERNAME) which will automatically be promoted to superuser when they login. Users given superuser access will also be given staff permissions. |
| `TA_LDAP_PROMOTE_USERNAMES_TO_STAFF` | `null` | `lisa,tom` | Comma separated list of users (matched based on TA_LDAP_USER_ATTR_MAP_USERNAME) which will automatically be promoted to staff when they login. |

## Auth Login Modes

| Value         | Behavior |
| :------------ | :------- |
| `single`      | backwards-compatibility mode, uses a single auth backend based on deprecated flags |
| `local`       | use only local Django database backend for user authentication |
| `ldap`        | use only ldap remote backend for user authentication |
| `forwardauth` | use only forward auth backend |
| `ldap_local`  | use ldap remote and local Django database backends together |

If the value of `TA_LOGIN_AUTH_MODE` is empty or set to `single` the existing flags (`TA_LDAP`/`TA_ENABLE_AUTH_PROXY`) select the backend, or the local Django backend is used. Eventually these flags should be removed and only `TA_LOGIN_AUTH_MODE` should be used for selection, but this change currently will not impact any existing deployments.

Using `local` overrides the other flags (`TA_LDAP`/`TA_ENABLE_AUTH_PROXY`) and uses only the local database backend for users and groups.

Most LDAP users should probably use the new `ldap_local` mode, which allows LDAP users to login, but also allows logging in as any locally defined user, including the one defined as an admin using `TA_USERNAME` and `TA_PASSWORD`. Having access to this admin user makes it much easier to promote LDAP logins to staff or superuser roles using the user admin screens.

For installations which require secure enforcement of LDAP-only credentials, use the `ldap`-only value after properly configuring one or more administrator users.

### Lack of privileges on new accounts

LDAP modes automatically create new users in the database if they do not already exist.

If those accounts are  successfully authenticated using this method, they will not have administrative rights to the Dashboard (including ability to add downloads). There are two options for providing LDAP users permissions for downloading videos or performing user administration:
- Use `ldap_local` mode and add privileges as described in the next section.
- Use `TA_LDAP_PROMOTE_USERNAMES_TO_SUPERUSER` and `TA_LDAP_PROMOTE_USERNAMES_TO_STAFF` to configure TA to promote known usernames to have additional privileges when they first login.

The `TA_LDAP_PROMOTE_USERNAMES_*` settings are based on the username matched in the `TA_LDAP_USER_ATTR_MAP_USERNAME` setting. Some configurations may allow a user to login with multiple alternative "usernames" based on LDAP attributes, but only the matched username will be promoted.

### LDAP + Local Considerations

- When using `ldap_local` mode:
  - Users can log in with credentials from either system
  - Shared usernames can use either password, so weak passwords in either store can be compromising
  - Local database accounts can be created to manage LDAP user privileges

Hardening Workflow:
  1. Use `ldap_local` during initial setup
  2. Login as LDAP user(s) to initialize the local database with their username
  3. Login as local admin user and assign privileges to the automatically added LDAP user in the user management interface, which is located at `https://youriporfqdn.local/settings/user/`
  4. Switch to `ldap` mode for production
