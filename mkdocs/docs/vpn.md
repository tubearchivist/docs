# VPN

As [established](faq.md#how-do-i-tunnel-all-traffic-from-this-container), using a VPN *can* be advantageous in some cases, but also disadvantageous in other cases. There are various ways to do this on Docker level:

## Default Gateway Override

!!! credit
    Core concepts of this section are largely inspired by the excellent article by [linuxserver.io](https://www.linuxserver.io) titled [Routing Docker Host And Container Traffic Through WireGuard](https://www.linuxserver.io/blog/routing-docker-host-and-container-traffic-through-wireguard#routing-docker-host-and-container-traffic-through-wireguard).

**Pros and Cons**:

<ul class="pros">
  <li>Retain most of Docker native networking convenience</li>
  <li>Use any VPN container you prefer</li>
</ul>

<ul class="cons">
  <li>Needs higher permission on the Container you want to route, to allow network configuration changes: <b>NET_ADMIN</b>.</li>
  <li>More complex to setup initially</li>
  <li>Requires <i>some</i> more understanding of networking</li>
</ul>

### Core Concepts

- Setup any VPN container, WireGuard in this example
- Configure the VPN container to connect to your VPN of choice as a client
- Only the VPN container needs to be set up as a VPN client
- Configure the VPN container to handle NAT, allowing for traffic forwarding
- Point the default gateway of the container you want to connect to the VPN to the VPN container IP

### Install WireGuard Container

There are various options, [linuxserver/wireguard](https://github.com/linuxserver/docker-wireguard) is a popular option. Refer to their docs with detailed instructions.

On your Docker host, set up the VPN network on a preconfigured static IP range, adjust to your liking, adjust the subnet and name if needed, example: 

```yaml
networks:
  vpn:
    driver: bridge
    ipam:
      config:
        - subnet: 172.30.0.0/24
```

Give the WireGuard container service a static IP on that network, e.g. under the WireGuard service: 

```yaml
services:
  wireguard:
    [...]  # all your other container configs...
    networks:
      vpn:
        ipv4_address: 172.30.0.10
```

On your WireGuard config file, configure WireGuard for NAT routing, under the `[Interface]` block set:

```toml
PostUp = iptables -t nat -A POSTROUTING -o wg+ -j MASQUERADE
PreDown = iptables -t nat -D POSTROUTING -o wg+ -j MASQUERADE
```

Verify the WireGuard container is connected to the expected VPN server.

### Configure TA

Create a dedicated network for intercontainer traffic between TA, ES and Redis, e.g. at the bottom create or extend your networks section:

```yaml
networks:
  tubearchivist:
    driver: bridge
```

On the **TubeArchivist** container, set the required elevated capabilities to control its own network settings, to allow for setting its own gateway:

```yaml
services:
  tubearchivist:
    [...]
    cap_add:
      - NET_ADMIN
```

Make sure TA is part of the WireGuard VPN and the tubearchivist networks:

```yaml
services:
  tubearchivist:
    [...]
    networks:
      - vpn
      - tubearchivist
```

Also add ES and redis to the created `tubearchivist` network here. Only **TubeArchivist** needs to be on the VPN network, ES and Redis do not.

Then route all traffic through WireGuard container, there are several approaches, the most reliable is to prepend the command infront of the actual start command, like so:

```yaml
services:
  tubearchivist:
    [...]
    command:
      - /bin/sh
      - -c
      - |
        set -e
        ip route replace default via 172.30.0.10
        exec ./run.sh
```

The IP address here points to the static `ipv4_address` address you gave the WireGuard container above. `./run.sh` is the CMD in our Dockerfile. When in doubt, you can inspect the CMD used either in source code, or directly with Docker: 

```bash
docker image inspect <IMAGEID> \
  --format 'Entrypoint={{json .Config.Entrypoint}} Cmd={{json .Config.Cmd}}'
```

Verify inside the TA container that you are connected to the expected VPN server.

### Next Steps

- Optionally, you can harden the setup by setting a healthcheck test on the WireGuard container and make the TA container dependent on a healthy WireGuard container.
- Some VPN providers also allow implementing a kill switch. If they have implemented that, they like have a mention in their docs.
- Verify your DNS settings if you want to ensure DNS is resolved through the VPN container.
- Verify sour IPv6 settings, you probably will need to disable IPv6.

## Gluetun

!!! info
    If you have a successful and working setup using Gluetun with **Tube Archivist**, please extend this documentation.

**Pros and Cons**:

<ul class="pros">
  <li>VPN container is very easy to setup</li>
  <li>Built-in compatibility for various providers, protocols, etc.</li>
  <li>Well established in the self-hosted community</li>
</ul>

<ul class="cons">
  <li>Handover of large parts of host networking stack to Gluetun</li>
  <li>Loss of configuration options provided by Docker and Docker Compose</li>
</ul>

**Links**:

- Repository: [passteque/gluetun](https://github.com/passteque/gluetun)
- Wiki: [qdm12/gluetun-wiki](https://github.com/qdm12/gluetun-wiki)
