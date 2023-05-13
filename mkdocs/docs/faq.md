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

- **Jellyfin**: There is a proof of concept script for linking these two APIs together and to populate metadata from Tube Archivist to Jellyfin: [tubearchivist/jellyfin](https://github.com/tubearchivist/jellyfin). Please contribute to improve this integration.

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
For Tube Archivist, these are two different things: To download a complete channel, add it to the [download queue](downloads/#add-to-download-queue) with the form or with [Tube Archivist Companion](https://github.com/tubearchivist/browser-extension), the browser extension. This is meant for a complete archival.  

Subscribing to a channel is for downloading new videos as they come out. That is designed to be as quick as possible, to allow you to efficiently rescan your favourite channels frequently. This will add videos to your download queue based on your [channel page size](settings/#subscriptions).

If you want to archive the complete channel **and** any future videos, you can do both.

## How do I tunnel all traffic from this container?
Using a Proxy/VPN can be advantages for heavy users of this project. Some users have reported throttling issues from residential IP address ranges. You might be able to avoid that with a shared IP from a Proxy/VPN.

This project doesn't make any recommendations: Some people prefer to convert their home router to a VPN client, some have a home firewall capable of routing traffic, some prefer to set up their host network as a client and others prefer to use a networking container to tunnel container traffic through. Some prefer one of the many proxy protocols, others use various OpenVPN configurations, others use WireGuard.

There are too many variations of that problem to be implemented in this project, use any of the various solutions out there that fits your needs.
