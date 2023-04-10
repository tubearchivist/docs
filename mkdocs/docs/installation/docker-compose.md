# Setting up TubeArchivist with Docker  

TubeArchivist requires Docker. Please make sure that it is installed and running on your computer before continuing. 
Docker is required because Tube Archivist depends on three main components split up into separate docker containers.  

For minimal system requirements, the Tube Archivist stack needs around 2GB of available memory for a small testing setup and around 4GB of available memory for a mid to large sized installation. Minimal with dual core with 4 threads, better quad core plus.

!!! note
    For **arm64**: Tube Archivist is a multi arch container, same for redis. For Elasitc Search use the official image for arm64 support. Other architectures are not supported.

Save the [docker-compose.yml](https://github.com/tubearchivist/tubearchivist/blob/master/docker-compose.yml) file from this reposity somewhere permanent on your system, keeping it named `docker-compose.yml`. You'll need to refer to it whenever starting this application.

## Overview  
The main Python application that displays and serves your video collection, built with Django.  

  - Serves the interface on port `8000`
  - Needs a volume for the video archive at `/youtube`  
  - And another volume to save application data at `/cache`.  
  - The environment variables `ES_URL` and `REDIS_HOST` are needed to tell Tube Archivist where Elasticsearch and Redis respectively are located.  
  - The environment variables `HOST_UID` and `HOST_GID` allows Tube Archivist to `chown` the video files to the main host system user instead of the container user. Those two variables are optional, not setting them will disable that functionality. That might be needed if the underlying filesystem doesn't support `chown` like *NFS*.   
  - Set the environment variable `TA_HOST` to match with the system running Tube Archivist. This can be a domain like *example.com*, a subdomain like *ta.example.com* or an IP address like *192.168.1.20*. If you are running Tube Archivist behind a SSL reverse proxy, specify the protocoll. You can add multiple hostnames separated with a space. Any wrong configurations here will result in a `Bad Request (400)` response.  
  - Change the environment variables `TA_USERNAME` and `TA_PASSWORD` to create the initial credentials.   
  - `ELASTIC_PASSWORD` is for the password for Elasticsearch. The environment variable `ELASTIC_USER` is optional, should you want to change the username from the default *elastic*.  
  - For the scheduler to know what time it is, set your timezone with the `TZ` environment variable, defaults to *UTC*.  
  - Serves the interface on port `8000`
  - Needs a volume for the video archive at `/youtube`  
  - Set the environment variable `ENABLE_CAST=True` to send videos to your cast device, [read more](#enable-cast). 


## Configuring TubeArchivist  
Edit the following values from that file:  

Under `tubearchivist`->`environment`:

  - `HOST_UID`: your UID, if you want TubeArchivist to create files with your UID. Remove if you are OK with files being owned by the the container user.
  - `HOST_GID`: as above but GID.
  - `TA_HOST`: change it to the address of the machine you're running this on. This can be an IP address or a domain name.
  - `TA_PASSWORD`: pick a password to use when logging in.
  - `ELASTIC_PASSWORD`: pick a password for the elastic service. You won't need to type this yourself.
  - `TZ`: your time zone. If you don't know yours, you can look it up [here](https://www.timezoneconverter.com/cgi-bin/findzone/findzone).

Under `archivist-es`->`environment`:

 - `"ELASTIC_PASSWORD=verysecret"`: change `verysecret` to match the `ELASTIC_PASSWORD` you picked above.



By default Docker will store all data, including downloaded data, in its own data-root directory (which you can find by running `docker info` and looking for the "Docker Root Dir"). If you want to use other locations, you can replace the `media:`, `cache:`, `redis:`, and `es:` volume names with absolute paths; if you do, remove them from the `volumes:` list at the bottom of the file.  

From a terminal, `cd` into the directory you saved the `docker-compose.yml` file in and run `docker compose up --detach`. The first time you do this it will download the appropriate images, which can take a minute.

You can follow the logs with `docker compose logs -f`. Once it's ready it will print something like `celery@1234567890ab ready`. At this point you should be able to go to `http://your-host:8000` and log in with the `TA_USER`/`TA_PASSWORD` credentials.

You can bring the application down by running `docker compose down` in the same directory.

Use the *latest* (the default) or a named semantic version tag for the docker images. The *unstable* tag is for intermediate testing and as the name implies, is **unstable** and not be used on your main installation but in a [testing environment](https://github.com/tubearchivist/tubearchivist/blob/master/CONTRIBUTING.md).  


### Port Collisions  
If you have a collision on port `8000`, best solution is to use dockers *HOST_PORT* and *CONTAINER_PORT* distinction: To for example change the interface to port 9000 use `9000:8000` in your docker-compose file.  

Should that not be an option, the Tube Archivist container takes these two additional environment variables:  

  - **TA_PORT**: To actually change the port where nginx listens, make sure to also change the ports value in your docker-compose file.  
  - **TA_UWSGI_PORT**: To change the default uwsgi port 8080 used for container internal networking between uwsgi serving the django application and nginx. 
 
Changing any of these two environment variables will change the files *nginx.conf* and *uwsgi.ini* at startup using `sed` in your container.  

## ElasticSearch  
!!! note
    Tube Archivist depends on Elasticsearch 8. 

Use `bbilly1/tubearchivist-es` to automatically get the recommended version, or use the official image with the version tag in the docker-compose file.

Use official Elastic Search for **arm64**.  

Stores video meta data and makes everything searchable. Also keeps track of the download queue.

  - Needs to be accessible over the default port `9200`
  - Needs a volume at `/usr/share/elasticsearch/data` to store data

Follow the [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html) for additional installation details.

### Elasticsearch on a custom port
Should you need to change the port for Elasticsearch to for example `9500`, follow these steps:

  - Set the environment variable `http.port=9500` to the ES container
  - Change the `expose` value for the ES container to match your port number
  - For the Tube Archivist container, change the `ES_URL` environment variable, e.g. `ES_URL=http://archivist-es:9500`  

## Redis  
Functions as a cache and temporary link between the application and the file system. Used to store and display messages and configuration variables.

  - Needs to be accessible over the default port `6379`
  - Needs a volume at `/data` to make your configuration changes permanent.

### Redis on a custom port
For some architectures it might be required to run Redis JSON on a nonstandard port. To for example change the Redis port to `6380`, set the following values:  

- Set the environment variable `REDIS_PORT=6380` to the *tubearchivist* service.
- For the *archivist-redis* service, change the ports to `6380:6380`
- Additionally set the following value to the *archivist-redis* service: `command: --port 6380 --loadmodule /usr/lib/redis/modules/rejson.so`  

## Start the application

To start, `cd` into the directory where the `docker-compose.yml` file is located and run `docker compose up --detach` in terminal. The first time you do this it will download the appropriate images, which can take a minute.

You can follow the logs with `docker compose logs -f`. Once it's ready it will print something like `celery@1234567890ab ready`. At this point you should be able to go to `http://your-host:8000` and log in with the `TA_USER`/`TA_PASSWORD` credentials.

You can bring the application down by running `docker compose down` in the same directory.
