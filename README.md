# Server Setup

## DNS Config

* Make sure api access is enabled for your domain
* Make `*.domain.tld` point to your public ip

## Router config

* Give static ip to server
* Port forward 80, 443, 32400

## Setup

1. `./scripts/install-docker.sh`
2. Install `just` task runner:
   ```bash
   sudo apt install -y just
   ```
3. **Configure HDD dependency for Docker:**
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
4. **(Optional) Laptop server without battery (Disable Turbo Boost):**
    * Running a laptop without a battery can cause abrupt power cutoffs under heavy load because CPU Turbo Boost
      transient spikes exceed what the power brick can supply alone.
    * Create `/etc/systemd/system/disable-turbo.service`:
      ```ini
      [Unit]
      Description=Disable Intel Turbo Boost
      After=sysinit.target local-fs.target
      DefaultDependencies=no
 
      [Service]
      Type=oneshot
      ExecStart=/bin/sh -c "echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo"
 
      [Install]
      WantedBy=basic.target
      ```
    * Enable and apply:
      ```bash
      sudo systemctl daemon-reload && sudo systemctl enable --now disable-turbo.service
      ```
5. Copy `example.env` to `.env` and fill in secrets and paths:
   ```bash
   cp example.env .env
   ```
6. Place wireguard `.conf` from Proton/your VPN at `stacks/media/config/qbittorrent/config/wireguard/anyname.conf`
7. `just up`
8. Visit `server-ip:81` to configure nginx proxy manager
   * create user
   * add letsencrypt wildcard certificate for *.yourdomain.tld with DNS challenge (api key)
   * dns challenge may time out, this is fake, certbot is still going. Wait a while then try to add it again, it should
     succeed.
   * add host -> `proxy-manager`, port=81, http, ssl -> choose wildcard cert & enable http2 & force ssl
   * also add host for anything else that has to be accessible
9. visit all other sites to configure them before making them public
10. Configure qbittorrent:
   * Add to ssd_path/qbittorrent/config/qBittorrent/qBittorrent.conf:
   * WebUI\Password_PBKDF2="@ByteArray(ARQ77eY1NUZaQsuDHbIMCA==:
     0WMRkYTUWVT9wVvdDtHAjU9b3b7uB8NR1Gur2hmQCvCDpm39Q+PsJRJPaCU51dEiz+dTzh8qbPsL8WkFljQYFQ==)"
   * log in to webui with: "admin" "adminadmin"
   * change pw

---

## Daily Operations (`just`)

| Command               | Action                                             |
|-----------------------|----------------------------------------------------|
| `just up`             | Start all stacks and create networks               |
| `just down`           | Stop all containers                                |
| `just restart`        | Restart all stacks                                 |
| `just pull-all`       | Pull new images and restart all containers         |
| `just pull <stack>`   | Update single stack (e.g. `just pull photos`)      |
| `just ps`             | Check container health and status                  |
| `just logs [service]` | Follow live logs (e.g. `just logs photos_backend`) |
| `just backup`         | Run backup script immediately                      |
| `just restore <date>` | Restore backup from date (`YYYY-MM-DD`)            |

---

## Nginx Proxy Manager Routing Reference

| Hostname in NPM     | Target Service / Domain | Port | Notes                |
|---------------------|-------------------------|------|----------------------|
| `photos_web`        | photos                  | 9475 | Photos Web UI        |
| `photos_grafana`    | grafana                 | 3000 | Monitoring Dashboard |
| `jellyfin`          | jelly                   | 8096 | Media Server         |
| `qbittorrent-vpn`   | torrent                 | 8080 | Torrent Client       |
| `prowlarr`          | prowlarr                | 9696 | Indexer Sync         |
| `sonarr`            | sonarr                  | 8989 | TV Series Manager    |
| `radarr`            | radarr                  | 7878 | Movie Manager        |
| `filebrowser-ruurd` | drive                   | 8080 | File Browser         |
| `vaultwarden`       | vault                   | 80   | Password Manager     |
| `odoo`              | odoo                    | 8069 | Business ERP         |