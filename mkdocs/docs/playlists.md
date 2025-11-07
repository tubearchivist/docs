---
description: Subscribe to playlists, browse your playlists and access additional metadata.
---

# Playlist Pages
Playlists are organized in two different levels, similar to [Channels](channels.md):

## Playlist Overview

!!! note
    There is an overlap in functionality with [index playlists on channel](channels.md/#about):

    - Subscribe to a playlist if the playlist contains videos from **various channels**.
    - Subscribe to a playlist if you only want to add **a few** playlists from a chanel.
    - Use [index playlists on channel](channels.md/#about) if you want to add **all** playlists of a channel.
    - Avoid subscribing to a playlist if the channel already monitors that playlist.

Accessible at `/playlist/` of your **Tube Archivist** instance, this **Overview Page** shows a list of all playlists you have indexed over all your channels.

- You can filter that list to show only subscribed playlists with the toggle.

You can index playlists of a channel from the [channel detail page](channels.md#about).

To add a playlist click on the <img src="/assets/icon-add.png?raw=true" alt="add icon" width="20px" style="margin:0 5px;"> button. There you can **Subscribe to Playlist**:

- Enter a [playlist](urls.md#playlist)

- Add one per line.

*or* you can **Create Custom Playlist**. That is a local only playlist. Add videos from their [video detail page](video.md).

You can search your indexed playlists by clicking on the search icon <img src="/assets/icon-search.png?raw=true" alt="search icon" width="20px" style="margin:0 5px;">. This will open a dedicated page.

## Playlist Detail

!!! note
    Playlist content is intented to be archived as is on YT. If the playlist owner on YT adds or removes a video from the playlist, that change will also be applied to the playlist in TA with the next metadata refresh task. If you want to decouple that, you can create a custom playlist local to your TA instance only or create your own playlists on YT.

Each playlist will get a dedicated playlist detail page accessible at `/playlist/<playlist-id>/` of your **Tube Archivist** instance. This page shows all the videos you have downloaded from this playlist.

- If you are subscribed to the playlist, an Unsubscribe button will show, otherwise the Subscribe button will show.
- The **Mark as Watched** and **Mark as Unwatched** buttons will mark all videos of this playlist as watched/unwatched.
- The **Reindex** button will reindex the playlist metadata.
- The **Reindex Videos** button will reindex all videos from this playlist.
- The **Switch sort order** toggle will change the sort order from top to bottom to bottom to top. This might be needed if you are subscribed to the playlists and the playlist owner adds new videos to the bottom.
- The **Delete Playlist** button will give you the option to delete just the *metadata*, which won't delete any media files, or *delete all*, which will delete the metadata plus all videos belonging to this playlist.