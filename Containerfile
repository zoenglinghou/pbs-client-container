FROM docker.io/debian:bookworm-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  ca-certificates \
  wget && \
  rm -rf /var/lib/apt/lists/*

RUN wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg \
  -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg && \
  sha512sum /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg | grep -q 7da6fe34168adc6e479327ba517796d4702fa2f8b4f0a9833f5ea6e6b48f6507a6da403a274fe201595edc86a84463d50383d07f64bdde2e3658108db7d6dc87 && \
  md5sum /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg | grep -q 41558dc019ef90bd0f6067644a51cf5b

RUN echo "deb http://download.proxmox.com/debian/pbs-client bookworm main" >> /etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  proxmox-backup-client && \
  rm -rf /var/lib/apt/lists/*
