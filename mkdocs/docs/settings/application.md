---
description: Configure this application.
---

# Application Settings Page
Accessible at `/settings/application/` of your **Tube Archivist** instance, this page holds all of the general application configuration settings (minus configuration of the [scheduler](scheduling.md)).

!!! tip "Saving Configurations"
    Click on **Update Application Configurations** at the bottom of the page to apply your configurations.

## Subscriptions
Settings related to the channel management. Disable shorts or streams by setting their page size to 0 (zero).

- **Channel Page Size**: Defines how many pages will get analyzed by **Tube Archivist** each time you click on *Rescan Subscriptions*. The default page size used by yt-dlp is **50**, which is also the recommended value to set here. Any value higher will slow down the rescan process, for example if you set the value to 51, that means yt-dlp will have to go through 2 pages of results instead of 1 and by that doubling the time that process takes. *Cannot be set to 0.*
- **Live Page Size**: Same as above, but for a channel's live streams. *Disable by setting to 0.*
- **Shorts page Size**: Same as above, but for a channel's shorts videos. *Disable by setting to 0.*
- **Auto Start**: This will prioritize and automatically start downloading videos from your subscriptions over regular videos added to the download queue.

## Downloads
Settings related to the download process.

- **Download Speed Limit**: Set your download speed limit in KB/s. This will pass the option `--limit-rate` to yt-dlp.
- **Throttled Rate Limit**: Restart download if the download speed drops below this value in KB/s. This will pass the option `--throttled-rate` to yt-dlp. Using this option might have a negative effect if you have an unstable or slow internet connection.
- **Sleep Interval**: Time in seconds to sleep between requests to YouTube. It's a good idea to set this to **3** seconds. Might be necessary to avoid throttling.
- **Auto Delete Watched Videos**: Automatically delete videos marked as watched after selected days. If activated, checks your videos after download task is finished. Auto deleted videos get marked as [ignored](../downloads.md#the-download-queue) and won't get added again in future rescans.

## Download Format
Additional settings passed to yt-dlp.

- **Format**: This controls which streams get downloaded and is equivalent to passing `--format` to yt-dlp. Use one of the recommended configurations or review the documentation for [yt-dlp](https://github.com/yt-dlp/yt-dlp#format-selection). Please note: The option `--merge-output-format mp4` is automatically passed to yt-dlp to guarantee browser compatibility. Similar to that, `--check-formats` is passed as well to check that the selected formats are actually downloadable.
- **Format Sort**: This allows you to change how yt-dlp sorts formats by passing `--format-sort` to yt-dlp. Refer to the [documentation](https://github.com/yt-dlp/yt-dlp#sorting-formats) to see what you can pass here. Be aware that some codecs might not be compatible with your browser of choice.
- **Extractor Language**: Some channels provide translated video titles and descriptions. Add the two letter ISO language code to set your prefered default language. This will only have an effect if the uploader adds translations. Not all language codes are supported, see the [documentation](https://github.com/yt-dlp/yt-dlp#youtube) (the `lang` section) for more details.
- **Embed Metadata**: This saves the available tags directly into the media file by passing `--embed-metadata` to yt-dlp.
- **Embed Thumbnail**: This saves the thumbnail into the media file by passing `--embed-thumbnail` to yt-dlp.

## Subtitles

- **Download Setting**: Select the subtitle language you like to download. Add a comma separated list for multiple languages. For Chinese you must specify `zh-Hans` or `zh-Hant`, specifying "zh" is invalid, otherwise the subtitle won't download successfully.
- **Source Settings**: User created subtitles are provided from the uploader and are usually the video script. Auto generated is from YouTube. The quality varies, particularly for auto translated tracks.
- **Index Settings**: Enabling subtitle indexing will add the lines to Elasticsearch and will make subtitles searchable. This will increase the index size and is not recommended on low-end hardware.

## Comments

- **Download and index comments**: Set your configuration for downloading and indexing comments. This takes the same values as documented in the `max_comments` section for the youtube extractor of [yt-dlp](https://github.com/yt-dlp/yt-dlp#youtube). Add, without spaces, between the four different fields: *max-comments,max-parents,max-replies,max-replies-per-thread*. Example:
    - `all,100,all,30`: Get 100 max-parents and 30 max-replies-per-thread.
    - `1000,all,all,50`: Get a total of 1000 comments over all, 50 replies per thread.
- **Comment sort method**: Change sort method between *top* or *new*. The default is *top*, as decided by YouTube.
- The [Refresh Metadata](scheduling.md#refresh-metadata) background task will get comments from your already archived videos, spreading the requests out over time.

Archiving comments is slow as only a few comments get returned per request with yt-dlp. Choose your configuration above wisely. Tube Archivist will download comments after the download queue finishes. Your videos will already be available while the comments are getting downloaded.

## Cookie

!!! warning "Cookie Expiry"
	Using cookies can have unintended consequences. Multiple users have reported that their account got flagged and cookies will expire within a few hours. It appears that YT has some detection mechanism that will invalidate your cookie if it's being used outside of a browser. That is happening server side on YT. If you are affected, you might be better off to not use this functionality.

Importing your YouTube Cookie into **Tube Archivist** allows yt-dlp to bypass age restrictions, gives access to private videos and your *Watch Later* or *Liked Videos* playlists.

### Security concerns
Cookies are used to store your session and contain your access token to your Google account. **This information can be used to take over your account.** Treat that data with utmost care, as you would any other password or credential. **Tube Archivist** stores your cookie in Redis and will automatically append it to yt-dlp for every request.

### Auto import
Easiest way to import your cookie is to use the **Tube Archivist Companion** [browser extension](https://github.com/tubearchivist/browser-extension) for Firefox and Chrome.

### Manual import
Alternatively, you can also manually import your cookie into Tube Archivist. Export your cookie as a *Netscape* formatted text file, name it *cookies.google.txt* and put it into the *cache/import* folder. After that you can enable the option on the settings page and your cookie file will get imported.

- There are various tools out there that allow you to export cookies from your browser. This project doesn't make any specific recommendations.
- Once imported, a **Validate Cookie File** button will show, where you can confirm if your cookie is working or not.

### Use your cookie
Once imported, in addition to the advantages above, your [Watch Later](https://www.youtube.com/playlist?list=WL) and [Liked Videos](https://www.youtube.com/playlist?list=LL) playlists become a regularly accessible playlist that you can download and subscribe to like any other [playlist](../playlists.md).

### Limitation
There is only one cookie per Tube Archivist instance. This will be shared between all users.

## Integrations
All third party integrations of **Tube Archivist** will **always** be *opt in*.

- **API**: Your access token for the **Tube Archivist** API.
- **returnyoutubedislike.com**: This will return dislikes and average ratings for each video by integrating with the API from [returnyoutubedislike.com](https://www.returnyoutubedislike.com/).
- **SponsorBlock**: Using [SponsorBlock](https://sponsor.ajay.app/) to retrieve timestamps for, and skip, sponsored content. If a video doesn't have timestamps, or has unlocked timestamps, use the browser addon to contribute to this excellent project. Can also be activated and deactivated on a per [channel overwrite](../channels.md#about).

## Snapshots
!!! info
    This will make a snapshot of your metadata index only. No media files or additional configuration variables you have set on the settings page will be backed up.

System snapshots will automatically make daily snapshots of the Elasticsearch index. The task will start at 12pm your local time. Snapshots are deduplicated, meaning that each snapshot will only have to backup changes since the last snapshot. Old snapshots will automatically get deleted after 30 days.

- **Create snapshot now**: Will start the snapshot process now and outside of the regular daily schedule.
- **Restore**: Restore your index to that point in time. Select one of the available snapshots to restore from.

!!! tip "Saving Configurations"
    Click on **Update Application Configurations** at the bottom of the page to apply your configurations.
