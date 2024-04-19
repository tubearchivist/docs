# Additional API endpoints

## Login
Return token and user ID for username and password:  
**POST** `/api/login/`
```json
{
    "username": "tubearchivist",
    "password": "verysecret"
}
```

after successful login returns 
```json
{
    "token": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "user_id": 1
}
```

## Refresh
**GET** `/api/refresh/`  

Parameters:

- **type**: one of *video*, *channel*, *playlist*, optional
- **id**: item id, optional

without specifying type: return total for all queued items:
```json
{
    "total_queued": 2,
    "type": "all",
    "state": "running"
}
```

specify type: return total items queue of this type:
```json
{
    "total_queued": 2,
    "type": "video",
    "state": "running"
}
```

specify type *and* id to get state of item in queue:
```json
{
    "total_queued": 2,
    "type": "video",
    "state": "in_queue",
    "id": "video-id"
}
```

**POST** `/api/refresh/`  

Parameter:

- extract_videos: to refresh all videos for channels/playlists, default False

Manually start a refresh task: post list of *video*, *channel*, *playlist* IDs:
```json
{
    "video": ["video1", "video2", "video3"],
    "channel": ["channel1", "channel2", "channel3"],
    "playlist": ["playlist1", "playlist2"]
}
```

## Cookie
Check your youtube cookie settings, *status* turns to `true` if cookie has been validated.  
**GET** `/api/cookie/`
```json
{
    "cookie_enabled": true,
    "status": true,
    "validated": 1680953715,
    "validated_str": "timestamp"
}
```

**POST** `/api/cookie/`  
Send empty post request to validate cookie.
```json
{
    "cookie_validated": true
}
```

**PUT** `/api/cookie/`  
Send put request containing the cookie as a string:
```json
{
    "cookie": "your-cookie-as-string"
}
```
Imports and validates cookie, returns on success:
```json
{
    "cookie_import": "done",
    "cookie_validated": true
}
```
Or returns status code 400 on failure:
```json
{
    "cookie_import": "fail",
    "cookie_validated": false
}
```

## Search
**GET** `/api/search/?query=<query>`  

Returns search results from your query.

## Watched
**POST** `/api/watched/`  

Change watched state, where the `id` can be a single video, or channel/playlist to change all videos belonging to that channel/playlist.

```json
{
    "id": "xxxxxxx",
    "is_watched": true
}
```

## Ping
Validate your connection and authentication with the API  
**GET** `/api/ping/`

When valid returns message with user id and TubeArchivist version: 
```json
{
    "response": "pong",
    "user": 1,
    "version": "v0.4.7"
}
```
