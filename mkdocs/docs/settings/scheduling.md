---
description: Configure the scheduler.
---

# Scheduling Settings Page
Accessible at `/settings/scheduling/` of your **Tube Archivist** instance, this page holds all the configuration settings for scheduled tasks.

!!! tip "Saving Configurations"
    Click on **Update Scheduler Settings** at the bottom of the page to apply your configurations.

## Configuring Schedules
The scheduler settings expect a cron-like format, where the first value is the minute, second is the hour and third is day of the week as a number. Day 0 is Sunday, day 1 is Monday etc.

- New schedules will take effect automatically within a few seconds after saving the form.
- The schedule is validated before saving, you'll see an error message if you try to save an invalid schedule.
- Use the **delete** button to remove a schedule.


??? "Examples"

    - `0 15 *`: Run task every day at 3 in the afternoon.
    - `30 8 */2`: Run task every second day of the week (Sun, Tue, Thu, Sat) at 08:30 in the morning.
    - `0 */3,8-17 *`: Run task every hour divisible by 3, and every hour during office hours (8 in the morning - 5 in the afternoon).
    - `0 8,16 *`: Run task every day at 8 in the morning and at 4 in the afternoon.
    - `auto`: Sensible default. Each configuration has a default that is defined by the application's Schedule Builder.

!!! warning "BE AWARE"
    - Schedule is tied to the timezone you set with the `TZ` environment variable.
    - Cron format as *number*/*number* are non-standard cron formatting and are not supported by the scheduler. For example `0 0/12 *` is invalid, use `0 */12 *` instead.
    - Avoid an unnecessary or frequent schedule to reduce likelihood of being blocked or throttled by YouTube. Because of this, the scheduler doesn't support schedules that trigger more than once per hour.

### Rescan Subscriptions
This initiates the same task that can be initiated from the [Downloads Page](../downloads.md#rescan-subscriptions). This will go through each of your subscribed channels and playlists and will add missing videos to the download queue.

Become a sponsor and join [members.tubearchivist.com](https://members.tubearchivist.com/) to get access to *real time* notifications for new videos uploaded by your favorite channels.

### Start download
Start downloading all videos currently in the download queue.

### Refresh Metadata
Rescan videos, channels and playlists on YouTube and update metadata periodically. This will also refresh your subtitles and comments based on your current settings. If an item is no longer available on YouTube, this will deactivate it and exclude it from future refreshes. This task is meant to be run once per day, set your schedule accordingly.

The field **Refresh older than x days** takes a number where **Tube Archivist** will consider an item as *outdated*. This value is used to calculate how many items need to be refreshed today based on the total indexed. This will spread out the requests to YouTube. The default value here is **90** days.

In addition to any outdated documents, this will also refresh very recently published videos. This is to keep metadata and statistics up-to-date during the first few days when the video goes live.

### Thumbnail check
This will check if all expected thumbnails are present and will delete any artwork without a matching video.

### ZIP file index backup
Create a zip file of the metadata and select **Max auto backups to keep** to automatically delete old backups created from this task. For data consistency, make sure there aren't any other tasks running that will change the index during the backup process. This is very slow, particularly for large archives. Use [snapshots](application.md#snapshots) instead.

!!! tip "Saving Configurations"
    Click on **Update Scheduler Settings** at the bottom of the page to apply your configurations.

## Notifications
Some of the tasks support sending notifications at task completion with a short summary message. Tasks can get started through the scheduler or manually from the interface. This uses the amazing [Apprise](https://github.com/caronc/apprise) framework. Refer to the wiki about the [basics](https://github.com/caronc/apprise/wiki/URLBasics) of how to build links and a list of [supported services](https://github.com/caronc/apprise/wiki#notification-services) for the details.

Send yourself a test notification to verify your link works, e.g.:
```bash
docker exec -it tubearchivist apprise -b "Hello from TA" <link>
```

!!! note "Notes:"
    - This will only send notifications when a task returns anything, e.g. if a [Rescan Subscriptions](#rescan-subscriptions) task doesn't find any new videos to add, **no** notification will will be sent.
    - Due to the fact that Apprise is running inside a container, [desktop notifications](https://github.com/caronc/apprise/wiki#desktop-notification-services) will not work.
    - Notification services that require additional libraries that what is provided by Apprise are not supported. If you really *need* to use services that require additional libraries, you can use Apprise in a standalone server as a proxy or manually install what you need in the container.
    - You can add mutiple notifications for the same task by saving and selecting the same task multiple times.
