---
description: Configure this application.
---

# Application Settings Page
Accessible at `/settings/application/` of your **Tube Archivist** instance, this page holds all of the general application configuration settings (minus configuration of the [scheduler](scheduling.md)).

## Subscriptions
Settings related to the channel management. Disable shorts or streams by setting their page size to 0 (zero). Can also be configured on a [per channel basis](../channels.md#page-size-overrides).

Defines how many pages will get analyzed by **Tube Archivist** each time you click on *Rescan Subscriptions*. The default page size used by yt-dlp is **50**, which is also the recommended value to set here. Any value higher will slow down the rescan process, for example if you set the value to 51, that means yt-dlp will have to go through 2 pages of results instead of 1 and by that doubling the time that process takes.

Also see the FAQ [Why does subscribing to a channel not download the complete channel?](../faq.md#why-does-subscribing-to-a-channel-not-download-the-complete-channel)

### Video Page Size
Regular videos off a channel.

### Live Page Size
Same as above, but for a channel's live streams. *Disable by setting to 0.*

### Shorts page Size
Same as above, but for a channel's shorts videos. *Disable by setting to 0.*

### Playlist page size
Page size used for playlist subscriptions.

### Auto Start
This will prioritize and automatically start downloading videos from your subscriptions over regular videos added to the download queue.

### Fast add
Activating that will add videos from channels and playlists in bulk instead of one by one. That is significantly faster but can't extract all metadata. Notably this won't extract: 

- Thumbnails: As the thumbnails returned from the channel and playlist pages are much lower resolution.
- Date published: Although the sort order will be correct, e.g. newer videos will be on top.
- Duration: In most cases duration will not be available.

This only applies to the download queue. All metadata is extracted and indexed after downloading.

## Downloads
Settings related to the download process.

### Download Speed Limit
Set your download speed limit in KB/s. This will pass the option `--limit-rate` to yt-dlp.

### Throttled Rate Limit
Restart download if the download speed drops below this value in KB/s. This will pass the option `--throttled-rate` to yt-dlp. Using this option might have a negative effect if you have an unstable or slow internet connection.

### Sleep Interval
Time in seconds to sleep between repeated requests to YouTube. It is recommended to set this to at least **10** seconds to avoid throtteling and getting blocked. The value set will be applied with a random variation of +/- 50%, e.g. a sleep interval of 10 seconds, will delay requests by between 5 and 15 seconds. This is to mimic regular user traffic.

### Auto Delete Watched Videos
Automatically delete videos marked as watched after selected days. If activated, checks your videos after download task is finished. Auto deleted videos get marked as [ignored](../downloads.md#the-download-queue) and won't get added again in future rescans.

## Download Format
Additional settings passed to yt-dlp.

### Format
This controls which streams get downloaded and is equivalent to passing `--format` to yt-dlp. Use one of the recommended configurations or review the documentation for [yt-dlp](https://github.com/yt-dlp/yt-dlp#format-selection). Please note: The option `--merge-output-format mp4` is automatically passed to yt-dlp to guarantee browser compatibility. Similar to that, `--check-formats` is passed as well to check that the selected formats are actually downloadable.

### Format Sort
This allows you to change how yt-dlp sorts formats by passing `--format-sort` to yt-dlp. Refer to the [documentation](https://github.com/yt-dlp/yt-dlp#sorting-formats) to see what you can pass here. Be aware that some codecs might not be compatible with your browser of choice.

### Extractor Language
Some channels provide translated video titles and descriptions. Add the two letter ISO language code to set your prefered default language. This will only have an effect if the uploader adds translations. Not all language codes are supported, see the [documentation](https://github.com/yt-dlp/yt-dlp#youtube) (the `lang` section) for more details.

### Embed Metadata
This embeds metadata directly into the media file as tags.

This saves:

- Title
- Artist (Channel Name)
- Description
- `ta`: That's the TA metadata as indexed.

The `ta` tag is a json object and contains the complete metadata as indexed in TA. That can be advantageous to embed directly in the file, e.g. for data recovery, portability or reusing of the media files.

This includes, based on your configurations:

- **Video**: Full video metadata, channel metadata is part of this
- **Comments**: All comments
- **Subtitles**: These are the full text segments as indexed and optimized for searching
- **Playlists**: Full playlist metadata if the video is part of any Playlist/s

??? "Examples accessing `ta` metadata"
    Using ffprobe:

    ```bash
    ffprobe -v quiet -show_entries format_tags -of json video.mp4 \
      | jq -r '.format.tags.ta
    ```

    Using [mediainfo](https://mediaarea.net/en/MediaInfo):
    ```bash
    mediainfo --Output=JSON video.mp4 | jq -r '.media.track.[].extra.ta'
    ```

    Using [mutagen](https://github.com/quodlibet/mutagen):

    ```python
    import json
    from mutagen.mp4 import MP4

    video = MP4("video.mp4")
    metadata = json.loads(video.tags["----:com.tubearchivist:ta"][0].decode())
    print(metadata)
    ```

Also see [settings/embed-metadata-into-media-file](actions.md/#embed-metadata-into-media-file) to update metadata into existing files.

### Embed Thumbnail
This saves the thumbnail into the media file by passing `--embed-thumbnail` to yt-dlp.

## Subtitles

### Subtitle Language
Select the subtitle languages you like to download. Add a comma separated list for multiple languages (can be regex) or `all`, e.g. `en.*,ja` (where `en.*` is a regex pattern that matches `en` followed by 0 or more of any character). You can prefix the language code with a `-` to exclude it from the requested languages, e.g. `all,-fr`. For Chinese you must specify `zh-Hans` or `zh-Hant`, specifying "zh" is invalid, otherwise the subtitle won't download successfully. However, you can use `zh.*` to get both. Check [IANA's language subtag registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) for the right language code.

### Enable Auto Generated
This will fallback to from YouTube auto generated subtitles if subtitles from the uploader are not available. Auto generated subtitles are usually less accurate, particularly for auto translated tracks.

### Enable Index
Enabling subtitle indexing will add the lines to Elasticsearch and will make subtitles searchable. This will increase the index size and is not recommended on low-end hardware.

## Comments

### Index Comments
Set your configuration for downloading and indexing comments. This takes the same values as documented in the `max_comments` section for the youtube extractor of [yt-dlp](https://github.com/yt-dlp/yt-dlp#youtube). Add, without spaces, between the four different fields: *max-comments,max-parents,max-replies,max-replies-per-thread*.  

Example:  

- `all,100,all,30`: Get 100 max-parents and 30 max-replies-per-thread.
- `1000,all,all,50`: Get a total of 1000 comments over all, 50 replies per thread.

### Comment sort method
Change sort method between *top* or *new*. The default is *top*, as decided by YouTube.

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

### Manual Update
Alternatively, you can also manually import your cookie into Tube Archivist. Export your cookie as a *Netscape* formatted text file and paste the content into the text field.

- There are various tools out there that allow you to export cookies from your browser. This project doesn't make any specific recommendations.
- Once imported, a **Validate Cookie File** button will show, where you can confirm if your cookie is working or not.
- A cookie is considered as _valid_ if yt-dlp is able to access your private [Liked Videos](https://www.youtube.com/playlist?list=LL) playlist.

### Use your cookie
Once imported, in addition to the advantages above, your [Watch Later](https://www.youtube.com/playlist?list=WL) and [Liked Videos](https://www.youtube.com/playlist?list=LL) playlists become a regularly accessible playlist that you can download and subscribe to like any other [playlist](../playlists.md).

### Limitation
There is only one cookie per Tube Archivist instance. This will be shared between all users.

## PO Token
Also known as _proof of origin token_, this is a token required in some cases by YT to validate the requests. See the wiki on the yt-dlp repo with more info, particularly the [PO Token Guide](https://github.com/yt-dlp/yt-dlp/wiki/PO-Token-Guide) page.

## PO Token Provider URL
yt-dlp offers a [plugin](https://github.com/yt-dlp/yt-dlp/wiki/PO-Token-Guide#po-token-provider-plugins) to support for the Proof of Origin (PO) Token.
In an effort to make it easier for the user, **Tube Archivist** has implemented the plugin:

- [bgutil-ytdlp-pot-provider](https://github.com/Brainicism/bgutil-ytdlp-pot-provider) by [Brainicism](https://github.com/Brainicism)

### Installation
The following is a suggested docker-compose.yml to use the plugin with the default **Tube Archivist** container.
The default container creates it's own network named tubearchivist_default.
Please customize this example to your needs.

```yml
services:
  bgutil-provider:
    image: brainicism/bgutil-ytdlp-pot-provider
    container_name: bgutil-provider
    restart: unless-stopped
    init: true
    ports:
      - "4416:4416"
    environment:
      - TZ=Etc/UTC
    networks:
      - tubearchivist_default

networks:
  tubearchivist_default:
    external: true
```

### Configuration
If you are using the above example docker container for **bgutil-ytdlp-pot-provider**, here is an example of what the URL would be:

```text
http://bgutil-provider:4416
```

## Integrations
All third party integrations of **Tube Archivist** will **always** be *opt in*.

### API Token
Your access token for the **Tube Archivist** API.

### ReturnYoutubeDislike

This will return dislikes and average ratings for each video by integrating with the API from [returnyoutubedislike.com](https://www.returnyoutubedislike.com/).

### SponsorBlock
Using [SponsorBlock](https://sponsor.ajay.app/) to retrieve timestamps for, and skip, sponsored content. If a video doesn't have timestamps, or has unlocked timestamps, use the browser addon to contribute to this excellent project. Can also be activated and deactivated on a per [channel overwrite](../channels.md#about).

### Cast
As Cast doesn't support authentication for static files, you'll also need to set [`DISABLE_STATIC_AUTH`](../installation/env-vars.md#disable_static_auth) to disable authentication for your static files.

Enabling this integration will embed an additional third-party JS library from **Google**.  

**Requirements**:

 - HTTPS: To use the cast integration, HTTPS needs to be enabled. This can be done using a reverse proxy. This is a requirement from Google, as communication to the casting device is required to be encrypted, but the content itself is not.
 - Supported Browser: A supported browser is required for this integration, such as Google Chrome. Other browsers, especially Chromium-based browsers, may support casting by enabling it in the settings.
 - Subtitles: Subtitles are supported, however they do not work out of the box and require additional configuration. Due to requirements by Google, to use subtitles you need additional headers which will need to be configured in your reverse proxy. See this [page](https://developers.google.com/cast/docs/web_sender/advanced#cors_requirements) for the specific requirements.  
  - You need the following headers: `Content-Type`, `Accept-Encoding`, and `Range`. Note that the last two headers, `Accept-Encoding` and `Range`, are additional headers that you may not have needed previously.
  - Wildcards "*" can not be used for the `Access-Control-Allow-Origin` header. If the page has protected media content, it must use a domain instead of a wildcard.  

## Membership
Become a sponsor of this project to unlock additional membership perks. See [members.tubearchivist.com](https://members.tubearchivist.com) for more details.

- Enter the membership API key here available from [members.tubearchivist.com/profile](https://members.tubearchivist.com/profile).
- Once entered, click on "Validate" to check your profile.
- Click on "Sync Subscriptions" to mirror your local subscriptions with the membership platform.
  - This only works if your local subscriptions are within the limits of your sponsor tier.
  - This automatically syncs your video, shorts and streams preferences.
  - Alternatively go to [members.tubearchivist.com/subscriptions](https://members.tubearchivist.com/subscriptions) and add your channels there.

## Snapshots
!!! info
    This will make a snapshot of your metadata index only. No media files or additional configuration variables you have set on the settings page will be backed up.

System snapshots will automatically make daily snapshots of the Elasticsearch index. The task will start at 12pm your local time. Snapshots are deduplicated, meaning that each snapshot will only have to backup changes since the last snapshot. Old snapshots will automatically get deleted after 30 days.

- **Create snapshot now**: Will start the snapshot process now and outside of the regular daily schedule.
- **Restore**: Restore your index to that point in time. Select one of the available snapshots to restore from.
