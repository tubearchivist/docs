---
description: Populate your download queue by rescanning your Subscriptions or manually adding items to the download queue.
---

# Downloads Page
Accessible at `/downloads/` of your **Tube Archivist** instance, this page handles all the download functionality.


## Rescan Subscriptions
The **Rescan Subscriptions** icon <img src="/assets/icon-rescan.png?raw=true" alt="rescan icon" width="20px" style="margin:0 5px;"> will start a background task to look for new videos from the channels and playlists you are subscribed to.  

**Tube Archivist** will get available *videos*, *shorts* and *streams* from each channel. You can define the channel and playlist page size on the [settings page](settings/application.md#subscriptions). With the default page size, expect this process to take around 2-3 seconds for each channel or playlist you are subscribed to. A status message will show the progress.

Then for every video found, **Tube Archivist** will skip the video if it has already been downloaded or if you added it to the *ignored* list previously. All other videos will get added to the download queue. Expect this to take around 2 seconds for each video as **Tube Archivist** needs to grab some additional metadata and artwork. New videos will get added to the end of the download queue.

## Download Queue
The **Start Download** icon <img src="/assets/icon-download.png?raw=true" alt="download icon" width="20px" style="margin:0 5px;"> will start the download process. This will prioritize videos added as *auto start* or as *download now*, starting from the top of the queue. Once the process has started, a progress message will show with additional details and controls: 

- The stop icon <img src="/assets/icon-stop.png?raw=true" alt="stop icon" width="20px" style="margin:0 5px;"> will gracefully stop the download process, once the current video has been finished successfully. This will also reset the auto start behavior to avoid confusion.
- [Currently broken] The cancel icon <img src="/assets/icon-close-red.png?raw=true" alt="close icon" width="20px" style="margin:0 5px;"> is equivalent to killing the process and will stop the download immediately. Any leftover files will get deleted, the canceled video will still be available in the download queue.

After downloading, **Tube Archivist** tries to add new videos to already indexed playlists and, if activated on the settings page, get comments for the new videos.

## Add to Download Queue
The **Add to Download Queue** icon <img src="/assets/icon-add.png?raw=true" alt="add icon" width="20px" style="margin:0 5px;"> opens a text field to manually add videos to the download queue. Add one item per line. This will _not_ add videos already in the queue, previously ignored or already indexed.

### Fast add
This will add videos in bulk to the queue, at the expense of having less metadata and no thumbnail available in the download queue. The full metadata will get index as usual after downloading. Particularly usefull when adding whole channels and playlists, has no effect when adding single videos.

### Re-Download
In some cases you might want to re-download videos. For example if you unexpectedly got a lower resolution or if you want to upgrade the archive with better quality media files.

- This will add, download and index videos again, even if they are already in your archive.
- This will _not_ add videos already in the queue or previously ignored.
- Also see [multiselect](index.md#multiselect).

### Auto download
If you add them with *Download Now*, this will start the download automatically with priority. 

You have a few options:

### Videos
Add a [video](urls.md#video) URL to download a single video.

### Channels
Add a [channel](urls.md#channel) to download the complete channel, or a [channel sub page](urls.md#channel-subpages) to download a partial channel.

### Playlist
Add a [playlist](urls.md#playlist) to download all videos in the list. When adding a playlist to the queue, this playlist will automatically get [indexed](playlists.md#playlist-detail).

## The Download Queue
Below the three action buttons is the download queue. New items will get added to the end of the queue, the next video to download once you click on **Start Download** will be the first in the list.

### Advanced Filtering and Bulk Actions
Clicking on **Show Advanced** opens additional filter and bulk action options:  

- Filter by types: Shorts, Streams or regular Videos
- Filter by channel: If there are videos from more than one channel in the queue. This generates links for the top 30 channels in the queue.
- Filter by error state: Filter by videos with or without any errors
- Search by video title
- All these are filters are applied combined and you'll see the intersections

Then the **Bulk Actions** are applied to the filters as indicated:

- Ignore: Bulk ignore, shows when showing **Pending Videos** only.
- Add to queue: Bulk add ignored videos back to queue, shows when showing **Ignored Videos** only.
- Download now: Start downloading selected videos with priority
- Clear errors: Clear any error messages from
- Forget: This forgets the videos from the queue

Every video in the download queue has two buttons:

- **Ignore**: This will remove that video from the download queue and this video will not get added again, even when you **Rescan Subscriptions**.
- **Download now**: This will give priority to this video. If the download process is already running, the prioritized video will get downloaded as soon as the current video is finished. If there is no download process running, this will start downloading this single video and stop after that [currently broken - after downloading the selected video, it will currently go through the entire queue].  

Failed videos will show an error message of what went wrong and will give you additional options with how to continue. Usually this means the video in the queue is no longer available on YouTube. **Tube Archivist** will not retry to download a failed video.

You can flip the view by activating **Show Only Ignored Videos**. This will show all videos you have previously *ignored*.  
Every video in the ignored list has two buttons:

- **Forget**: This will delete the item from the ignored list.
- **Add to Queue**: This will add the ignored video back to the download queue.  
