---
description: Home of the documentation, additional installation instructions and user guide. Recommended reading for all interested in the project.
---

# Tube Archivist
Welcome to the official Tube Archivist Docs. This is an up-to-date documentation of user functionality.

## Getting Started

1. [Subscribe](channels.md#channels-overview) to some of your favourite YouTube channels.
2. [Scan](downloads.md#rescan-subscriptions) subscriptions to add the latest videos to the download queue.
3. [Add](downloads.md#add-to-download-queue) additional videos, channels or playlist - ignore the ones you don't want to download.
4. [Download](downloads.md#download-queue) and let **Tube Archivist** do it's thing.
5. Sit back and enjoy your archived and indexed collection!

## General Navigation
* Clicking on the channel name or the channel icon brings you to the dedicated channel page to show videos from that channel.
* Clicking on a video title brings you to the dedicated video page and shows additional details.
* Clicking on a video thumbnail opens the video player and starts streaming the selected video.
* Clicking on the search icon <img src="assets/icon-search.png?raw=true" alt="gridview icon" width="20px" style="margin:0 5px;"> will open a dedicated search page to search over your complete index.
* The pagination - if available - builds links for up to 10'000 results, use the search, sort or filter functionality to find what you are looking for.

### Watched State
An empty checkbox icon <img src="assets/icon-unseen.png?raw=true" alt="unseen icon" width="20px" style="margin:0 5px;"> will show for videos you haven't marked as watched. Click on it and the icon will change to a filled checkbox <img src="assets/icon-seen.png?raw=true" alt="seen icon" width="20px" style="margin:0 5px;"> indicating it as watched - click again to revert.

### Display layout
- <img src="assets/icon-gridview.png?raw=true" alt="gridview icon" width="20px" style="margin:0 5px;">: Gridview icon will display the list in a grid. A grid row holds 3 items by default.
    - <img src="assets/icon-add.png?raw=true" alt="listview icon" width="20px" style="margin:0 5px;">: On larger screens, the plus icon adds more items to the grid row.
    - <img src="assets/icon-substract.png?raw=true" alt="listview icon" width="20px" style="margin:0 5px;">: The minus icon reduces items per row.  
- <img src="assets/icon-listview.png?raw=true" alt="listview icon" width="20px" style="margin:0 5px;">: The list view arranges the items in a list.
- <img src="assets/icon-tableview.png?raw=true" alt="gridview icon" width="20px" style="margin:0 5px;">: The tableview will allow you to get technical information like video codec, audio codec, filesize and image resolution of the listed videos.

### Sort
Toggle sort options by clicking on the <img src="assets/icon-sort.png?raw=true" alt="listview icon" width="20px" style="margin:0 5px;"> sort icon. This gives sort by options for: 

- Published: Date published
- Downloaded: Date downloaded
- Views: View count
- Likes: Like count
- Duration: Duration of the video
- Media Size: Mediasize on disk
- Width: In pixels
- Height: In pixels

Additionally you can change the sort order to:

- Desc: Descending
- Asc: Ascending

### Filter
The filter icon <img src="assets/icon-filter.png?raw=true" alt="gridview icon" width="20px" style="margin:0 5px;"> Shows options for filtering:

- Watched state: Show watched only, unwatched only or all.
    - That filter is individually between home page, channel and playlist videos.
- Types: By video types, that's regular videos, shorts or streams.
- Height: Media file height in pixels. That is useful for upgrading video resolutions or to verify if you downloaded the expected resolution. Works best in table view: <img src="assets/icon-tableview.png?raw=true" alt="gridview icon" width="20px" style="margin:0 5px;">.

### Multiselect
The multi select icon <img src="assets/icon-multi-select.png?raw=true" alt="gridview icon" width="20px" style="margin:0 5px;"> allows you to select multiple videos to then apply actions in bulk.

- Select/unselect videos individually by clicking on the checkbox overlay on the top left of the video thumbnail. In table view <img src="assets/icon-tableview.png?raw=true" alt="gridview icon" width="20px" style="margin:0 5px;">, the select checkbox is in the first column.
- An info box will indicate how many videos you have selected. The selection persists over page navigation and between different views.
- In tableview <img src="assets/icon-tableview.png?raw=true" alt="gridview icon" width="20px" style="margin:0 5px;"> an additional "select all" checkbox is show, to select all videos visible. That is dependent on your [Archive View Page Size](settings/user.md#archive-view-page-size). 
- The "clear" button will empty your selection.
- To avoid confusion when multiselect is active, the watched checkbox is hidden.
- Toggle the multiselect icon again to exit multiselect mode.

Then the actions currently supported:

- **Redownload**: This downloads and indexes the selected videos again. Also see [Downloads#re-download](downloads.md#re-download).

## Keyboard Shortcuts
You can control the video player with the following keyboard shortcuts:

- `?`: Show help
- `p`: Toggle play/pause
- `m`: Toggle mute
- `f`: Toggle fullscreen
- `c`: Toggle subtitles if available
- `>`: Increase playback speed
- `<`: Decrease playback speed
- `←` (left arrow): Jump back 5 seconds
- `→` (right arrow): Jump forward 5 seconds
