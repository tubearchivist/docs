# Video


## Video List
**GET** `/api/video/`

## Video Item
**GET** `/api/video/<video_id>/`  
**DELETE** `/api/video/<video_id>/`

## Video Comment
**GET** `/api/video/<video_id>/comment/`  

## Video Similar
**GET** `/api/video/<video_id>/similar/`  

## Video Progress
`/api/video/<video_id>/progress/`  

Progress is stored for each user.

Get last player position of a video:  
**GET** `/api/video/<video_id>/progress/`
```json
{
    "youtube_id": "<video_id>",
    "user_id": 1,
    "position": 100
}
```

Update player position of video:  
**POST** `/api/video/<video_id>/progress/`
```json
{
    "position": 100
}
```

Delete player position:  
**DELETE** `/api/video/<video_id>/progress/`  


## Sponsor Block
`/api/video/<video_id>/sponsor/`

Integrate with sponsorblock

Get list of segments:  
**GET** `/api/video/<video_id>/sponsor/`


!!! note
    Writing to Sponsorblock enpoints is only simulated for now and won't forward any requests. This needs some clever UI/UX implementation first.

Vote on existing segment:  
**POST** `/api/video/<video_id>/sponsor/`
```json
{
    "vote": {
        "uuid": "<uuid>",
        "yourVote": 1
    }
}
```
yourVote needs to be *int*: 0 for downvote, 1 for upvote, 20 to undo vote

Create new segment
**POST** `/api/video/<video_id>/sponsor/`
```json
{
    "segment": {
        "startTime": 5,
        "endTime": 10
    }
}
```
Timestamps either *int* or *float*, end time can't be before start time.
