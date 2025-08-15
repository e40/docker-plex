#! /bin/bash

set -xeu

name=lsio-plex

current=$(docker ps -aqf name=$name)

if [ "$current" ]; then
    docker stop $current || true
    docker rm $(docker ps -aqf name=$name) || true
fi

# Had to remove HW transcoding when I updated
# to Rocky Linux 8.5, since /dev/dri doesn't
# exist there.  Upon further research, my
# Intel i7-4770K is really too old to do the HW
# transcoding anyway.
#       --device=/dev/dri:/dev/dri 

# On 3/3/2022 I got a new PLEX_CLAIM code, because
# I briefly pushed this file to a public repo on github.com.
# To do this, I went to 
#   https://www.plex.tv/claim/
# copied the code, pasted below and restarted the Plex server.
#
# Regarding the above, happened again on 5/31/2025, so FFS move the value
# into the env var PLEX_PLEXPASS!!!!

### WIP
#       --userns=keep-id

docker run \
       -d \
       --name $name \
       --network=host \
       --restart unless-stopped \
       -p 1900:1900/udp \
       -p 3005:3005/tcp \
       -p 32400:32400/tcp \
       -p 32410:32410/udp \
       -p 32412:32412/udp \
       -p 32413:32413/udp \
       -p 32414:32414/udp \
       -p 32469:32469/tcp \
       -p 5353:5353/udp \
       -p 8324:8324/tcp \
       -e TZ="America/Los_Angeles" \
       -e PLEX_CLAIM="$PLEX_PLEXPASS" \
       -e ADVERTISE_IP="$PLEX_ADVERTISE_IP" \
       -h box.known.net \
       -v /me/tplex/plex-config:/config \
       -v /me/tmp/pms-docker-plexinc-transcode-tmp:/transcode \
       -v /me/tplex/content:/data \
       -e VERSION=docker \
       -e PUID=$(id -u) \
       -e PGID=$(id -g) \
       -e CHANGE_CONFIG_DIR_OWNERSHIP=false \
       -e ALLOWED_NETWORKS=192.168.0.0/24 \
       --user root \
       my-$name

docker logs -f $(docker ps -aqf name=$name)
