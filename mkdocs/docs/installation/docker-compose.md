# Setting up Tube Archivist with Docker  

## Overview  

**Tube Archivist** depends on three containers:

1. The **Tube Archivist** container running the main application
2. Redis for queue and cache storage
3. ElasticSearch for your index.

!!! info
    All environment variables are documented at [installation/Environment Variables](env-vars.md).

!!! info
    Also see [installation/Docker for Beginners](docker-for-beginners.md) explaining some core concepts of docker and docker compose.

**Tube Archivist** requires Docker. Please make sure that Docker is installed and running on your computer before continuing.  

Also see:  

- [faq/How do I install this natively?](../faq.md#how-do-i-install-this-natively)
- [faq/Where is the .exe/.rpm/.pkg/.msi/&lt;insert installer here&gt;?](../faq.md#where-is-the-exerpmpkgmsiinsert-installer-here).

For minimal system requirements, the **Tube Archivist** stack needs around 2GB of available memory for a small testing setup and around 4GB of available memory for a mid to large sized installation. Minimum requirements for CPU are usually expected to be dual core with 4 threads, with better performance coming from quad core and higher, and more available threads.

!!! info
    For **arm64**: **Tube Archivist** is built as a multi-architecture (multi-arch) container, same for Redis. Elasticsearch should use the official image for arm64 support. Other architectures are not supported.

!!! bug "Untested"
    ARM64 builds are essentially untested, as none of the devs have access to any ARM64 devices. There are regular unstable builds, for both architecture platforms. Help with testing to verify things are working as expected, also on ARM64.


Save the [docker-compose.yml](https://github.com/tubearchivist/tubearchivist/blob/master/docker-compose.yml) file from the **Tube Archivist** repository somewhere permanent on your system, keeping it named `docker-compose.yml`. You'll need to refer to it whenever starting this application.

## Install **Tube Archivist**

!!! Quickstart
    All you really _need_ to configure is the [`TA_HOST`](env-vars.md#ta_host) environment variable.

### Networking
The main container serves the interface on port `8000` with Nginx. Nginx is packaged in the container and serves the static files and handles proxy requests to the backend.

- For port collisions, see [Docker for Beginners/#networking](docker-for-beginners.md#networking).
- Alternatively to modify the port, see [Environment Variables/#TA_PORT](env-vars.md#ta_port)

The React TS based frontend is compiled and served by Nginx from the `static` folder.

The Python Django based backend is served with `uvicorn` on the container internal port `8080`.

- Only container internal. Nginx handles proxying requests to the backend
- To modify, see [Environment Variables/#TA_BACKEND_PORT](env-vars.md#ta_backend_port)

### Volumes
This container expects two volumes:

- `/cache`: That is not really a _cache_ any more now in the classical sense but holds persistent data like artwork and more.
- `/youtube`: Location for your downloaded video files.

## Install **Redis**

!!! danger "BE AWARE"
    Sharing the same Redis container between different projects is _not_ supported.

Redis functions as a cache and temporary link between the application and the file system. Redis is used to store and display messages and configuration variables. Redis is also responsible for keeping track of the queues.

  - Communicate by default over port `6379`
  - Needs a volume to allow persistence at `/data`.

### Redis on a custom port
For some environments, it might be required to run Redis on a non-standard port. For example, to change the Redis port to `6380`, set the following values:  

- For the *archivist-redis* service, set an additional key: `command: --port 6380` and update the `expose` value for your reference:
```yml
services:
  archivist-redis:
    [...]
    command: --port 6380
    expose:
      - "6380"
    [...]
```

- For the **Tube Archivist** service make sure to also update the [REDIS_CON](env-vars/#redis_con) value. e.g.: `redis://archivist-redis:6380`

## Install **ElasticSearch**
!!! success "Elasticsearch Version"
    **Tube Archivist** depends on Elasticsearch 8. 

Use `bbilly1/tubearchivist-es` to automatically get the recommended version, or use the official image with the version tag in the `docker-compose.yml` file.

Use the official Elasticsearch image for **arm64**.

Elasticsearch stores the video metadata and enables searchable functionality for all fields. Elasticsearch is also used to keep track of the download queue.

  - Needs to be accessible over the default port `9200`
  - Needs a volume to store persistent data linked to `/usr/share/elasticsearch/data`

Follow the [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html) for additional installation details and options.

### Elasticsearch on a custom port
Should you need to change the port for Elasticsearch to, for example `9500`, follow these steps:

  - Set the environment variable `http.port=9500` for the ES container
  - Change the `expose` value for the ES container to match your port number
  - For the TA container, change the `ES_URL` environment variable, i.e. `ES_URL=http://archivist-es:9500`  

## Support

If you're still having trouble, join us on [discord](https://www.tubearchivist.com/discord) and come to the [#support channel.](https://discord.com/channels/920056098122248193/1006394050217246772)
