!!! abstract "Installation Instructions - Community Guides"
    These are beginner's guides/installation instructions for additional platforms generously provided by users of these platforms. When in doubt, verify the details with the [project README](https://github.com/tubearchivist/tubearchivist#installing). If you see any issues here while using these instructions, please contribute. 

Podman handles container hostname resolution slightly differently than Docker, so you need to make a few changes to the `docker-compose.yml` to get up and running.

### Installation Changes from Compose Instructions

Follow the installation instructions for [Docker Compose](docker-compose.md), with a few additional changes to the `docker-compose.yml`.

Edit the `docker-compose.yml` with these additional changes:  

#### Tube Archivist

  - under `tubearchivist` > `image`:
    prefix the container name with `docker.io/` (or the url of your container registry of choice).
  - under `tubearchivist` > `environment`:
    `ES_URL`: change `archivist-es` to reflect the internal IP of the computer that will be running the containers.
    `REDIS_HOST`: change `archivist-redis` to reflect the internal IP of the computer that will be running the containers (should be the same as above).

#### Redis

  - under `archivist-redis` > `image`: 
 	  prefix the container name with `docker.io/` again.
  - under `archivist-redis` > `expose`: 
    change the whole entry from `expose: ["<PORT>"]` into `ports: ["<PORT>:<PORT>"]`.
    > ???+ example
           `ports: ["6379:6379"]`

#### Elasticsearch

  - under `archivist-es` > `image`: 
 	  prefix the container name with `docker.io/` again.
  - under `archivist-es` > `expose`: 
    change the whole entry from `expose: ["<PORT>"]` into `ports: ["<PORT>:<PORT>"]`.
    > ???+ example
           `ports: ["9200:9200"]`

### Create service files (optional)

Since Podman doesn't run as a service, it can't start containers after reboots without some additional configuration.

If you want to enable this behavior, you can follow [this example](https://techblog.jeppson.org/2020/04/create-podman-services-with-podman-compose/) to have `systemd` start up the containers with `podman-compose` when the computer boots up.

### Support

If you're still having trouble, join us on [discord](https://www.tubearchivist.com/discord) and come to the [#support channel.](https://discord.com/channels/920056098122248193/1006394050217246772)
