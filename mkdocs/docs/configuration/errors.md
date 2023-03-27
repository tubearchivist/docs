Here is a list of common errors and their solutions.  

### `vm.max_map_count`
**Elastic Search** in Docker requires the kernel setting of the host machine `vm.max_map_count` to be set to at least 262144.

To temporary set the value run:  
```
sudo sysctl -w vm.max_map_count=262144
```  
To apply the change permanently depends on your host operating system:  

 - For example on Ubuntu Server add `vm.max_map_count = 262144` to the file `/etc/sysctl.conf`.
 - On Arch based systems create a file `/etc/sysctl.d/max_map_count.conf` with the content `vm.max_map_count = 262144`. 
 - On any other platform look up in the documentation on how to pass kernel parameters.  


### Permissions for elasticsearch
If you see a message similar to `Unable to access 'path.repo' (/usr/share/elasticsearch/data/snapshot)` or `failed to obtain node locks, tried [/usr/share/elasticsearch/data]` and `maybe these locations are not writable` when initially starting elasticsearch, that probably means the container is not allowed to write files to the volume.  
To fix that issue, shutdown the container and on your host machine run:
```
chown 1000:0 -R /path/to/mount/point
```
This will match the permissions with the **UID** and **GID** of elasticsearch process within the container and should fix the issue.  


### Disk usage
The Elasticsearch index will turn to ***read only*** if the disk usage of the container goes above 95% until the usage drops below 90% again, you will see error messages like `disk usage exceeded flood-stage watermark`.  

Similar to that, TubeArchivist will become all sorts of messed up when running out of disk space. There are some error messages in the logs when that happens, but it's best to make sure to have enough disk space before starting to download.