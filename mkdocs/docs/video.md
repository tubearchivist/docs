---
description: Complete Video metadata with playlist navigation and comments.
---

# Video Page
Every video downloaded gets a dedicated page accessible at `/video/<video-id>/` of your **Tube Archivist** instance. Throughout the interface, clicking on a video title will access the video page.

Clicking on the channel name or the channel icon will bring you to the dedicated [channel detail page](channels.md#channel-detail).

- The button **Reindex** will reindex the metadata of this video.
- The button **Download File** will download the media file in the browser.
- The button **Delete Video** will delete that video entry and the media file.

If available, a tag cloud will show, representing the tags set by the uploader.

You can also find stream metadata like file size, video codecs, video bitrate and resolution, audio codecs and bitrate. 

The video description is truncated to the first few lines, clicking on *show more* will expand to show the whole description.

## Playlist
When available, a playlist navigation will show at the bottom. Clicking on the playlist name will bring you to the dedicated [Playlist Detail page](playlists.md#playlist-detail) showing all videos downloaded from that playlist. The number in square brackets indicates the position of the current video in that playlist.

Clicking on the next, or previous, video name or thumbnail will bring you to that dedicated video page.

## Similar Videos
**Tube Archivist** will show up to six similar videos in a grid. Similarity is detected from the **video title** and the **video tags**. This naturally will show some videos from the same channel, but can also return videos about the same topic from other channels.

When playing a video from the similar section with the inline player, the current video will get replaced. Refreshing the page to reset that or clicking on the video title will avoid that behavior. 

## Comments
If activated on the [Settings Page](settings/application.md#comments), this will show the indexed comments. Reveal the threads by clicking the *+ Replies* button. Comments with a heart symbol are favorited by the uploader, and comments by the uploader are highlighted in a different color.
