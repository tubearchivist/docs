!!! note
    These are beginner's guides/installation instructions for additional platforms generously provided by users of these platforms. When in doubt, verify the details with the [project README](https://github.com/tubearchivist/tubearchivist#installing-and-updating). If you see any issues here while using these instructions, please contribute. 

Podman handles container hostname resolving slightly differently than docker, so you need to make a few changes to the `docker-compose.yml` to get up and running.

### Follow the installation instructions from the [README](https://github.com/tubearchivist/tubearchivist#installing-and-updating), with a few additional changes to the `docker-compose.yml`.

Edit these additional changes to the `docker-compose.yml`:  

  - under `tubearchivist`->`image`:
    - prefix the container name with `docker.io/` (or the url of your repo of choice).
  - under `tubearchivist`->`environment`:
  - `ES_URL`: change `archivist-es` to the internal IP of the computer that will be running the containers.
  - `REDIS_HOST`: change `archivist-redis` to the internal IP of the computer that will be running the containers (should be the same as above).
  - under `archivist-redis`->`image`: 
 	- prefix the container name with `docker.io/` again.
  - under `archivist-redis`->`expose`: 
    - change the whole entry from `expose: ["<PORT>"]` into `ports: ["<PORT>:<PORT>"].
  - under `archivist-es`->`image`: 
 	- prefix the container name with `docker.io/` again.
  - under `archivist-es`->`expose`: 
  - change the whole entry from `expose: ["<PORT>"]` into `ports: ["<PORT>:<PORT>"].

### Create service files (optional)

Since podman doesn't run as a service, it can't start containers after reboots, at least not without some help.

If you want to enable this behavior, you can follow [this example](https://techblog.jeppson.org/2020/04/create-podman-services-with-podman-compose/) to have `systemd` start up the containers with `podman-compose` when the computer boots up.
