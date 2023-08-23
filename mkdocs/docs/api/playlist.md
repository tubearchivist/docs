# Playlist

## Playlist List
**GET** `/api/playlist/`

Subscribe/Unsubscribe to a list of playlists:  
**POST** `/api/playlist/`
```json
{
    "data": [
        {"playlist_id": "PL96C35uN7xGLLeET0dOWaKHkAlPsrkcha", "playlist_subscribed": true}
    ]
}
```

## Playlist Item
**GET** `/api/playlist/<playlist_id>/`

Delete playlist, metadata only:  
**DELETE** `/api/playlist/<playlist_id>/`  
Delete playlist, also delete all videos in playlist:  
**DELETE** `/api/playlist/<playlist_id>/?delete-videos=true`  


## Playlist Videos
**GET** `/api/playlist/<playlist_id>/video/`
