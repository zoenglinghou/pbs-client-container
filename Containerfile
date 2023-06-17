FROM docker.io/debian:bullseye-slim

RUN mkdir /etc/apt/sources.list.d && \
  echo "deb http://download.proxmox.com/debian/pbs-client bullseye main" > /etc/apt/sources.list.d/pbs-client.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  proxmox-backup-client && \
  rm -rf /var/lib/apt/lists/*
