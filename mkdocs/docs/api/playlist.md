# Playlist

## Playlist List
**GET** `/api/playlist/`

Parameter:

- playlist_type: filter py playlist type.

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

**POST**: Update Playlist item, only valid for custom playlists

This expects an object with a key `video_id` to indicate the video in the playlist to modify and a key `action` to represent what to do. The action can be:

- `create`: Create a video entry in the playlist
- `remove`: Remove a video from the playlist
- `up`: Move a video up
- `down`: Move a video down
- `top`: Move a video to the top
- `bottom`: Move a video to the bottom

Delete playlist, metadata only:  
**DELETE** `/api/playlist/<playlist_id>/`  
Delete playlist, also delete all videos in playlist:  
**DELETE** `/api/playlist/<playlist_id>/?delete-videos=true`  


## Playlist Videos
**GET** `/api/playlist/<playlist_id>/video/`
