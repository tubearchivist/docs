As Cast doesn't support authentication, enabling this functionality will make your static files like artwork and media files accessible by guessing the links. That's read only access, the application itself is still protected.

Enabling this integration will embed an additional third party JS library from **Google**.  

**Requirements**:

 - HTTPS: To use the cast integration HTTPS needs to be enabled, which can be done using a reverse proxy. This is a requirement by Google as communication to the cast device is required to be encrypted, but the content itself is not.
 - Supported Browser: A supported browser is required for this integration such as Google Chrome. Other browsers, especially Chromium-based browsers, may support casting by enabling it in the settings.
 - Subtitles: Subtitles are supported however they do not work out of the box and require additional configuration. Due to requirements by Google, to use subtitles you need additional headers which will need to be configured in your reverse proxy. See this [page](https://developers.google.com/cast/docs/web_sender/advanced#cors_requirements) for the specific requirements.  
  - You need the following headers: `Content-Type`, `Accept-Encoding`, and `Range`. Note that the last two headers, `Accept-Encoding` and `Range`, are additional headers that you may not have needed previously.  
  - Wildcards "*" can not be used for the `Access-Control-Allow-Origin` header. If the page has protected media content, it must use a domain instead of a wildcard.  