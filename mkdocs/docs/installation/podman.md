!!! abstract "Installation Instructions - Community Guides"
    These are beginner's guides/installation instructions for additional platforms generously provided by users of these platforms. When in doubt, verify the details with the [project README](https://github.com/tubearchivist/tubearchivist#installing). If you see any issues here while using these instructions, please contribute.

Podman handles some things slightly differently than Docker, so you need to make a few changes to the `docker-compose.yml` to get up and running.

### Installation Changes from Compose Instructions

Follow the installation instructions for [Docker Compose](docker-compose.md), edit the `docker-compose.yml` with these additional changes:

#### Configure Pod

Add the following to the bottom of your compose file so that all the containers will reside within the same pod:

``` yaml
x-podman:
    in_pod: true
```

This will allow the containers to share the same network namespace. Tube Archivist, Redis, and ElasticSearch will be able to communicate with each other using localhost (127.0.0.1) or their container names using DNS. Check here for more information on [Pod Networking](https://github.com/containers/podman/blob/main/docs/tutorials/basic_networking.md#communicating-between-containers-and-pods)

#### Image URL

For each of the container `image` tags prefix the container name with `docker.io/` (or your container registry of choice).

#### Redis & ElasticSearch Ports

For `archivist-redis` and `archivist-es` remove the whole `expose: ["<PORT>"]` entry as it is not needed when running in a pod.

#### Auto Restarting Containers (optional)

To enable starting of containers after reboots you can either:

* Enable the systemd podman restart service

    ``` shell
    systemctl enable podman-restart.service
    ```

    ``` yaml
        restart: unless-stopped
    ```

    ``` yaml
        restart: always
    ```

* Start your pod directly with systemd quadlets.

[Podman systemd Docs](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html)

### Support

If you're still having trouble, join us on [discord](https://www.tubearchivist.com/discord) and come to the [#support channel.](https://discord.com/channels/920056098122248193/1006394050217246772)
