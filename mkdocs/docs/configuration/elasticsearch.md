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