# Statistics API endpoints

⚠️ **Experimental**  
All stats endpoints are considered experimental.

## Video

**GET** `/api/stats/video/`

Get stats for your downloaded videos.

## Channel

**GET** `/api/stats/channel/`

Get stats for your channels.

## Playlist

**GET** `/api/stats/playlist/`

Get stats for your playlists.

## Download

**GET** `/api/stats/download/`

Get stats for your download queue.

## Watch Progress

**GET** `/api/stats/watch/`

Get statistics over your watch progress.

## Download History

**GET** `/api/stats/downloadhist/`

Get statistics for last days download history.

## Biggest Channels

**GET** `/api/stats/biggestchannels/`

Get a list of biggest channels, specify *order* parameter.

Parameter:  

- order: doc_count (default), duration, media_size
