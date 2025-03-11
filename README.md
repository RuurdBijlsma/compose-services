# Server Setup

## DNS Config

* Make sure api access is enabled for your domain
* Make `*.domain.tld` point to your public ip

## Router config

* Give static ip to server
* Port forward 80, 443, 32400

## Setup

1. `./scripts/install-docker.sh`
2. copy `stacks/media/.env.template` to `stacks/media/.env`
3. Fill in the right values, for `PLEX_ADVERTISE_IP`, fill your-public-ip:32400
4. `./scripts/deploy.sh`
5. Visit server-ip:81 to configure nginx proxy manager
	* create user
	* add letsencrypt wildcard certificate for *.yourdomain.tld with DNS challenge (api key)
	* dns challenge may fail first time, try again
	* add host -> `proxy-manager`, port=81, http, ssl -> choose wildcard cert & enable http2 & force ssl
	* also add host for anything else that has to be accesible
6. visit all other sites to configure them before making them public
	* plex: server-ip:32400
        * plex: server-ip:32400
        * plex: server-ip:32400
        * plex: server-ip:32400
        * plex: server-ip:32400
