!!! abstract "Installation Instructions - Community Guides"
    These are beginner's guides/installation instructions for additional platforms generously provided by users of these platforms. When in doubt, verify the details with the [project README](https://github.com/tubearchivist/tubearchivist#installing). If you see any issues here while using these instructions, please contribute. 

!!! danger "Compatibility Problems"
	- As Synology is running their old kernel (currently 4.4.302+), you might face problems running Elasticsearch on your device, as newer Elasticsearch version require kernel modules not available and not backported by Synology.
	- You will see errors like: `seccomp unavailable` and `CONFIG_SECCOMP not compiled into kernel`, `CONFIG_SECCOMP and CONFIG_SECCOMP_FILTER are needed`.
	- Workaround is to pin the Elasticsearch image to an older version, not requiring these modules: `docker.elastic.co/elasticsearch/elasticsearch:8.14.3`.
	- That is likely going to break in the future, as this project develops, new functionality might depend on new ES versions.

!!! warning "Outdated"
	  Please review these instructions and update it to the changes introduced in [v0.5.0](https://github.com/tubearchivist/tubearchivist/releases/tag/v0.5.0).

There are several different methods to install **Tube Archivist** on Synology platforms. This will focus on the available `docker` package manager implementation for Synology 7.1 and prior.<!--  and `docker-compose` implementations. -->

!!! note
    Synology Package Manager for 7.2 and later should be able to follow the instructions below or create a project using the [docker compose installation instructions.](docker-compose.md)

### Prepare Directories/Folders

Before we setup **Tube Archivist**, we need to setup the directories/folders. You are assumed to be logged into the Synology NAS with a properly permissioned user.

#### 1. Docker Base Folder
   1. Open the `File Station` utility.
   2. Click on the **Create🔽** button and choose *Create New Shared Folder*.
   3. **Name** the folder "Docker".
   4. Add a **Description**.
   5. Select the **Volume Location**. 
   > !!! note
         By default, this will be where all persistent data is stored. Change the folders as best meets your requirements.
   6. Select the appropriate options from the remaining checkbox configurations.
![Synology - Create Docker Folder](../assets/Synology_0.2.0_Docker-Folder-Create.png)
   7. Click the **Next** button.
   8. If you are going to **Encrypt** your folder, check the appropriate box and provide the Encryption Key and its confirmation.
   9. Click the **Next** button.
   10. On the **Advanced Settings** page, you can select the *Enable data checksum for advanced data integrity* setting. This may cause a performance impact, but will allow for potential file self-healing. **This cannot be changed later.**
   > !!! warning
         This is not recommended as we will be hosting databases within this folder.
   11. If you are enabling a quota for how large the folder can get, you can select the *Enabled shared folder quota* setting and choose the maximum size this folder can grow. This can be changed later.
   12. Click the **Next** button.
   13. Confirm the settings, then click the **Apply** button. This will create the folder.
#### 2. Tube Archivist Base Folder
   1. Open the `File Station` utility.
   2. Select the "Docker" folder on the left-hand side.
   3. Click on the `Create🔽` button and choose *create Folder*.
   4. **Name** the folder "TubeArchivist".
#### 3. Redis Data
   1. Open the `File Station` utility.
   2. Select the "Docker" folder on the left-hand side.
   3. Select the "TubeArchivist" folder beneath "Docker".
   4. Click on the `Create🔽` button and choose *create Folder*.
   5. **Name** the folder "redis".
#### 4. Elastic Search Data
   1. Open the `File Station` utility.
   2. Select the "Docker" folder on the left-hand side.
   3. Select the "TubeArchivist" folder beneath "Docker".
   4. Click on the `Create🔽` button and choose *create Folder*.
   5. **Name** the folder "es".
#### 5. Tube Archivist Cache
   1. Open the `File Station` utility.
   2. Select the "Docker" folder on the left-hand side.
   3. Select the "TubeArchivist" folder beneath "Docker".
   4. Click on the `Create🔽` button and choose *create Folder*.
   5. **Name** the folder "cache".
#### 6. Tube Archivist Output
   1. Open the `File Station` utility.
   2. Select the "Docker" folder on the left-hand side.
   3. Select the "TubeArchivist" folder beneath "Docker".
   4. Click on the `Create🔽` button and choose *create Folder*.
   5. **Name** the folder "media".
#### 7. Confirm Folder Structure
Once all of the folders have been created, it should have a folder structure within `Docker\TubeArchivist` that includes "`cache`", "`es`", "`media`", and "`redis`" folders.
![Synology - Docker Folder Structure](../assets/Synology_0.2.0_Docker-Folder-Structure.png)

#### 8. Change Permissions - CLI Required

!!! failure "CLI Required"
    If you do not have SSH access enabled for CLI, [enable it](https://kb.synology.com/en-sg/DSM/tutorial/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet) before continuing.

   1. Open an SSH connection to the Synology. Login as your primary `Admin` user, or the user that was enabled for SSH access.
   2. Elevate your access to `root`. Steps are provided [here](https://kb.synology.com/en-sg/DSM/tutorial/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet).
   3. Change directories to the **Volume** where the "Docker" folder resides.
      
      > !!! example "`cd /volume1`"

   4. Change directories to the "Docker" folder.
      
      > !!! example "`cd Docker`"

   5. Change directories to the "TubeArchivist" folder.
      
      > !!! example "`cd TubeArchivist`"

   6. Change the owner of the "redis" folder. *If correct, this does not have an output.*
      
      > !!! example "`chown 999:100 redis`"

   7. Change the owner of the "es" folder. *If correct, this does not have an output.*
      
      > !!! example "`chown 1000:0 es`"

   8. Confirm that the folders have the correct permissions.
      
      > !!! example "`ls -hl`"

      ![Synology - Docker Folder Permissions Command](../assets/Synology_0.3.6_Docker-Folder-Permissions-Commands.png)

   9. Logout from root.
      
      > !!! example "`logout`"

   10. Disconnect from the SSH connection.
      
      > !!! example "`exit`"


### Synology Docker Setup

#### 1. Install Docker

   1. Install the `Docker` Synology Package.
      1. Log in to your Synology NAS.
      2. Open the `Package Center` utility.
      3. Search for `Docker`.
      4. Click `Install`.

![Synology - Install Docker Utility](../assets/Synology_0.2.0_Docker-Install.png)

#### 2. Download the Docker images

   1. After `Docker` is installed, open the `Docker` utility.
      1. Go to the `Registry` tab.
      2. Search for the following `images` and download them. Follow the recommended versions for each of the images.
         
         > !!! info "`latest` Tag"
            Upgrades in Synology require use of the `latest` tag.
         
         `redis/redis-stack-server`
         ![Synology - Redis Image Search](../assets/Synology_0.3.6_Docker-Redis-Search.png)
         
         `docker.elastic.co/elasticsearch/elasticsearch:8.14.3`
         ![Synology - ElasticSearch Image Search](../assets/Synology_0.2.0_Docker-ES-Search.png)
         
         `bbilly1/tubearchivist`
         ![Synology - Tube Archivist Image Search](../assets/Synology_0.2.0_Docker-TA-Search.png)
   
   2. Go to the `Image` tab. From here, create a container based on each image with the associated configurations below.

#### 3. Configure ElasticSearch

**ElasticSearch**

1. Select the associated image.
2. Click the **Launch** button in the top.
3. Edit the **Container Name** to be "tubearchivist-es".
4. Click on the **Advanced Settings** button.
5. In the **Advanced Settings** tab, check the box for `Enable auto-restart`.
6. In the **Volume** tab, click the **Add Folder** button and select the "`Docker/TubeArchivist/es`" folder, then type in `/usr/share/elasticsearch/data` for the mount path.
7. In the **Network** tab, leave the default `bridge` Network (unless you have a specific Network design that you know how to implement).
8. In the **Port Settings** tab, replace the "Auto" entry under **Local Port** with the port that will be used to connect to ElasticSearch (default is 9200).
9. In the **Port Settings** tab, select the entryline for port 9300 and **➖ delete** the line. It is not needed for this container.
10. The **Links** tab does not require configuration for this container.
11. In the **Environment** tab, add in the following ElasticSearch specific environment variables that may apply.

   | Environment Variable | Setting |
   | :------------------- | :------ |
   | `discovery.type` | `single-node` |
   | `ES_JAVA_OPTS` | `-Xms512m -Xmx512m` |
   | `UID` | `1000` |
   | `GID` | `0` |
   | `xpack.security.enabled` | `true` |
   | `ELASTIC_PASSWORD` | `verysecret` |
   | `path.repo` | `/usr/share/elasticsearch/data/snapshot` |

   > !!! danger "BE AWARE"
         - Do not use the default password, as it is very insecure.
         - Activating snapshots for backups should only be done *after* setting the `path.repo` setting.

   ![Synology - ElasticSearch Environment Configurations](../assets/Synology_0.2.0_Docker-ES-Env-Conf.png)

12. Click on the **Apply** button.
13. Back on the **Create Container** screen, click the **Next** button.
14. Review the settings to confirm, then click the **Apply** button.

#### 4. Configure Redis

**Redis**

1. Select the associated image.
2. Click the **Launch** button in the top.
3. Edit the **Container Name** to be "tubearchivist-redis".
4. Click on the **Advanced Settings** button.
5. In the **Advanced Settings** tab, check the box for `Enable auto-restart`.
6. In the **Volume** tab, click the **Add Folder** button and select the "`Docker/TubeArchivist/redis`" folder, then type in `/data` for the mount path.
7. In the **Network** tab, leave the default `bridge` Network (unless you have a specific Network design that you know how to implement).
8. In the **Port Settings** tab, replace the "Auto" entry under **Local Port** with the port that will be used to connect to Redis (default is 6379).
9. In the **Links** tab, select the `tubearchivist-es` container from the **Container Name** dropdown and provide it the same alias, "tubearchivist-es".
10. In the **Environment** tab, add in any Redis specific environment variables that may apply (none by default).
11. Click on the **Apply** button.
12. Back on the **Create Container** screen, click the **Next** button.
13. Review the settings to confirm, then click the **Apply** button.

#### 5. Configure Tube Archivist

**Tube Archivist**

1. Select the associated image.
2. Click the **Launch** button in the top.
3. Edit the **Container Name** to be "tubearchivist".
4. Click on the **Advanced Settings** button.
5. In the **Advanced Settings** tab, check the box for `Enable auto-restart`.
6. In the **Volume** tab, click the **Add Folder** button and select the "`Docker/TubeArchivist/cache`" folder, then type in `/cache` for the mount path.
7. In the **Volume** tab, click the **Add Folder** button and select the "`Docker/TubeArchivist/media`" folder, then type in `/youtube` for the mount path.
8. In the **Network** tab, leave the default `bridge` Network (unless you have a specific Network design that you know how to implement).
9. In the **Port Settings** tab, replace the "Auto" entry under **Local Port** with the port that will be used to connect to **Tube Archivist** (default is 8000).
10. In the **Links** tab, select the `tubearchivist-es` container from the **Container Name** dropdown and provide it the same alias, "tubearchivist-es".
11. In the **Links** tab, select the `tubearchivist-redis` container from the **Container Name** dropdown and provide it the same alias, "tubearchivist-redis".
12. In the **Environment** tab, add in the following **Tube Archivist** specific environment variables that may apply. **Change the variables as is appropriate to your use case. Follow the [README section](https://github.com/tubearchivist/tubearchivist#installing) for details on what to set each variable.**

   | Environment Variable | Setting |
   | :------------------- | :------ |
   | `TA_HOST` | `synology.local` |
   | `ES_URL` | `http://tubearchivist-es:9200` |
   | `REDIS_HOST` | `tubearchivist-redis` |
   | `HOST_UID` | `1000` |
   | `HOST_GID` | `0` |
   | `TA_USERNAME` | `tubearchivist` |
   | `TA_PASSWORD` | `verysecret` |
   | `ELASTIC_PASSWORD` | `verysecret` |
   | `TZ` | `America/New_York` |

   > !!! danger "BE AWARE"
         - Do not use the default password as it is very insecure.
         - Ensure that ELASTIC_PASSWORD matches the password used on the `tubearchivist-es` container.

   ![Synology - Tube Archivist Environment Configurations](../assets/Synology_0.2.0_Docker-TA-Env-Conf.png)

13. Click on the **Apply** button.
14. Back on the **Create Container** screen, click the **Next** button.
15. Review the settings to confirm, then click the **Apply** button.

### 6. Post-Installation Monitoring

1. After the containers have been configured and started, you can go to the **Container** tab and monitor the containers.
2. To review the logs to ensure that the system has started successfully, select the `tubearchivist` container and click on the **Details** button. In the new window, go to the **Log** tab. Monitor the logs until either an error occurs or the message `celery@tubearchivist ready.` is in the logs. This may take a few minutes, especially for a first time setup.
   
   > !!! note "Reviewing Logs"
         Synology Docker presents the logs in a paginated format, showing in historical order (oldest first).
         If you are not seeing the logs update, check if there are additional pages.

3. After it has started, go to the location provided in the `TA_HOST`. This should give you the standard **Tube Archivist** login screen.
<!-- 
### Docker-Compose Setup -->
<!-- This section is a Work In Progress -->

**From there, you should be able to start up your containers and you're good to go!**

### Synology Docker Upgrade
When a new version of the image is available, you can use the following steps to more easily upgrade your previous instance.

!!! failure "`latest` Tag Required"
    If you did not use the `latest` tag, you may have some variances in your upgrade steps. Those are detailed below these instructions.
1. Go to the Registry Tab and download the newest instance of the `:latest` tag, as seen in the Installation Instructions earlier.
2. Go to Image Tab and confirm that you have the newer version available.
3. Stop the running `tubearchivist` container.
4. Click on the **Action🔽** button and choose "Reset".
5. This will load the newer image we downloaded earlier. This should not delete any files if all of your volumes were setup correctly.
6. If it doesn't start automatically, start the `tubearchivist` container. Monitor the upgrade in the logs and confirm that the service starts up successfully.
7. Once you are able to login successfully to the web page for **Tube Archivist**, you have successfully upgraded your container!

!!! success "If you did not use the `latest` tag for the `tubearchivist` container, then you will instead do the following:"
   1. Shut down the old container.
   2. Download the new image.
   3. Follow the Installation instructions again *for just the Tube Archivist image*, using the same configurations as the existing container. It'll have to be named slightly differently.
   4. After the image is now running and the upgrade of the backend files occurs, shut down the new container. Rename or delete the old container. Rename the new container to have the intended name.

!!! info "Linking Upgrade Importance"
    Links are incredibly important if you upgrade or change the ES or Redis container images. You will either need to remove the links, create the new containers, then re-add the links or rebuild all of the images with the same instructions as Installation, starting at Step 3.

### Support

If you're still having trouble, join us on [discord](https://www.tubearchivist.com/discord) and come to the [#support channel.](https://discord.com/channels/920056098122248193/1006394050217246772)