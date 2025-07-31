---
description: Administration tasks for the application.
---

# Actions Page
Accessible at `/settings/actions/` of your **Tube Archivist** instance, this page allows admins to perform actions related to the database and other functions.

## Manual Media Files Import
!!! warning
    This is inherently error prone, as there are many variables, some outside of the control of this project. Read this carefully and use at your own risk.

!!! note
    The importer will *try* to fetch metadata from YouTube after identifying the video, as it is assumed this is newer, even if you add the info json file as described below.

Add the files you'd like to import to the `/cache/import` folder. Only add files, don't add subdirectories. All files you are adding need to have the same *base name* as the media file. Then, start the process from the settings page with the *Manual Media Files Import* button.

Valid media extensions are *.mp4*, *.mkv* or *.webm*. If you have other file extensions or incompatible codecs, convert them first to mp4. **Tube Archivist** can identify the videos with one of the following methods:

### Method 1:
Add a matching *.info.json* file with the media file. Both files need to have the same base name, for example:

- For the media file: `<base-name>.mp4`
- For the JSON file: `<base-name>.info.json`

The import process then looks for the 'id' key within the JSON file to identify the video.


Sometimes you may need to create this file manually. The following are the absolute minimum required tags as keys for manual importing.

!!! note
    `thumbnail` can be left blank or null, however it is required to be present. If blank the thumbnail will be extracted from the video file on import.

```json
{
  "id": "",
  "channel_id": "",
  "title": "",
  "upload_date": "",
  "thumbnail": null
}
```

However, you may fill out additional tags if they are known for a more complete result.
```json
{
  "id": "",
  "channel_id": "",
  "title": "",
  "upload_date": "",
  "description": null,
  "categories": null,
  "thumbnail": null,
  "tags": null,
  "view_count": null
}
```

### Method 2:
Detect the YouTube ID from filename. This accepts the default yt-dlp naming convention for file names like:

- `<base-name>[<youtube-id>].mp4`

!!! success "Required Naming Convention"
    The YouTube ID in square brackets at the end of the filename is the crucial part.

### Offline import:
If the video you are trying to import is not available on YouTube any more, **Tube Archivist** can import the required metadata:

- The file `<base-name>.info.json` is required to extract the required information.
- Add the thumbnail as `<base-name>.<ext>`, where valid file extensions are *.jpg*, *.png* or *.webp*. If there is no thumbnail file, **Tube Archivist** will try to extract the embedded cover from the media file or will fallback to a default thumbnail.
- Add subtitles as `<base-name>.<lang>.vtt` where *lang* is the appropriate two letter ISO 639 language code. This will archive all subtitle files you add to the import folder, independent from your configurations. Subtitles can be archived and used in the player, but they can't be indexed or made searchable due to the fact, that they have a very different structure than the subtitles as **Tube Archivist** needs them.
- For videos, where the whole channel is not available any more, TA will extract as much info as possible from the info json file.

### Some notes:

- This will **consume** the files you put into the import folder: Files will get converted to *.mp4* if needed (this might take a long time...) and moved to the archive, *.json* files will get deleted upon completion to avoid having duplicates on the next run.
- For best file transcoding quality, convert your media files with desired settings first before importing.
- A notification box will show with progress, follow the docker logs to monitor for errors.

!!! tip "Start Small"
    Starting with a small subset of the files to import to test and confirm that your settings, configurations, and files will work is recommended.

## Embed thumbnails into media file
This will write or overwrite all thumbnails in the media file using the downloaded thumbnail. This is only necessary if you didn't download the files with the option *Embed Thumbnail* enabled or you want to make sure all media files get the newest thumbnail.

## ZIP file index backup
This will backup your metadata into a zip file. The file will get stored at `/cache/backup` and will contain the necessary files to restore the Elasticsearch index formatted **nd-json** files. For data consistency, make sure there aren't any other tasks running that will change the index during the backup process. This is very slow, particularly for large archives.

!!! danger "BE AWARE"
    This will **not** backup any media files. This is only for the metadata from the Elasticsearch database.

## Restore From Backup
The restore functionality will expect the same zip file in `/cache/backup` as created from the **Backup database** function. This will recreate the index from the zip archive file. There will be a list of all available backup to choose from. The *source* tag can have these different values:

- **manual**: For backups manually created from here on the settings page.
- **auto**: For backups automatically created via a sceduled task.
- **update**: For backups created after a **Tube Archivist** update due to changes in the index.
- **False**: Undefined.

!!! danger "BE AWARE"
    This will **replace** your current index with the one from the backup file. This won't restore any media files.

## Rescan Filesystem
This action will go through all your media files and looks at the whole index to try to find any issues:

- Should the filename not match with the indexed media url, this will rename the video files correctly and update the index with the new link.
- When you delete media files from the filesystem outside of the **Tube Archivist** interface, this will delete leftover metadata from the index.
- When you have media files that are not indexed yet, this will grab the metadata from YouTube as if it was a newly downloaded video. This can be useful when restoring from an older backup file with missing metadata but already downloaded mediafiles. NOTE: This only works if the media files are named in the same convention as **Tube Archivist** expects, alternatively see above for *Manual Media Files Import*.
- The task will stop when adding a video fails, for example if the video is no longer available on YouTube.
- This will also check all of your thumbnails and download any that are missing.

!!! danger "BE AWARE"
    There is no undo. Deleted references and metadata are removed and cannot be brought back without a restore operation.
