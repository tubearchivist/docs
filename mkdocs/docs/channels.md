---
description: Subscribe to channels, browse your channels and access additional metadata.
---

# Channels Pages

The channels are organized on two different levels, similar to the [playlists](playlists.md):

## Channels Overview
Accessible at `/channel/` of your Tube Archivist, the **Overview Page** shows a list of all channels you have indexed. 

- You can filter that list to show or hide subscribed channels with the toggle. Clicking on the channel banner or the channel name will direct you to the *Channel Detail Page*.
- If you are subscribed to a channel an *Unsubscribe* button will show, if you aren't subscribed, a *Subscribe* button will show instead. 

The **Subscribe to Channels** button <img src="/assets/icon-add.png?raw=true" alt="add icon" width="20px" style="margin:0 5px;"> opens a text field to subscribe to a channel. You have a few options:

- Enter a [channel](urls.md#channel).
- Enter a [video](urls.md#video) and let Tube Archivist extract the channel ID for you.
- Add one per line.

To search your channels, click on the search icon <img src="/assets/icon-search.png?raw=true" alt="search icon" width="20px" style="margin:0 5px;"> to reach the search page. Start your query with `channel:`, learn more on the [search](search.md) page.

## Channel Detail
Each channel gets a set of channel detail pages.

- If you are subscribed to the channel, an *Unsubscribe* button will show, else the *Subscribe* button will show.
- You'll see some statistics of the channel, like how many videos you have, total playback and total size. That aggregation is based your filter, e.g. if you toggle *Hide watched*, the aggregation will be over your unwatched videos only.
- The **Mark as Watched** and **Mark as Unwatched** buttos will mark all videos of this channel as watched/unwatched.

### Videos
Accessible at `/channel/<channel-id>/`, this page shows all the videos you have downloaded from this channel.

### Streams
If you have any streams indexed, this page will become accessible at `/channel/<channel-id>/streams/`, this page shows all available live streams of that channel. 

### Shorts
If you have any shorts videos indexed, this page will become accessible at `/channel/<channel-id>/shorts/`, this page shows all the shorts videos of that channel.

### Playlists
If you have playlists from this channel indexed, this page will become accessible at `/channel/<channel-id>/playlist/`. Activate channel playlist indexing on the about page.

### About
On the *Channel About* page, accessible at `/channel/<channel-id>/about/`, you can see additional metadata.

- The button **Delete Channel** will delete the channel plus all videos of this channel, both media files and metadata additionally this will also delete playlists metadata belonging to that channel.
- The button **Reindex** will reindex all channel metadata. This will also categorize existing videos as shorts or streams.
- The button **Reindex Videos** will reindex metadata for all videos in this channel.

If available, you can find the channel description and channel tags there.

The channel customize form gives options to change settings on a per channel basis. Any configurations here will overwrite your configurations from the [settings](settings/application.md) page.

- **Download Format**: Overwrite the download quality for videos from this channel.
- **Auto Delete**: Automatically delete watched videos from this channel after selected days.
- **Index Playlists**: Automatically add all Playlists with at least a video downloaded to your index. Only do this for channels where you care about playlists as this will slow down indexing new videos for having to check which playlist this belongs to.
- **SponsorBlock**: Using [SponsorBlock](https://sponsor.ajay.app/) to get and skip sponsored content. Customize per channel: You can *disable* or *enable* SponsorBlock for certain channels only to overwrite the behavior set on the [settings](settings/application.md) page. Selecting *unset* will remove the overwrite and your setting will fall back to the default on the settings page.

### Downloads
If you have any videos from this channel pending in the download queue, a *Downloads* link will show, bringing you directly to the [downloads](downloads.md) page, filtering the list by the selected channel.
