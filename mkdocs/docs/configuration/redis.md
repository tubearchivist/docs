### Redis JSON
Functions as a cache and temporary link between the application and the file system. Used to store and display messages and configuration variables.
  - Needs to be accessible over the default port `6379`
  - Needs a volume at `/data` to make your configuration changes permanent.

### Redis on a custom port
For some architectures it might be required to run Redis JSON on a nonstandard port. To for example change the Redis port to `6380`, set the following values:  

- Set the environment variable `REDIS_PORT=6380` to the *tubearchivist* service.
- For the *archivist-redis* service, change the ports to `6380:6380`
- Additionally set the following value to the *archivist-redis* service: `command: --port 6380 --loadmodule /usr/lib/redis/modules/rejson.so`