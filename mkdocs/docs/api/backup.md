# Backup

Index [snapshots](snapshot.md) are a more reliable way than zip file backup as described here.

## Backup List
**GET** `/api/backup/`  
Return a list of available backup files with metadata.

**POST** `/api/backup/`  
Start a backup task now. This will return immediately, triggering an async task in the background. The message will contain a `task_id` key that can be monitored separately.

Example return message:
```json
{
	"message": "backup task started",
	"task_id": "f22f6981-35bb-4b7c-bd91-80a57d960b52"
}
```

## Backup Item
**GET** `/api/backup/<filename>/`  
Return metadata of a single backup file.

**POST** `/api/backup/<filename>/`  
Start a backup restore task now. This will return immediately, triggering an async task in the background. The message will contain a `task_id` key that can be monitored separately.

Example return message:

```json
{
	"message": "backup restore task started",
	"filename": "ta_backup-20231101-auto.zip",
	"task_id": "4fc2afdf-4045-4288-a33c-e3267a9efb5a"
}
```

**DELETE** `/api/backup/<filename>/`  
Delete backup file from the filesystem.
