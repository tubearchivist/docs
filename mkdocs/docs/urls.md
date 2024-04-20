---
description: How URLs from YouTube get parsed
---

# URLs
This document describes how **Tube Archivist** identifies and treats links from YouTube.

!!! info
    Application logic of **Tube Archivist** is tied only to the IDs, not the names.

## Video
A video ID is **11** characters long, e.g. `2tdiKTSdE9Y`.

Urls can have several forms:

| URL Type | Example | Description |
| :------- | :------ | :---------- |
| Watch URL | `https://www.youtube.com/watch?v=2tdiKTSdE9Y` | Regular URLs you will see while browsing YouTube, with the path */watch* and a *v* parameter |
| Share URL | `https://youtu.be/2tdiKTSdE9Y` | Link you will get when you click on *share* on a video |
| Shorts URL | `https://www.youtube.com/shorts/U80grnZJm_8` | Video links for YouTube shorts |

## Channel
A channel ID is **24** characters long, e.g. `UCBa659QWEk1AI4Tg--mrJ2A`.

Channel URLs can have these forms, all will get translated to the ID:

| URL Type | Example | Description |
| :------- | :------ | :---------- |
| ID URL | `https://www.youtube.com/channel/UCBa659QWEk1AI4Tg--mrJ2A` | With a *channel* path |
| Channel Handle | `@TomScottGo` | Starting with a `@` this handle is personal and unique |
| Alias URL | `https://www.youtube.com/@TomScottGo` | Based off the channel handle |

### Channel subpages
**Tube Archivist** can differentiate between the primary subpages:

- Videos only: `https://www.youtube.com/@IBRACORP/videos`
- Shorts only: `https://www.youtube.com/@IBRACORP/shorts`
- Streams only: `https://www.youtube.com/@IBRACORP/streams`
- Every other channel sub page will default to download all, for example `https://www.youtube.com/@IBRACORP/featured` will download videos and shorts and streams.

## Playlist
A playlist ID can be `34`, `26` or `18` characters long, e.g. `PL96C35uN7xGLLeET0dOWaKHkAlPsrkcha`

| URL Type | Example | Description |
| :------- | :------ | :---------- |
| Playlist URL | `https://www.youtube.com/playlist?list=PL96C35uN7xGLLeET0dOWaKHkAlPsrkcha` | Playlist URLs start with a *playlist* path and have a *list* parameter |

### Playlist vs Video URLs
While browsing YouTube videos in Playlists, you might encounter URLs looking like this: `https://www.youtube.com/watch?v=QPZ0pIK_wsc&list=PL96C35uN7xGLLeET0dOWaKHkAlPsrkcha`. As established above, based on the */watch* path and the *v* parameter, **Tube Archivist** will treat this as a video with the ID `QPZ0pIK_wsc` and **not** as a playlist. If you mean the playlist, you can easily grab the correct ID from the URL, e.g. `PL96C35uN7xGLLeET0dOWaKHkAlPsrkcha`.
