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

While LDAP authentication is enabled, the django-managed passwords (e.g. the password defined in TA_PASSWORD), will not allow you to login. Only the LDAP server is used for authentication.