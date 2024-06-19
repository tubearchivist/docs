# Download

## Download Queue List
**GET** `/api/download/`

Parameter:  

- filter: pending, ignore
- channel: channel-id

Add list of videos to download queue:  
**POST** `/api/download/`
```json
{
    "data": [
        {"youtube_id": "NYj3DnI81AQ", "status": "pending"}
    ]
}
```
Parameter:

- autostart: true

This value must be posted with the header `"Content-Type: application/json"`

Delete download queue items by filter:  
**DELETE** `/api/download/?filter=ignore`  
**DELETE** `/api/download/?filter=pending`

## Download Queue Item
**GET** `/api/download/<video_id>/`  
**POST** `/api/download/<video_id>/`

Ignore video in download queue:
```json
{
    "status": "ignore"
}
```

Add to queue previously ignored video:
```json
{
    "status": "pending"
}
```

Download existing video now:
```json
{
    "status": "priority"
}
```

**DELETE** `/api/download/<video_id>/`  
Forget or delete from download queue
