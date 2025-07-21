![orches logo](https://raw.githubusercontent.com/orches-team/common/main/orches-logo-text.png)

# orches-storage: Rootful orches for cayo-storage

This repository provides a rootful orches definition for [cayo-storage](https://github.com/auricom/cayo-storage), a simple git-ops implementation for orchestrating [Podman](https://podman.io/) containers and systemd.

## Quick Start

### 1. Create required directories
```bash
sudo mkdir -p /var/lib/orches /etc/containers/systemd
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

### 3. Verify orches and node-exporter are running
```bash
systemctl status orches
systemctl status node-exporter
sudo podman exec systemd-orches orches status
```
