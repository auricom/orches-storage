![orches logo](https://raw.githubusercontent.com/orches-team/common/main/orches-logo-text.png)

# orches-storage: Rootful orches for cayo-storage

This repository provides a rootful orches definition for [cayo-storage](https://github.com/auricom/cayo-storage), a simple git-ops implementation for orchestrating [Podman](https://podman.io/) containers and systemd.

## Quick Start

### 1. Deploy age private key

```bash
sudo mkdir -p /root/.config/sops/age
sudo nano /root/.config/sops/age/keys.txt
```
### 2. Initialize orches with this repository
```bash
sudo podman run --rm -it --pid=host --pull=newer \
  --mount \
    type=bind,source=/run/systemd,destination=/run/systemd \
  -v /var/lib/orches:/var/lib/orches \
  -v /etc/containers/systemd:/etc/containers/systemd  \
  ghcr.io/orches-team/orches init \
  https://github.com/auricom/orches-storage.git
```

### 3. Enable services unsupported by orches

```bash
sudo ln -s /var/lib/orches/repo/nut-drv.service.fallback /etc/systemd/system/nut-drv.service
sudo ln -s /var/lib/orches/repo/nut-mon.service.fallback /etc/systemd/system/nut-mon.service
sudo ln -s /var/lib/orches/repo/nut-srv.service.fallback /etc/systemd/system/nut-srv.service
sudo ln -s /var/lib/orches/repo/nas-photo-sorter.timer.fallback /etc/systemd/system/nas-photo-sorter.timer
systemctl daemon-reload
```

### 5. Verify orches and node-exporter are running
```bash
systemctl status orches
systemctl status node-exporter
sudo podman exec systemd-orches orches status
```
