A collection of generic knowledge about Docker targeted at beginners. These concepts do not _only_ apply to this project but this project is used as an example.

## Compose File
Docker compose files are the most common and arguably the most convenient way to deploy docker containers. The compose file is usually called `docker-compose.yml` and is in yaml format.

!!! warning "Indentation Matters"
	YAML is _very_ particular about indentation. Make sure you exactly mirror the indentation level as documented.

The top key is called `services` then each key inside that represents a container. And each additional container has additional options like `image` and `container_name`. So a common compose file will look like this:

```yml
services:
  container1:
    container_name: name1
    image: image1
  container2:
    container_name: name2
    image: image2
```

## Common Commands

These commands are expected to be run from the same location in the filesystem where you have stored your `docker-compose.yml` file. 

### Download
Download (pull) the containers:
```bash
docker compose pull
```

### Start
Start (up) the containers. This will download the images first, if needed:
```bash
docker compose up -d
```

### Stop
Stop (down) all containers:
```bash
docker compose down
```

### Update
Update (pull and up) all containers to the latest image:
```bash
docker compose pull
docker compose up -d
```
If available, this will update all containers to the latest version.

!!! warning "Check Release Notes"
	For this project, and other projects under development, always check the release notes before updating. If there are any breaking changes or manual steps needed, you'll find instructions there.

### Logs
To get the logs:
```bash
docker compose logs
```

Get the logs of a single container:
```bash
docker compose logs tubearchivist
```

Optionally _follow_ the logs, meaning always see the latest logs, add `-f`:
```bash
docker compose logs -f tubearchivist
```

same for all containers:
```bash
docker compose logs -f
```

## Volumes

!!! warning "Data Loss"
	Understanding Volumes is crucial. Incorrect configurations can lead to data loss.

By default Docker containers don't persist any data, meaning all data will get lost and reset after a container rebuilds. To persist data, you need to define volumes.

### Docker Managed

In the example `docker-compose.yml` file you can see the volume definition at the bottom like that:
```yml
volumes:
  media:
  cache:
  redis:
  es:
```

This defines volumes managed by docker. In a typical Linux based environment these get stored at `/var/lib/docker/`. Then you can see the corresponding volume mount on the container service like so: 

```yml
volumes:
  - media:/youtube
```

This mounts the docker managed volume called `media` inside the container at `/youtube`. The colon symbol `:` splits the paths:  

- The left side points to the location of the host system. You can usually freely choose that.
- The right side points to the location _inside_ the container. You _usually_ can't modify that and you _have_ to use the exact same path as documented.
- In some projects you see an additional `:` with additional options, e.g. `:ro` meaning _read only_. That does not apply for this project.

### User Managed, aka bind mount
!!! warning "Permission Problems"
	Using bind mounts can lead to permission problems if the service inside the docker container is running on a specific user. In that case you'll have to make sure the folder on your host system has the same permissions as the folder _inside_ the container.

    You'll run into this problem when using a bind mount for the ElasticSearch volume. See [here](https://github.com/tubearchivist/tubearchivist?tab=readme-ov-file#permissions-for-elasticsearch) with instructions how to fix that.

If you prefere, you can define where each volume should be stored on the file system by modifying the path **infront** of the `:`. Remember, you usually can't change the path _inside_ the container, only the path on the host system.

If you define a bind mount, you can remove the docker managed volume definition from the `volumes` key at the bottom of the docker-compose file.

#### Relative Path
You can specify a relative file path, starting with `./`, that will be relative from the location of the `docker-compose.yml` file.

E.g.:  
```yml
volumes:
  - ./volume/youtube:/youtube
```
That will persist the data at `volume/youtube` where the content of the `/youtube` folder will get stored on your host system.

#### Absolut Path
Alternatively you can also specify an absolute path on your host system.

E.g.:  
```yml
volumes:
  - /media/docker/volume/youtube:/youtube
```

That will persist the data at `/media/docker/volume/youtube` on your host system.

## Networking

For docker networking there are two basic concepts to understand: Publishing a service and networking between containers.

### Publish

Publishing a service running inside a container is required to access that service, e.g. through your web browser.

You will see `ports` defined in the `docker-compose.yml` file.

E.g.:
```yml
ports:
  - "8080:8000"
```

Similar to volumes, the colon symbol `:` splits the network definition:

- The left side of the `:` defines the port used on your host system, aka `HOST_PORT`. You can _usually_ freely choose that.
- The right side of the `:` defines the port used _inside_ the container, aka `CONTAINER_PORT`. You _usually_ can't change that and you need to use the port as defined in the documentation. If a service allows you to customize that, you should see a mention in the docs as well.

!!! info
    You can't have more than one service using the same port. You'll see an error if you try to do that. The simplest way to rectify that is to change the `HOST_PORT` to something not in use, but keep the `CONTAINER_PORT` as is.

    E.g.: `"8008:8000"` to use the port 8008 on the host.


This means this container is publishing a service running in the container on port `8000` to port `8080` on the host. That usually means, when you access that service, you'll need to add the `HOST_PORT` `:8080` to the IP/URL in your browser address bar.

### Networking between containers
Containers regularly depend on other containers. How interacting between containers is usually done, is with networking. E.g. An application uses a traditional database like Postgres or, as here in this project, **Tube Archivist** needs to communicate with Redis and ElasticSearch.

The good news is, docker handles all of that for you automatically: Docker's internal DNS automatically resolves the service name. Usually, you don't need to publish ports for services only expected to be accessed by another container. You will see `expose` keys defined on the service. 

E.g.:
```yml
expose:
  - "9200"
```

That does not actually _do_ anything, that is mostly for you to document on what port a given service is expected to be accessed. You will usually set environment variables on the main container defining connection details like that. For this project thats: [`REDIS_CON`](env-vars.md#redis_con) for Redis and [`ES_URL`](env-vars.md#es_url) for ElasticSearch.
