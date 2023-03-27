If you have a collision on port `8000`, best solution is to use dockers *HOST_PORT* and *CONTAINER_PORT* distinction: To for example change the interface to port 9000 use `9000:8000` in your docker-compose file.  

Should that not be an option, the Tube Archivist container takes these two additional environment variables:  

  - **TA_PORT**: To actually change the port where nginx listens, make sure to also change the ports value in your docker-compose file.  
  - **TA_UWSGI_PORT**: To change the default uwsgi port 8080 used for container internal networking between uwsgi serving the django application and nginx. 
 
Changing any of these two environment variables will change the files *nginx.conf* and *uwsgi.ini* at startup using `sed` in your container.