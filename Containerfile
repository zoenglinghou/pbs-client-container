FROM docker.io/debian:bullseye-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  ca-certificates \
  wget && \
  rm -rf /var/lib/apt/lists/*

RUN wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg \
  -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg && \
  sha512sum /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg | grep -q 7fb03ec8a1675723d2853b84aa4fdb49a46a3bb72b9951361488bfd19b29aab0a789a4f8c7406e71a69aabbc727c936d3549731c4659ffa1a08f44db8fdcebfa && \
  md5sum /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg | grep -q bcc35c7173e0845c0d6ad6470b70f50e

RUN echo "deb http://download.proxmox.com/debian/pbs-client bullseye main" >> /etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  proxmox-backup-client && \
  rm -rf /var/lib/apt/lists/*
