---
description: Collection of advanced concepts and debug info.
---

# Advanced Notes

!!! note
	As a general rule of thumb, make sure your backups are up to date before continuing with anything here.

A loose collection of advanced debug info, may or may not apply to you, only use this when you know what you are doing. Some of that functionality might get implemented in the future in the regular UI.

## Reactivate documents
As part of the metadata refresh task, Tube Archivist will mark videos, channels and playlists as deactivated, if they are no longer available on YouTube. For some reasons, that might have deactivated something that shouldn't have, for example if a video got reinstated after a copyright strike on YT. You can reactivate all things in bulk, so the refresh task will check them again and deactivate the ones that are actually not available anymore.

Curl commands to run within the TA container to reactivate documents:

??? Videos

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

??? Channels

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

??? Playlists

	```bash
	curl -XPOST "$ES_URL/ta_video/_update_by_query?pretty" -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" -d '
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
After a hard reset of your server or any other hardware failure you might experience data corruption. ES can be particularly unhappy about that, especially if the reset happens during actively writing to disk. It's very likely that only your `/indices` folder got corrupted, as that is where the regular read/writes happen. Luckily you have your [snapshots](settings/application.md#snapshots) set up.

ES will not start, if the data is corrupted. So, stop all containers, delete everything *except* the `/snapshot` folder in the ES volume. After that, start everything back up. Tube Archivist will create a new blank index. All your snapshots should be available for restore on your settings page, you probably want to restore the most recent one. After restore, run a [filesystem rescan](settings/actions.md#rescan-filesystem) for good measures.

## ES mapping migrations troubleshooting

Tube Archivist will apply mapping changes at application startup. That usually is needed when changing how an existing field is indexed. That should be seamless and automatic, but can leave your index in a messed up state if that process gets interrupted for any reason. Common reasons could be that if you artificially limit the memory to the container, disabling the OS to dynamically manage that, or if you don't have enough available storage on the ES volume, or if you interrupt that because of your impatience (don't do that).

In general the process is:

- Compare existing mapping with predefined expected mapping
- If that is identical, there is nothing to do
- Else create a `_backup` of the existing index
- Delete the original index and create a new empty one with the new mapping in place
- Copy over the previously created `_backup` index to apply the new mappings
- Delete the now leftover `_backup` index.

If you are not sure if anything is happening, you can monitor your index and `docs.count` value for each index, that should change over time during that process and you should get an indicator of progress happening:

From within the ES container:

```bash
curl -u elastic:$ELASTIC_PASSWORD "localhost:9200/_cat/indices?v&s=index"
```

If that process gets interrupted before deleting the `_backup` index and you try to run this again, you will see an error like `resource_already_exists_exception` for example `index [ta_comment_backup/...] already exists` indicating in this case that your migration previously failed for the `ta_comment` index.

First make sure you have the original index still with the command above, after verifying that, stop the TA container then you can delete the `_backup` index e.g. in the case of `ta_comment_backup`.

```bash
curl -XDELETE -u elastic:$ELASTIC_PASSWORD "localhost:9200/ta_comment_backup?pretty"
```

and you should get:
```json
{
  "acknowledged" : true
}
```

Then you can start everything again and the migration will run again. If your error persists, the ES and TA logs should give additional debug info.

## Manual yt-dlp update
This project strives for timely updates when yt-dlp makes a new release, but sometimes ideals meet reality. Also sometimes yt-dlp has a fix published, but not yet released.

Doing this is **very likely** going to break things for you. You will want to try this out on a testing instance first. Regularly there have been subtle changes in the yt-dlp API, so only do this if you know how to debug this project by yourself, but obviously share your fixes so any problems can be dealt with before release.

**Build your own image**: Update the version in `requirements.txt` and rebuild the image from `Dockerfile`. This will use your own image, even on container rebuild.

**Update yt-dlp on its own**: You can also update the yt-dlp library alone in the container.

- Restart your container for changes to take effect.
- These changes won't persist a container rebuild from image.

Update to newest regular yt-dlp release:

```
pip install --upgrade yt-dlp
```

To update to nightly you'll have to specify the correct `--target` folder:
```
pip install \
    --upgrade \
    --target=/root/.local/bin \
    https://github.com/yt-dlp/yt-dlp/archive/master.tar.gz
```
This is obviously particularly likely to create problems. Also note that the `--version` command will only show the latest regular release, not a nightly mention.

## Erase errors from download queue
Sometimes the download queue might have some videos that have errored due to rate limits. Videos that have errors won't be retried in a future download queue re-run unless you individually click "Download now" for each individual video. In order to bulk clear the errors from the download queue one needs to execute the following command:
```bash
curl -X POST "$ES_URL/ta_download/_update_by_query?pretty" -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -d'
{
  "script": {
    "source": "ctx._source.message = null",
    "lang": "painless"
  },
  "query": {
    "match_all": {}
  }
}
'
```
