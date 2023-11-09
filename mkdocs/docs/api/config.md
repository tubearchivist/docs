# Config

## User Config
Per user modified config values.

**GET** `/api/config/user/`  
Return all config values *modified* by user.

**POST** `/api/config/user/`  
Modify one or more config values. For possible key, values, see `UserConfig` class.

Example post data:
```json
{
    "colors": "dark",
    "page_size": 20
}
```
