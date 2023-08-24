# Channel

## Channel List
`/api/channel/`

Parameter:  

- filter: subscribed

Subscribe/Unsubscribe to a list of channels:  
**POST** `/api/channel/`
```json
{
    "data": [
        {"channel_id": "UC9-y-6csu5WGm29I7JiwpnA", "channel_subscribed": true}
    ]
}
```

## Channel Search
**GET** `/api/channel/?q=`

Parameter:
- q: Query to search channel

## Channel Item
**GET** `/api/channel/<channel_id>/`  
**DELETE** `/api/channel/\<channel_id>/`  

- Will delete channel with all it's videos

## Channel Videos
**GET** /api/channel/\<channel_id>/video/
