---
description: Configure this project, yt-dlp behavior, the scheduler and more.
---

# Settings Page
Accessible at `/settings/` of your **Tube Archivist**, this page holds all the configurations and additional functionality related to the database.

Click on **Update Settings** at the bottom of the form to apply your configurations.

## Color scheme
Switch between the easy on the eyes dark theme and the burning bright theme.

## Archive View
- **Page Size**: Defines how many results get displayed on a given page. Same value goes for all archive views.

## Subscriptions
Settings related to the channel management. Disable shorts or streams by setting their page size to 0 (zero).

- **Channel Page Size**: Defines how many pages will get analyzed by **Tube Archivist** each time you click on *Rescan Subscriptions*. The default page size used by yt-dlp is **50**, that's also the recommended value to set here. Any value higher will slow down the rescan process, for example if you set the value to 51, that means yt-dlp will have to go through 2 pages of results instead of 1 and by that doubling the time that process takes.
- **Live Page Size**: Same as above, but for channel live streams.
- **Shorts page Size**: Same as above, but for shorts videos.
- **Auto Start**: This will prioritize and automatically start downloading videos from your subscriptions over regular video added to the download queue.

## Downloads
Settings related to the download process.

- **Download Speed Limit**: Set your download speed limit in KB/s. This will pass the option `--limit-rate` to yt-dlp.
- **Throttled Rate Limit**: Restart download if the download speed drops below this value in KB/s. This will pass the option `--throttled-rate` to yt-dlp. Using this option might have a negative effect if you have an unstable or slow internet connection.
- **Sleep Interval**: Time in seconds to sleep between requests to YouTube. It's a good idea to set this to **3** seconds. Might be necessary to avoid throttling.
- **Auto Delete Watched Videos**: Automatically delete videos marked as watched after selected days. If activated, checks your videos after download task is finished.

## Download Format
Additional settings passed to yt-dlp.

