---
description: Frequently asked questions about what this project is, what it tries and what it doesn't try to do.
---

# Frequently Asked Questions

## What is the scope of this project?
Tube Archivist is *Your self hosted YouTube media server*, which also defines the primary scope of what this project tries to do:

- **Self hosted**: This assumes you have full control over the underlying operating system and hardware and can configure things to work properly with Docker, it's volumes and networks as well as whatever disk storage and filesystem you choose to use.
- **YouTube**: Downloading, indexing and playing videos from YouTube, there are currently no plans to expand this to any additional platforms.
- **Media server**: This project tries to be a stand alone media server in it's own web interface.

Additionally to that, progress is also happening on:

- **API**: Endpoints for additional integrations.
- **Browser Extension**: To integrate between youtube.com and Tube Archivist.

Defining the scope is important for the success of any project:

- A scope too broad will result in development effort spreading too thin and will run into danger that his project tries to do too many things and none of them well.
- A too narrow scope will make this project uninteresting and will exclude audiences that could also benefit from this project.
- Not defining a scope will easily lead to misunderstandings and false hopes of where this project tries to go.

Of course this is subject to change: The scope can be expanded as this project continues to grow and more people contribute.

## How do I import my videos to Emby-Plex-Jellyfin-Kodi?
Although there are similarities between these excellent projects and Tube Archivist, they have a very different use case. Trying to fit the metadata relations and database structure of a YouTube archival project into these media servers that specialize in Movies and TV shows is always going to be limiting.

Part of the scope is to be its own media server, to be able to overcome these limitations, so that's where the focus and effort of this project is. That being said, the nature of self hosted and open source software gives you all the possible freedom to use your media as you wish.

- **Jellyfin**: There is an API to API integration available to sync metadata from Tube Archivist to Jellyfin: [tubearchivist/tubearchivist-jf](https://github.com/tubearchivist/tubearchivist-jf). Follow the instructions there. Please contribute to improve this integration.
- **Plex**: There is a Plex Scanner and Agent combination that allows integration between Tube Archivist and Plex: [tubearchivist/tubearchivist-plex](https://github.com/tubearchivist/tubearchivist-plex). Follow the instructions there. Please contribute to improve this integration.

## How do I install this natively?
This project is a classical Docker application: There are multiple moving parts that need to be able to interact with each other and need to be compatible with multiple architectures and operating systems. Additionally Docker also drastically reduces development complexity which is highly appreciated.  

Docker is the only supported installation method. If you don't have any experience with Docker, consider investing the time to learn this very useful technology. Alternatively you can find user provided installation instructions for Podman [here](installation/podman.md).

## How do I finetune ElasticSearch?
A recommended configuration of Elasticsearch (ES) is provided in the example docker-compose.yml file. ES is highly configurable and very interesting to learn more about. Refer to the [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html) if you want to get into it.  

All testing is done with the recommended configuration, changing that can create hard to debug and randomly occurring problems, use at your own risk.

## Why Elasticsearch?
That might be an unconventional choice at first glance. Tube Archivist is built to scale to 100k+ videos without slowing down and to 1M+ with only minimal impact on performance, and that all with full text indexing and searching over your subtitles and comments. Elasticsearch is the industry standard <sup>[citation needed]</sup> for a task like that and through its structured query language allows for a very flexible interface to query the index.

That comes at a price: ES can use a lot of memory, particularly on a big index, and will heavily use in memory cached queries to be able to respond within milliseconds, even when searching through multiple GBs of raw text.

## Why does subscribing to a channel not download the complete channel?
For Tube Archivist, these are two different things: To download a complete channel, add it to the [download queue](downloads.md#add-to-download-queue) with the form or with [Tube Archivist Companion](https://github.com/tubearchivist/browser-extension), the browser extension. This is meant for a complete archival.  

Subscribing to a channel is for downloading new videos as they come out. That is designed to be as quick as possible, to allow you to efficiently rescan your favourite channels frequently. This will add videos to your download queue based on your [channel page size](settings/application.md#subscriptions).

If you want to archive the complete channel **and** any future videos, you can do both.

## How do I tunnel all traffic from this container?
Using a Proxy/VPN can be advantages for heavy users of this project. Some users have reported throttling issues from residential IP address ranges. You might be able to avoid that with a shared IP from a Proxy/VPN.

This project doesn't make any recommendations: Some people prefer to convert their home router to a VPN client, some have a home firewall capable of routing traffic, some prefer to set up their host network as a client and others prefer to use a networking container to tunnel container traffic through. Some prefer one of the many proxy protocols, others use various OpenVPN configurations, others use WireGuard.

There are too many variations of that problem to be implemented in this project, use any of the various solutions out there that fits your needs.

## Why is there no flexible naming structure?
Unlike other similar projects, Tube Archivist needs to keep track of its media files indefinitely while everything can change: Channel names and aliases and titles regularly change over time. Previous attempts failed at handling that properly and the metadata refresh task kept failing because of that.

This project tries to be compatible with as many filesystem/OS variations out there as possible. Using channel names and titles to build file paths that can be any Unicode character is a flawed and highly error prone approach of doing that, there is always a filesystem/OS out there that proves to be incompatible with how something is named.

That's why this project has landed on `<channel-id>/<video-id>.mp4`. These values are guaranteed to be static, are guaranteed to be compatible with every filesystem out there and make things predictable where all files will go on every instance of Tube Archivist indefinitely.

For browsing these files you have the fancy interface provided by this project, or use a supported integration as stated above. If you really want to you could easily also create your own file naming structure with the API and symlinks, but that is not part of the scope of this project.

## Does this project implement feature X?
Generic answer to that question is:

- If it's documented, it's implemented.

And the reverse would be:

- If it's *not* documented, it's (probably) *not* implemented.

Read the [docs](https://docs.tubearchivist.com/) with a comprehensive overview of what this project does. If something is missing in the docs, add it there. Check the roadmap and open feature requests on GH for what is planned. Make sure to read how to open a [feature request](https://github.com/tubearchivist/tubearchivist/blob/master/CONTRIBUTING.md) before adding your own.
