# Setting up Tube Archivist with Docker  

**Tube Archivist** requires Docker. Please make sure that Docker is installed and running on your computer before continuing.
Docker is required because **Tube Archivist** depends on three main components split up into separate containers. Solutions that do not utilize the containers are largely untested and unsupported.

For minimal system requirements, the **Tube Archivist** stack needs around 2GB of available memory for a small testing setup and around 4GB of available memory for a mid to large sized installation. Minimum requirements for CPU are usually expected to be dual core with 4 threads, with better performance coming from quad core and higher, and more available threads.

!!! info
    For **arm64**: **Tube Archivist** is built as a multi-architecture (multi-arch) container, same for Redis. Elasticsearch should use the official image for arm64 support. Other architectures are not supported.

!!! bug "Untested"
    ARM64 builds are essentially untested, as none of the devs have access to any ARM64 devices. There are regular unstable builds, for both architecture platforms. Help with testing to verify things are working as expected, also on ARM64.


Save the [docker-compose.yml](https://github.com/tubearchivist/tubearchivist/blob/master/docker-compose.yml) file from the **Tube Archivist** repository somewhere permanent on your system, keeping it named `docker-compose.yml`. You'll need to refer to it whenever starting this application.

## Environment Variables

For a comprehensive list of environment variables, see [installation/Environment Variables](/installation/env-vars/).

## Overview  
**Tube Archivist** is a Python application that displays and serves your video collection, built with Django.  

  - Serves the interface on port `8000`
  - Needs a volume for the video archive linked to `/youtube`. 
  - Needs a volume to save application data linked to `/cache`.  
  - The environment variables `ES_URL` and `REDIS_HOST` are needed to tell **Tube Archivist** from where Elasticsearch and Redis respectively are accessible.  
  - The environment variables `HOST_UID` and `HOST_GID` allows **Tube Archivist** to `chown` the video files to the main host system user instead of the container user.
    - These variables are optional and not setting them will disable that functionality. That might be needed if the underlying filesystem doesn't support `chown`, like *NFS*.   
  - Set the environment variable `TA_HOST` to match with the expected ways you will access your **Tube Archivist** instance.
    - This can be a domain like *example.com*, a subdomain like *ta.example.com* or an IP address like *192.168.1.20*.
    - If you are running **Tube Archivist** behind a SSL reverse proxy, specify the protocol (`https://`).
    - You can add multiple hostnames separated with a space.
    - Any wrong configurations here will result in a `Bad Request (400)` response.
  - Change the environment variables `TA_USERNAME` and `TA_PASSWORD` to create the initial credentials.   
  - `ELASTIC_PASSWORD` is the password for Elasticsearch. The environment variable `ELASTIC_USER` is optional and only if you want to change the username from the default, *elastic*.  
  - Optionally, set `ES_SNAPSHOT_DIR` to change the folder where ES is storing its snapshots. When changing the location, make sure you have persistence of the new location. That is an absolute path from inside the ES container.
  - Set `ES_DISABLE_VERIFY_SSL`, a boolean value, to disable SSL verification for connections to ES, e.g. for self-signed certificates.
  - For the scheduler to know what time it is, set your timezone with the `TZ` environment variable, defaults to *UTC*.
  - Set `ENABLE_CAST`, a boolean value, to enable sending videos to your cast-ready devices, [read more](../configuration/cast.md). 




## Configuring Tube Archivist  
Edit the following values in your local `docker-compose.yml` file:  

Under `tubearchivist`->`environment`:

  - `HOST_UID`: the UID of a local user, for if you want **Tube Archivist** to create files with a specific UID. Remove if default UID is acceptable or required.
  - `HOST_GID`: the GID of a local group, same as the `HOST_UID`.
  - `TA_HOST`: change it to match the address of the machine you're running this on. This can be an IP address or a domain name.
  - `TA_PASSWORD`: pick a password to use when logging in.
  - `ELASTIC_PASSWORD`: pick a password for the Elasticsearch service. You won't need to type this yourself, but it does need to match with the `archivist-es` reference.
  - `TZ`: your time zone. If you don't know yours, you can look it up [here](https://www.timezoneconverter.com/cgi-bin/findzone/findzone).

Under `archivist-es`->`environment`:

 - `"ELASTIC_PASSWORD=verysecret"`: change `verysecret` to match the `ELASTIC_PASSWORD` you picked above.


By default, Docker will store all data, including downloaded data, in its own data-root directory (which you can find by running `docker info` and looking for the "Docker Root Dir"). If you want to use other locations, you can replace the `media:`, `cache:`, `redis:`, and `es:` volume names with absolute paths; if you do, remove them from the `volumes:` list at the bottom of the file.

Use the *latest* (the default) or a named semantic version tag for the Docker images. The *unstable* tag is for intermediate testing, and, as the name implies, is **unstable** and not be used on your main installation but in a [testing environment](https://github.com/tubearchivist/tubearchivist/blob/master/CONTRIBUTING.md).  


### Port Collisions  
If you have a collision on port `8000`, best solution is to use Docker's *HOST_PORT* and *CONTAINER_PORT* distinction: For example, to change the interface to port 9000, use `9000:8000` in your `docker-compose.yml` file under `tubearchivist`->`port`.  

Should that not be an option, the TA container takes these two additional environment variables:  

  - **TA_PORT**: To actually change the port where nginx listens, make sure to also change the ports value in your `docker-compose.yml` file.  
  - **TA_UWSGI_PORT**: To change the default uwsgi port from 8080, which is used for container internal networking between uwsgi, serving the django application, and nginx. 
 
Changing any of these two environment variables will change the files *nginx.conf* and *uwsgi.ini* at startup, using `sed` in your container.  

## ElasticSearch  
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

## Redis  

!!! danger "BE AWARE"
    You most likely can't use the same Redis instance between other services, especially if they also use Celery as a task scheduler.

Redis functions as a cache and temporary link between the application and the file system. Redis is used to store and display messages and configuration variables.

  - Needs to be accessible over the default port `6379`
  - Needs a volume to allow configuration persistence linked to `/data`.

### Redis on a custom port
For some environments, it might be required to run Redis on a non-standard port. For example, to change the Redis port to `6380`, set the following values:  

- For the TA container, set the `REDIS_PORT` environment variable, i.e. `REDIS_PORT=6380`
- For the *archivist-redis* service, change the ports to `6380:6380`
- Additionally, set the following value to the *archivist-redis* service: `command: --port 6380 --loadmodule /usr/lib/redis/modules/rejson.so`  

## Start the application

From a terminal, `cd` into the directory you saved the `docker-compose.yml` file in and run `docker compose up --detach`. The first time you do this, Docker will download the appropriate images, which can take an additional minute or so.

You can follow the logs with `docker compose logs -f`. Once it's ready, it will print something like `celery@1234567890ab ready`. At this point you should be able to go to `http://your-host:8000` and log in with the `TA_USER`/`TA_PASSWORD` credentials.

You can bring the application down by running `docker compose down` in the same directory.

### Support

If you're still having trouble, join us on [discord](https://www.tubearchivist.com/discord) and come to the [#support channel.](https://discord.com/channels/920056098122248193/1006394050217246772)