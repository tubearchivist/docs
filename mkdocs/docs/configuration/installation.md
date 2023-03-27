Tube Archivist depends on three main components split up into separate docker containers:  

### Tube Archivist
The main Python application that displays and serves your video collection, built with Django.  

  - Serves the interface on port `8000`
  - Needs a volume for the video archive at `/youtube`  
  - And another volume to save application data at `/cache`.  
  - The environment variables `ES_URL` and `REDIS_HOST` are needed to tell Tube Archivist where Elasticsearch and Redis respectively are located.  
  - The environment variables `HOST_UID` and `HOST_GID` allows Tube Archivist to `chown` the video files to the main host system user instead of the container user. Those two variables are optional, not setting them will disable that functionality. That might be needed if the underlying filesystem doesn't support `chown` like *NFS*.   
  - Set the environment variable `TA_HOST` to match with the system running Tube Archivist. This can be a domain like *example.com*, a subdomain like *ta.example.com* or an IP address like *192.168.1.20*, add without the protocol and without the port. You can add multiple hostnames separated with a space. Any wrong configurations here will result in a `Bad Request (400)` response.  
  - Change the environment variables `TA_USERNAME` and `TA_PASSWORD` to create the initial credentials.   
  - `ELASTIC_PASSWORD` is for the password for Elasticsearch. The environment variable `ELASTIC_USER` is optional, should you want to change the username from the default *elastic*.  
  - For the scheduler to know what time it is, set your timezone with the `TZ` environment variable, defaults to *UTC*.  
  - Serves the interface on port `8000`
  - Needs a volume for the video archive at `/youtube`  
  - Set the environment variable `ENABLE_CAST=True` to send videos to your cast device, [read more](#enable-cast). 