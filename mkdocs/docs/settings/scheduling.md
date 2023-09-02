---
description: Configure the scheduler.
---

# Scheduling Settings Page
Accessible at `/settings/scheduling/` of your **Tube Archivist**, this page holds all the configuration for scheduled tasks.

Click on **Update Scheduler Settings** at the bottom of the page to apply your configurations.

## Configuring Schedules
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

## Notifications
Some of the tasks support sending notifications at task completion with a short summary message. Tasks can get started through the scheduler or manually from the interface. This uses the amazing [Apprise](https://github.com/caronc/apprise) framework, refer to the wiki about the [basics](https://github.com/caronc/apprise/wiki/URLBasics) how to build links and a list of [supported services](https://github.com/caronc/apprise/wiki#notification-services) for the details.

Send yourself a test notification to verify your link works, e.g.:
```bash
docker exec -it tubearchivist apprise -b "Hello from TA" <link>
```

Notes:

- This will only send notifications when a task returns anything, e.g. if a [Rescan Subscriptions](#rescan-subscriptions) task doesn't find any new videos to add, no notification will get sent.
- Due to the fact that apprise is running inside a docker container, [desktop notifications](https://github.com/caronc/apprise/wiki#desktop-notification-services) will not work.
- Add one per line.

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
Create a zip file of the metadata and select **Max auto backups to keep** to automatically delete old backups created from this task. For data consistency, make sure there aren't any other tasks running that will change the index during the backup process. This is very slow, particularly for large archives. Use [snapshots](application.md#snapshots) instead.
