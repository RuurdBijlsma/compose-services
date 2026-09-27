# Server Setup

## DNS Config

* Make sure api access is enabled for your domain
* Make `*.domain.tld` point to your public ip

## Router config

* Give static ip to server
* Port forward 80, 443, 32400

## Setup

1. `./scripts/install-docker.sh`
2. **Configure HDD dependency for Docker:**
   * Run `sudo systemctl edit docker`
   * Add:
     ```ini
     [Unit]
     RequiresMountsFor=/mnt/hdd
     ```
   * Apply changes:
     ```bash
     sudo systemctl daemon-reload && sudo systemctl restart docker
     ```
3. copy `example.env` to `.env`
4. Place wireguard `.conf` from Proton/your vpn at `stacks/media/config/qbittorrent/config/wireguard/anyname.conf`
5. `docker network create proxy-net`
6. `./scripts/up.sh`
7. Visit server-ip:81 to configure nginx proxy manager
    * create user
    * add letsencrypt wildcard certificate for *.yourdomain.tld with DNS challenge (api key)
    * dns challenge may time out, this is fake, certbot is still going. Wait a while then try to add it again, it should
      succeed.
    * add host -> `proxy-manager`, port=81, http, ssl -> choose wildcard cert & enable http2 & force ssl
    * also add host for anything else that has to be accessible
8. visit all other sites to configure them before making them public\
9. Configure qbittorrent:
    * Add to ssd_path/qbittorrent/config/qBittorrent/qBittorrent.conf:
    * WebUI\Password_PBKDF2="@ByteArray(ARQ77eY1NUZaQsuDHbIMCA==:
      0WMRkYTUWVT9wVvdDtHAjU9b3b7uB8NR1Gur2hmQCvCDpm39Q+PsJRJPaCU51dEiz+dTzh8qbPsL8WkFljQYFQ==)"
    * log in to webui with: "admin" "adminadmin"
    * change pw

## Host name - Port

When setting up hosts in nginx proxy manager, this info is useful.

| hostname        | domain  | port |
|-----------------|:--------|------|
| jellyfin        | jelly   | 8096 |
| qbittorrent-vpn | torrent | 8080 |
| prowlarr        |         | 9696 |
| sonarr          |         | 8989 |
| radarr          |         | 7878 |
| overseerr       | request | 5055 |
| uptime-kuma     | uptime  | 3001 |
| portainer       |         | 9000 |
| filebrowser     | drive   | 8080 |
| vaultwarden     | vault   | 80   |
| odoo            | odoo    | 8069 |
| photos_web      | photos  | 9475 |