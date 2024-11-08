!!! abstract "Installation Instructions - Community Guides"
    These are beginner's guides/installation instructions for additional platforms generously provided by users of these platforms. When in doubt, verify the details with the [project README](https://github.com/tubearchivist/tubearchivist#installing). If you see any issues here while using these instructions, please contribute. 

# Setting up Tube Archivist with ProxMox LXC

This guide assumed you know how to setup an LXC, CLI, and use "advanced" setup using tteck's easy helper scripts. This is out of scope for this project, if you need help with it reach out to me (Niicholai) in the discord and I will walk you through it.

This guide will also walk you through exactly how I did it, in my specific setup which is a bit extra. I add in a ZFS Pool mount and drivers for my 1060 6GB. Sections exclusive to me that may not partain to you will be marked as **OPTIONAL**.

**NOTE:** I have a static IP from my ISP, I'm not sure if that matters or not, but I didn't have to do any port forwarding or anything funny. It may be different for you, but it shouldn't be to my knowledge.

---

**Original requirements from For Docker Compose:** minimal system requirements, the **Tube Archivist** stack needs around 2GB of available memory for a small testing setup and around 4GB of available memory for a mid to large sized installation. Minimum requirements for CPU are usually expected to be dual core with 4 threads, with better performance coming from quad core and higher, and more available threads.

**Requirements for ProxMox LXC:** In my testing, 4 cores, 8GB disk, and 5GB RAM is what I went with in a Debian 12 container with static IP (set in my router). At idle it is using 0.09-0.20% of the 4 CPUs, 47.91% of the 5GB RAM (2.40GB), and 3.09GB of disk. Your mileage may vary, but this is a good place to start and see where you land.

---

1. To setup docker in a LXC, please use [tteck's easy helper script](https://tteck.github.io/Proxmox/#docker-lxc) (you may also add in portainer if you wish with the same script).

2. **OPTIONAL:** I mount a ZFS pool to my LXC to house my downloaded videos. If you need to do so, shut down the container and go add your mapping to the LXC's .conf, set your mount point, and start the container back up.

3. **OPTIONAL:** I add in drivers for my 1060 6GB that match the ones on my host, if you need to do that, do it now.

4. Create a spot to house your compose file. I personally went with /home/compose.

5. Grab the [docker-compose.yml](https://github.com/tubearchivist/tubearchivist/blob/master/docker-compose.yml). You can use something like WinSCP, download it to your main machine, then send it over, use the CLI, etc. For simplicity, I copied the raw contents, slapped it into Notepad++, edited it to what I needed, aused `touch docker-compose.yml` and copy pasted my final product into that empty file with `nano`.

6. Recommended changes to the compose file: I changed `ports: 8000:8000` under `tubearchivist` to `ports: 9000:8000` due to a conflict, I recommend you do the same. Under `tubearchivist` change `TA_USERNAME`, `TA_PASSWORD`, `ELASTIC_PASSWORD`, `TA_HOST` and `TZ` to your liking (you can set multiple hosts in `TA_HOST`, seperated by a space. For example, I set my local ip for the LXC and the https// URL for my CloudFlare tunnel). Make sure to change `"ELASTIC_PASSWORD="` under `archivist-es` to match what you set in `tubearchivist` as well. Finally, set your volumes. I did the following: in `tubearchivist` I set `volumes` to `- /share/youtube/archivist:/youtube` and `- /archivist/cache:/cache`, under `archivist-redis` I set `volumes` to `- /archivist/redis:/data`, and under `archivist-es` I set `volumes` to `- /archivist/es:/usr/share/elasticsearch/data`. **OPTIONAL:** if you did a ZFS pool mount, you'll also want to change the `HOST_UID` and `HOST_GID` as well.

7. With your compose file setup, if you like keeping things simple and organized like I do, and setup your compose file as I did, create those directories. `/archivist` and then `cache`, `redis`, and `es` inside of it so we get `/archivist/cache` and so on.

8. Time for that scary first launch! cd over to your /home/compose directory and full send `docker compose up -d` and pray nothing catches fire. I'm kidding, but I know the anxiety I had, you'll be fine I promise.

9. If everything went well then upon using the `docker compose logs -f` command you should see it's broken and throwing an error 1 message. I could have had you try and solve this in advance, but I wanted you to see the error, understand the problem, and then have the fix so you actually learn. If we read through the logs, we find this is a permission error by reading `"error.message":"Unable to access 'path.repo' (/usr/share/elasticsearch/data/snapshot)"`, this is caused by ES expecting very specific permissions in the folder we created. Not to worry, easy fix is next.

10. Go ahead and run `docker compose down`, now we need to enact `chown 1000:0 -R /path/to/mount/point`, in my case (and yours if you're doing things how I did) I used `chown 1000:0 -R /archivist/es`. That's it, that's literally all it was. See? I told you, easy.

11. `docker compose up -d`, we should see 4 items this time, Network tubearchivist_default Created, Container archivist-es Started, Container archivist-redis Started, and Container tubearchivist Started. Now if you run `docker compose logs -f` you should see a lot of "archivist-es" with a bunch of "timestamp" after it. Congrats, it's up and running!

12. Head over to your local IP with the port we changed earlier, so 9000. `http://123.123.123.123:9000` and you should see a fancy login screen for TA. Use the username and password you set in your compose file and voila!

13. Now you're ready to edit your settings, grab the fancy [TubeArchivist Browser Companion](https://github.com/tubearchivist/browser-extension), and full send your hard drive space into oblivion grabbing all the videos so if they get deleted you'll still have your fancy tutorials and cat videos.

**NOTE:** I had issues with cookie syncing so I just turned it off, I'm not downloading restricted videos and it's not impacting me at this time.

---

### Support

If you're still having trouble, join us on [discord](https://www.tubearchivist.com/discord) and come to the [#support channel.](https://discord.com/channels/920056098122248193/1006394050217246772)

You can specifically find the support thread I had initially to get this all up and running with lamusmaser by searching in the support section for `[SOLVED] Need help setting up LXC properly`. I am no expert but after spending 4 days working on this, only to find out doing it all over again one more time, with these specific steps, worked out wonderfully I wanted to add to the docs and create a guide for my fellow LXC users. Hope this helped!
