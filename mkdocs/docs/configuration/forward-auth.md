You can enable support for authentication proxies such as Authelia, Authentik, etc.

This effectively disables credentials-based authentication and instead authenticates users if a specific request header contains a known username.
You must make sure that your proxy (nginx, Traefik, Caddy, ...) forwards this header from your auth proxy to Tube Archivist.
Check the documentation of your auth proxy and your reverse proxy on how to correctly set this up.

Warning:

If you've successfully authenticated using this method, you will not have administrative rights to the Dashboard. To fix this, you need to comment out the three environment variables, restart the instance, log in with the local account, and grant administrative rights to the automatically added user in the user management interface, which is located at `https://youriporfqdn.local/settings/user/`. After that, uncomment the previously commented variables, restart your instance again, you should now have administrative right on your next authentication.

Note that this automatically creates new users in the database if they do not already exist.

| Environment Variable  | Default   | Example   | Description   |
| :-------------------- | :-------- | :-------- | :------------ |
| `TA_LOGIN_AUTH_MODE`  | `single`  | `forwardauth` | Selects authentication backends. See potential values below. Overrides `TA_LDAP`/`TA_ENABLE_AUTH_PROXY`. |
| `TA_ENABLE_AUTH_PROXY` | `null` | `true` | *deprecated* (see below) Set to anything besides empty string to use forward proxy authentication. |
| `TA_AUTH_PROXY_USERNAME_HEADER`| `HTTP_REMOTE_USER` | `X-MYPROXY-USER` | The name of the request header that the auth proxy passes to the proxied application (**Tube Archivist** in this case), so that the application can identify the user. Check the documentation of your auth proxy to get this information.[^1][^2] |
| `TA_AUTH_PROXY_LOGOUT_URL` | `null` | | The URL that **Tube Archivist** should redirect to after a logout. By default, the logout redirects to the login URL, which means the user will be automatically authenticated again. Instead, you might want to configure the logout URL of the auth proxy here. |

[^1]:
    The request headers are rewritten within **Tube Archivist**: all HTTP headers are prefixed with `HTTP_`, all letters are in uppercase, and dashes are replaced with underscores. For example, for Authelia, which passes the `Remote-User` HTTP header, the `TA_AUTH_PROXY_USERNAME_HEADER` needs to be configured as `HTTP_REMOTE_USER`.

[^2]:
    For Authentik behind NPM Proxy Manager:

       1. Set the 'TA_AUTH_PROXY_USERNAME_HEADER' TO:
            - `TA_AUTH_PROXY_USERNAME_HEADER=X_AUTHENTIK_USERNAME` (without the HTTP_ prefix)
            - Please note that as of Tube Archivist >= 0.5.3, the forward authentication header name will be prefixed with `HTTP_` by Django, so you must omit it in `TA_AUTH_PROXY_USERNAME_HEADER`

       2. In NPM Proxy Manager in the advance tab of your Proxy host modify the default sections of the setup script that was pulled from your proxy provider that starts with: '# This section should be uncommented when the "Send HTTP Basic authentication" option is
          enabled in the proxy provider' with the following:

          THIS:
              # auth_request_set $authentik_auth $upstream_http_authorization;
              # proxy_set_header Authorization $authentik_auth;

         BECOMES THIS:
              # auth_request_set $authentik_username $upstream_http_x_authentik_username;
              # proxy_set_header X-Authentik-Username $authentik_username;

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

Set `forwardauth` to enable only forward auth / reverse proxy authentication.

See [LDAP](ldap.md) for information on the LDAP settings.
