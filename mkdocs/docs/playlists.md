---
description: Subscribe to playlists, browse your playlists and access additional metadata.
---

# Playlist Pages
Playlists are organized in two different levels, similar to [Channels](channels.md):

## Playlist Overview
Accessible at `/playlist/` of your **Tube Archivist** instance, this **Overview Page** shows a list of all playlists you have indexed over all your channels.

- You can filter that list to show only subscribed playlists with the toggle.

You can index playlists of a channel from the [channel detail page](channels.md#about).

To add a playlist click on the <img src="/assets/icon-add.png?raw=true" alt="add icon" width="20px" style="margin:0 5px;"> button. There you can **Subscribe to Playlist**:

- Enter a [playlist](urls.md#playlist)

- Add one per line.

*or* you can **Create Custom Playlist**. That is a local only playlist. Add videos from their [video detail page](video.md).


!!! note
    It doesn't make sense to subscribe to a playlist if you are already subscribed to the corresponding channel as this will slow down the **Rescan Subscriptions** [task](downloads.md#rescan-subscriptions).

You can search your indexed playlists by clicking on the search icon <img src="/assets/icon-search.png?raw=true" alt="search icon" width="20px" style="margin:0 5px;">. This will open a dedicated page.

## Playlist Detail
Each playlist will get a dedicated playlist detail page accessible at `/playlist/<playlist-id>/` of your **Tube Archivist** instance. This page shows all the videos you have downloaded from this playlist.

- If you are subscribed to the playlist, an Unsubscribe button will show, otherwise the Subscribe button will show.
- The **Mark as Watched** and **Mark as Unwatched** buttons will mark all videos of this playlist as watched/unwatched.
- The **Reindex** button will reindex the playlist metadata.
- The **Reindex Videos** button will reindex all videos from this playlist.
- The **Delete Playlist** button will give you the option to delete just the *metadata*, which won't delete any media files, or *delete all*, which will delete the metadata plus all videos belonging to this playlist.