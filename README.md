# Proxmox Backup Client in Container Image

[![Container Image CI](https://github.com/zoenglinghou/pbs-client-container/actions/workflows/container-image.yml/badge.svg)](https://github.com/zoenglinghou/pbs-client-container/actions/workflows/container-image.yml)

This image contains the [Proxmox Backup Client](https://www.proxmox.com/en/proxmox-backup-server) for unsupported platforms.

## Usage

1. Mount the desired backup directory to the container
2. Define the settings via environment variables according to the [manual](https://pbs.proxmox.com/docs/backup-client.html)
3. Run the backup command in the cntainer

## Example

I use `ansible` to create a `podman` container, mount the directory to back up inside. Then I turn the container into a `systemd` service, and create a timer to back up accordingly.

~~I also enabled `podman-auto-update`.~~ In this setup, `podman-auto-update` doesn't work, since it only updates running containers, and all these contaienrs don't run constantly.

```yaml
---
- name: Ensure PBS client
  hosts: all
  become: true

  tasks:
    - name: Ensure pbs-client container
      containers.podman.podman_container:
        name: pbs-clien
        image: docker.io/zoenglinghou/pbs-client-container
        volumes:
          - "/data:/data:ro"
        env:
          PBS_REPOSITORY: ""
          PBS_PASSWORD: ""
          PBS_ENCRYPTION_PASSWORD: ""
          PBS_FINGERPRINT: ""
        label: io.containers.autoupdate=registry
        restart_policy: "no"
        command: proxmox-backup-client backup data.pxar:data --backup-id {{ inventory_hostname }}.data
        state: created

    - name: Generate systemd unit files
      containers.podman.podman_generate_systemd:
        name: pbs-client
        new: true
        dest: "/etc/systemd/system"

    - name: Ensure container timer
      ansible.builtin.copy:
        dest: /etc/systemd/system/container-pbs-client.timer
        mode: "0644"
        content: |
          [Unit]
          Description=Backup to pbs everyday at 10:30am

          [Timer]
          OnCalendar=*-*-* 10:30:00
          RandomizedDelaySec=1800

          [Install]
          WantedBy=timers.target

    - name: Enable container timer
      ansible.builtin.systemd:
        name: pod-pbs-client.timer
        daemon_reload: true
        state: started
        enabled: true
````
