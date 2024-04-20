You can enable support for authentication proxies such as Authelia.

This effectively disables credentials-based authentication and instead authenticates users if a specific request header contains a known username.
You must make sure that your proxy (nginx, Traefik, Caddy, ...) forwards this header from your auth proxy to Tube Archivist.
Check the documentation of your auth proxy and your reverse proxy on how to correctly set this up.

Note that this automatically creates new users in the database if they do not already exist.

| Environment Variable | Example | Description |
| :------------------- | :------ | :---------- |
| `TA_ENABLE_AUTH_PROXY` | `true` | Set to anything besides empty string to use forward proxy authentication. |
| `TA_AUTH_PROXY_USERNAME_HEADER` | `HTTP_REMOTE_USER` | The name of the request header that the auth proxy passes to the proxied application (**Tube Archivist** in this case), so that the application can identify the user. Check the documentation of your auth proxy to get this information.[^1] |
| `TA_AUTH_PROXY_LOGOUT_URL` | | The URL that **Tube Archivist** should redirect to after a logout. By default, the logout redirects to the login URL, which means the user will be automatically authenticated again. Instead, you might want to configure the logout URL of the auth proxy here. |
[^1]:
    The request headers are rewritten within **Tube Archivist**: all HTTP headers are prefixed with `HTTP_`, all letters are in uppercase, and dashes are replaced with underscores.For example, for Authelia, which passes the `Remote-User` HTTP header, the `TA_AUTH_PROXY_USERNAME_HEADER` needs to be configured as `HTTP_REMOTE_USER`. 