### Setting up TubeArchivist with Docker  

TubeArchivist requires Docker. Please make sure that it is installed and running on your computer before continuing. 

For minimal system requirements, the Tube Archivist stack needs around 2GB of available memory for a small testing setup and around 4GB of available memory for a mid to large sized installation. Minimal with dual core with 4 threads, better quad core plus.

!!! note
    For **arm64**: Tube Archivist is a multi arch container, same for redis. For Elasitc Search use the official image for arm64 support. Other architectures are not supported.

Save the [docker-compose.yml](./docker-compose.yml) file from this reposity somewhere permanent on your system, keeping it named `docker-compose.yml`. You'll need to refer to it whenever starting this application.


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