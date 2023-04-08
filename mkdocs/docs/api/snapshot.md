# Snapshot

## Snapshot List
**GET** `/api/snapshot/`  
Return snapshot config and a list of available snapshots.

```json
{
    "next_exec": epoch,
    "next_exec_str": "date_str",
    "expire_after": "30d",
    "snapshots": []
}
```

**POST** `/api/snapshot/`  
Create new snapshot now, will return immediately, task will run async in the background, returns snapshot name: 
```json
{
    "snapshot_name": "ta_daily_<random-id>"
}
```

## Snapshot Item View
**GET** `/api/snapshot/<snapshot-id>/`  
Return metadata of a single snapshot
```json
{
    "id": "ta_daily_<random-id>",
    "state": "SUCCESS",
    "es_version": "0.0.0",
    "start_date": "date_str",
    "end_date": "date_str",
    "end_stamp": epoch,
    "duration_s": 0
}
```

**POST** `/api/snapshot/<snapshot-id>/`  
Restore this snapshot

**DELETE** `/api/snapshot/<snapshot-id>/`  
Remove this snapshot from index
