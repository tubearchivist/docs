---
description: Collection of advanced concepts and debug info.
---

# Advanced Notes

!!! note
	As a general rule of thumb, make sure your backups are up to date before continuing with anything here.

A loose collection of advanced debug info, may or may not apply to you, only use this when you know what you are doing. Some of that functionality might get implemented in the future in the regular UI.

## Reactivate all Videos
As part of the metadata refresh task, Tube Archivist will mark videos as deactivated, if they are no longer available on YouTube. For some reasons, that might have deactivated videos that shouldn't have, for example if a video got reinstated after a copyright strike on YT. You can reactivate all videos in bulk, so the refresh task will check them again and deactivate the ones that are actually not available anymore.

Run this curl command from within the TA container:

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

## Corrupted ES index reset
After a hard reset of your server or any other hardware failure you might experience data corruption. ES can be particularly unhappy about that, especially if the reset happens during actively writing to disk. It's very likely that only your `/indices` folder got corrupted, as that is where the regular read/writes happen. Luckily you have your [snapshots](settings.md#snapshots) set up.

ES will not start, if the data is corrupted. So, stop all containers, delete everything *except* the `/snapshot` folder in the ES volume. After that, start everything back up. Tube Archivist will create a new blank index. All your snapshots should be available for restore on your settings page, you probably want to restore the most recent one. After restore, run a [filesystem rescan](settings.md#rescan-filesystem) for good measures.