- **Format**: This controls which streams get downloaded and is equivalent to passing `--format` to yt-dlp. Use one of the recommended one or look at the documentation of [yt-dlp](https://github.com/yt-dlp/yt-dlp#format-selection). Please note: The option `--merge-output-format mp4` is automatically passed to yt-dlp to guarantee browser compatibility. Similar to that, `--check-formats` is passed as well to check that the selected formats are actually downloadable.
- **Format Sort**: This allows you to change how yt-dlp sorts formats by passing `--format-sort` to yt-dlp. Refere to the [documentation](https://github.com/yt-dlp/yt-dlp#sorting-formats), what you can pass here. Be aware, that some codecs might not be compatible with your browser of choice.
- **Extractor Language**: Some channels provide tranlated video titles and descriptions. Add the two letter ISO language code, to set your prefered default language. This will only have an effect, if the uploader adds translations. Not all language codes are supported, see the [documentation](https://github.com/yt-dlp/yt-dlp#youtube) (the `lang` section) for more details.
- **Embed Metadata**: This saves the available tags directly into the media file by passing `--embed-metadata` to yt-dlp.
- **Embed Thumbnail**: This will save the thumbnail into the media file by passing `--embed-thumbnail` to yt-dlp.

## Subtitles

- **Download Setting**: Select the subtitle language you like to download. Add a comma separated list for multiple languages.
- **Source Settings**: User created subtitles are provided from the uploader and are usually the video script. Auto generated is from YouTube, quality varies, particularly for auto translated tracks.
- **Index Settings**: Enabling subtitle indexing will add the lines to Elasticsearch and will make subtitles searchable. This will increase the index size and is not recommended on low-end hardware.

## Comments

- **Download and index comments**: Set your configuration for downloading and indexing comments. This takes the same values as documented in the `max_comments` section for the youtube extractor of [yt-dlp](https://github.com/yt-dlp/yt-dlp#youtube). Add without space between the four different fields: *max-comments,max-parents,max-replies,max-replies-per-thread*. Example:
    - `all,100,all,30`: Get 100 max-parents and 30 max-replies-per-thread.
    - `1000,all,all,50`: Get a total of 1000 comments over all, 50 replies per thread.
- **Comment sort method**: Change sort method between *top* or *new*. The default is *top*, as decided by YouTube.
- The [Refresh Metadata](#refresh-metadata) background task will get comments from your already archived videos, spreading the requests out over time.  

Archiving comments is slow as only very few comments get returned per request with yt-dlp. Choose your configuration above wisely. Tube Archivist will download comments after the download queue finishes, your videos will be already available while the comments are getting downloaded.

## Cookie
Importing your YouTube Cookie into Tube Archivist allows yt-dlp to bypass age restrictions, gives access to private videos and your *watch later* or *liked videos*.

### Security concerns
Cookies are used to store your session and contain your access token to your google account, this information can be used to take over your account. Treat that data with utmost care as you would any other password or credential. *Tube Archivist* stores your cookie in Redis and will automatically append it to yt-dlp for every request.

### Auto import
Easiest way to import your cookie is to use the **Tube Archivist Companion** [browser extension](https://github.com/tubearchivist/browser-extension) for Firefox and Chrome.

### Manual import
Alternatively you can also manually import your cookie into Tube Archivist. Export your cookie as a *Netscape* formatted text file, name it *cookies.google.txt* and put it into the *cache/import* folder. After that you can enable the option on the settings page and your cookie file will get imported.

- There are various tools out there that allow you to export cookies from your browser. This project doesn't make any specific recommendations.
- Once imported, a **Validate Cookie File** button will show, where you can confirm if your cookie is working or not.

### Use your cookie
Once imported, additionally to the advantages above, your [Watch Later](https://www.youtube.com/playlist?list=WL) and [Liked Videos](https://www.youtube.com/playlist?list=LL) become a regular playlist you can download and subscribe to as any other [playlist](playlists.md).

### Limitation
There is only one cookie per Tube Archivist instance, this will be shared between all users.

## Integrations
All third party integrations of TubeArchivist will **always** be *opt in*.

- **API**: Your access token for the Tube Archivist API.
- **returnyoutubedislike.com**: This will get return dislikes and average ratings for each video by integrating with the API from [returnyoutubedislike.com](https://www.returnyoutubedislike.com/).
- **SponsorBlock**: Using [SponsorBlock](https://sponsor.ajay.app/) to get and skip sponsored content. If a video doesn't have timestamps, or has unlocked timestamps, use the browser addon to contribute to this excellent project. Can also be activated and deactivated as a per [channel overwrite](Settings#channel-customize).

## Snapshots
!!! note
    This will make a snapshot of your metadata index only, no media files or additional configuration variables you have set on the settings page will be backed up.

System snapshots will automatically make daily snapshots of the Elasticsearch index. The task will start at 12pm your local time. Snapshots are deduplicated, meaning that each snapshot will only have to backup changes since the last snapshot. Old snpshots will automatically get deleted after 30 days.

- **Create snapshot now**: Will start the snapshot process now, outside of the regular daily schedule.
- **Restore**: Restore your index to that point in time.

# Scheduler Setup
Schedule settings expect a cron like format, where the first value is minute, second is hour and third is day of the week. Day 0 is Sunday, day 1 is Monday etc.

Examples:

- `0 15 *`: Run task every day at 15:00 in the afternoon.
- `30 8 */2`: Run task every second day of the week (Sun, Tue, Thu, Sat) at 08:30 in the morning.
- `0 */3,8-17 *`: Execute every hour divisible by 3, and every hour during office hours (8 in the morning - 5 in the afternoon).
- `0 8,16 *`: Execute every day at 8 in the morning and at 4 in the afternoon.
- `auto`: Sensible default.
- `0`: (zero), deactivate that task.

!!! note "BE AWARE"
    - Changes in the scheduler settings require a container restart to take effect.
    - Cron format as *number*/*number* are none standard cron and are not supported by the scheduler, for example `0 0/12 *` is invalid, use `0 */12 *` instead.
    - Avoid an unnecessary frequent schedule to not get blocked by YouTube. For that reason, the scheduler doesn't support schedules that trigger more than once per hour.

## Rescan Subscriptions
That's the equivalent task as run from the downloads page looking through your channel and playlist and add missing videos to the download queue.

Become a sponsor and join [members.tubearchivist.com](https://members.tubearchivist.com/) to get access to *real time* notifications for new videos uploaded by your favorite channels.

## Start download
Start downloading all videos currently in the download queue.

## Refresh Metadata
Rescan videos, channels and playlists on youtube and update metadata periodically. This will also refresh your subtitles and comments based on your current settings. If an item is no longer available on YouTube, this will deactivate it and exclude it from future refreshes. This task is meant to be run once per day, set your schedule accordingly.

The field **Refresh older than x days** takes a number where TubeArchivist will consider an item as *outdated*. This value is used to calculate how many items need to be refreshed today based on the total indexed. This will spread out the requests to YouTube. Sensible value here is **90** days.

Additionally to the outdated documents, this will also refresh very recently published videos. This is to keep metadata and statistics uptodate during the first few days when the video goes live.

## Thumbnail check
This will check if all expected thumbnails are there and will delete any artwork without matching video.

## ZIP file index backup
Create a zip file of the metadata and select **Max auto backups to keep** to automatically delete old backups created from this task. For data consistency, make sure there aren't any other tasks running that will change the index during the backup process. This is very slow, particularly for large archives. Use snapshots instead. 


# Actions

## Delete download queue
The button **Delete all queued** will delete all pending videos from the download queue. The button **Delete all ignored** will delete all videos you have previously ignored.

## Manual Media Files Import
!!! note
    This is inherently error prone, as there are many variables, some outside of the control of this project. Read this carefully and use at your own risk. 

Add the files you'd like to import to the */cache/import* folder. Only add files, don't add subdirectories. All files you are adding, need to have the same *base name* as the media file. Then start the process from the settings page *Manual Media Files Import*.

Valid media extensions are *.mp4*, *.mkv* or *.webm*. If you have other file extensions or incompatible codecs, convert them first to mp4. **Tube Archivist** can identify the videos with one of the following methods.

### Method 1:
Add a matching *.info.json* file with the media file. Both files need to have the same base name, for example:

- For the media file: `<base-name>.mp4`
- For the JSON file: `<base-name>.info.json`

The import process then looks for the 'id' key within the JSON file to identify the video.

### Method 2:
Detect the YouTube ID from filename, this accepts the default yt-dlp naming convention for file names like:

- `<base-name>[<youtube-id>].mp4`
- The YouTube ID in square brackets at the end of the filename is the crucial part.

### Offline import:
If the video you are trying to import is not available on YouTube any more, **Tube Archivist** can import the required metadata:

- The file `<base-name>.info.json` is required to extract the required information.
- Add the thumbnail as `<base-name>.<ext>`, where valid file extensions are *.jpg*, *.png* or *.webp*. If there is no thumbnail file, **Tube Archivist** will try to extract the embedded cover from the media file or will fallback to a default thumbnail.
- Add subtitles as `<base-name>.<lang>.vtt` where *lang* is the two letter ISO country code. This will archive all subtitle files you add to the import folder, independent from your configurations. Subtitles can be archived and used in the player, but they can't be indexed or made searchable due to the fact, that they have a very different structure than the subtitles as **Tube Archivist** needs them.
- For videos, where the whole channel is not available any more, you can add the `<channel-id>.info.json` file as generated by *youtube-dl/yt-dlp* to get the full metadata. Alternatively **Tube Archivist** will extract as much info as possible from the video info.json file. 

### Some notes:

- This will **consume** the files you put into the import folder: Files will get converted to mp4 if needed (this might take a long time...) and moved to the archive, *.json* files will get deleted upon completion to avoid having duplicates on the next run.
- For best file transcoding quality, convert your media files with desired settings first before importing.
- Maybe start with a subset of your files to import to make sure everything goes well...
- A notification box will show with progress, follow the docker logs to monitor for errors.

## Embed thumbnails into media file
This will write or overwrite all thumbnails in the media file using the downloaded thumbnail. This is only necessary if you didn't download the files with the option *Embed Thumbnail* enabled or you want to make sure all media files get the newest thumbnail.

## ZIP file index backup
This will backup your metadata into a zip file. The file will get stored at *cache/backup* and will contain the necessary files to restore the Elasticsearch index formatted **nd-json** files. For data consistency, make sure there aren't any other tasks running that will change the index during the backup process. This is very slow, particularly for large archives.  

!!! note "BE AWARE"
    This will **not** backup any media files, just the metadata from the Elasticsearch.

## Restore From Backup
The restore functionality will expect the same zip file in *cache/backup* as created from the **Backup database** function. This will recreate the index from the zip archive file. There will be a list of all available backup to choose from. The *source* tag can have these different values:

- **manual**: For backups manually created from here on the settings page.
- **auto**: For backups automatically created via a sceduled task.
- **update**: For backups created after a Tube Archivist update due to changes in the index.
- **False**: Undefined.

!!! note "BE AWARE"
    This will **replace** your current index with the one from the backup file. This won't restore any media files.

## Rescan Filesystem
This function will go through all your media files and looks at the whole index to try to find any issues:

- Should the filename not match with the indexed media url, this will rename the video files correctly and update the index with the new link.
- When you delete media files from the filesystem outside of the Tube Archivist interface, this will delete leftover metadata from the index.
- When you have media files that are not indexed yet, this will grab the metadata from YouTube like it was a newly downloaded video. This can be useful when restoring from an older backup file with missing metadata but already downloaded mediafiles. NOTE: This only works if the media files are named in the same convention as Tube Archivist does, particularly the YouTube ID needs to be at the same index in the filename, alternatively see above for *Manual Media Files Import*.
- The task will stop, when adding a video fails, for example if the video is no longer available on YouTube.
- This will also check all of your thumbnails and download any that are missing.

!!! note "BE AWARE"
    There is no undo.
