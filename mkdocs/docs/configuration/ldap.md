You can configure LDAP with the following environment variables:

 - `TA_LDAP` (ex: `true`) Set to anything besides empty string to use LDAP authentication **instead** of local user authentication.
 - `TA_LDAP_SERVER_URI` (ex: `ldap://ldap-server:389`) Set to the uri of your LDAP server.
 - `TA_LDAP_DISABLE_CERT_CHECK` (ex: `true`) Set to anything besides empty string to disable certificate checking when connecting over LDAPS.
 - `TA_LDAP_BIND_DN` (ex: `uid=search-user,ou=users,dc=your-server`) DN of the user that is able to perform searches on your LDAP account.
 - `TA_LDAP_BIND_PASSWORD` (ex: `yoursecretpassword`) Password for the search user.
 - `TA_LDAP_USER_ATTR_MAP_USERNAME` (default: `uid`) Bind attribute used to map LDAP user's username
 - `TA_LDAP_USER_ATTR_MAP_PERSONALNAME` (default: `givenName`) Bind attribute used to match LDAP user's First Name/Personal Name.
 - `TA_LDAP_USER_ATTR_MAP_SURNAME` (default: `sn`) Bind attribute used to match LDAP user's Last Name/Surname.
 - `TA_LDAP_USER_ATTR_MAP_EMAIL` (default: `mail`) Bind attribute used to match LDAP user's EMail address
 - `TA_LDAP_USER_BASE` (ex: `ou=users,dc=your-server`) Search base for user filter.
 - `TA_LDAP_USER_FILTER` (ex: `(objectClass=user)`) Filter for valid users. Login usernames are matched using the attribute specified in `TA_LDAP_USER_ATTR_MAP_USERNAME` and should not be specified in this filter.

When LDAP authentication is enabled, django passwords (e.g. the password defined in TA_PASSWORD), will not allow you to login, only the LDAP server is used.