As Cast doesn't support authentication for static files, you'll also need to set [`DISABLE_STATIC_AUTH`](../installation/env-vars.md#disable_static_auth) to disable authentication for your static files.

Enabling this integration will embed an additional third-party JS library from **Google**.  

**Requirements**:

 - HTTPS: To use the cast integration, HTTPS needs to be enabled. This can be done using a reverse proxy. This is a requirement from Google, as communication to the casting device is required to be encrypted, but the content itself is not.
 - Supported Browser: A supported browser is required for this integration, such as Google Chrome. Other browsers, especially Chromium-based browsers, may support casting by enabling it in the settings.
 - Subtitles: Subtitles are supported, however they do not work out of the box and require additional configuration. Due to requirements by Google, to use subtitles you need additional headers which will need to be configured in your reverse proxy. See this [page](https://developers.google.com/cast/docs/web_sender/advanced#cors_requirements) for the specific requirements.  
  - You need the following headers: `Content-Type`, `Accept-Encoding`, and `Range`. Note that the last two headers, `Accept-Encoding` and `Range`, are additional headers that you may not have needed previously.
  - Wildcards "*" can not be used for the `Access-Control-Allow-Origin` header. If the page has protected media content, it must use a domain instead of a wildcard.  