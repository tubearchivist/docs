---
description: Collection of advanced concepts and debug info.
---

# Advanced Notes

!!! warning "Check Your Backups"
	As a general rule of thumb, make sure your backups are up to date before continuing with anything here.

A loose collection of advanced debug info and actions for experienced users for troubleshooting and resolving issues. The situation or command may or may not apply to you, so only use this when you know what you are doing or as directed. Some of the below functionality might get implemented in the future in the regular UI.

## Reactivate documents
As part of the metadata refresh task, **Tube Archivist** will mark videos, channels and playlists as deactivated if they are no longer available on YouTube. Sometimes, they may be marked as deactivated when they shouldn't have, for example if a video got reinstated after a copyright strike on YT or because your requests from yt-dlp are getting blocked.  

You can reactivate all items in bulk so the refresh task will check them again and deactivate the ones that are actually not available anymore.

Curl commands to run within the TA container to reactivate documents:

??? bug "Videos"

    ```bash
	curl -XPOST "$ES_URL/ta_video/_update_by_query?pretty" -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" -d '
	{
	"query": {
		"term": {
			"active": {
				"value": false
			}
		}
	},
	"script": {
		"source": "ctx._source.active = true",
		"lang": "painless"
	}
	}'
	```

??? bug "Channels"

	```bash
	curl -XPOST "$ES_URL/ta_channel/_update_by_query?pretty" -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" -d '
	{
	"query": {
		"term": {
			"channel_active": {
				"value": false
			}
		}
	},
	"script": {
		"source": "ctx._source.channel_active = true",
		"lang": "painless"
	}
	}'
	```

??? bug "Playlists"

	```bash
	curl -XPOST "$ES_URL/ta_playlist/_update_by_query?pretty" -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" -d '
	{
	"query": {
		"term": {
			"playlist_active": {
				"value": false
			}
		}
	},
	"script": {
		"source": "ctx._source.playlist_active = true",
		"lang": "painless"
	}
	}'
	```

## Corrupted ES index reset
After a hard reset of your server, or any other hardware failure, you might experience data corruption. ES can be particularly unhappy about that, especially if the reset happens while it is actively writing to disk. It's very likely that only your `/indices` folder got corrupted, as that is where the regular read/writes happen. Luckily you have your [snapshots](settings/application.md#snapshots) set up.

!!! warning
	Confirm you have an available, recoverable snapshot prior to performing this action.

ES will not start, if the data is corrupted. So, stop all containers, delete everything *except* the `/snapshot` folder in the ES volume. After that, start everything back up. **Tube Archivist** will create a new blank index. All your snapshots should be available for restore on your settings page, you probably want to restore the most recent one. After restore, run a [filesystem rescan](settings/actions.md#rescan-filesystem) for good measure.

## ES mapping migrations troubleshooting

**Tube Archivist** will apply mapping changes at application startup for certain versions. That usually is needed when changing how an existing field is indexed. This action should be seamless and automatic, but can leave your index in a messed up state if that process gets interrupted for any reason. Common reasons could be that if you artificially limit the memory to the container, disabling the OS to dynamically manage that, or if you don't have enough available storage on the ES volume, or if you interrupt that because of your impatience (don't do that).

In general the mapping update process is as follows:

1. Compare existing mapping with predefined expected mapping
	- If that is identical, there is nothing to do
2. If the difference is just adding a new field, that is simply added in place
3. If the difference is a change in how an existing field is indexed, that needs a index rebuild:
	- Reindex into a new index by appending a version to the index nummer, e.g. `ta_video_v2`.
	- That will also remove any no longer needed fields.
	- Delete the old index
	- Create an alias to point all new requests to the new version of the index

If you are not sure if anything is happening, you can monitor your index and `docs.count` value for each index. Those values should change over time during the process and you should get an indicator of progress happening:

From within the ES container:

```bash
curl -u elastic:$ELASTIC_PASSWORD "localhost:9200/_cat/indices?v&s=index"
```

## Manual yt-dlp update
!!! warning 
	Doing this is **very likely** going to break things for you. You will want to try this out on a testing instance first. Regularly there have been subtle changes in the yt-dlp API, so only do this if you know how to debug this project by yourself, but obviously share your fixes so any problems can be dealt with before release.

!!! info
	There are also [unstable builds](https://github.com/tubearchivist/tubearchivist/blob/master/CONTRIBUTING.md#beta-testing) available, they might already have the latest yt-dlp version.

This project strives for timely updates when yt-dlp makes a new release, but sometimes ideals meet reality. Also, sometimes yt-dlp has a fix published, but not yet released.

To update, set the [TA_AUTO_UPDATE_YTDLP](installation/env-vars.md#ta_auto_update_ytdlp) environment variable and restart your container. If this makes things worse and you wish to undo the update, unset the variable and recreate your container.
