# Ubuntu Vagrant VM

A VirtualBox-backed Ubuntu 24.04 development VM managed by Vagrant.

## Requirements (host machine)

- [Vagrant](https://developer.hashicorp.com/vagrant/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 7.x (or newer)

## Setup

```sh
# 1. Clone this repo
git clone https://github.com/vibecoda/sandbox.git
cd sandbox

# 2. Create and edit your configuration
cp config.example.yaml config.yaml
# Open config.yaml and set your synced_folders paths and VM settings

# 3. Start the VM
vagrant up

# 4. SSH in
vagrant ssh
```

## Configuration

All VM settings live in `config.yaml` (gitignored). See `config.example.yaml` for the format:

| Setting | Default | Description |
|---|---|---|
| `vm.cpus` | `2` | CPU cores |
| `vm.memory` | `2048` | RAM in MB |
| `vm.hostname` | `ubuntu-vagrant` | VM hostname |
| `vm.ip` | `192.168.56.10` | Private network IP |
| `synced_folders` | (none) | Host ↔ guest folder mappings |

## What gets provisioned

The `provision.sh` script installs:

- **Build essentials**: `build-essential`, `libssl-dev`, `pkg-config`
- **Dev tools**: `git`, `curl`, `jq`, `ripgrep`, `fd-find`, `fzf`, `vim`, `unzip`
- **Languages / runtimes**:
  - Node.js LTS (via nvm) + yarn
  - Go (`golang-go`)
  - Rust (via rustup) + `aichat`
  - Bun
- **Python**: uv package manager
- **System**: `htop`, `net-tools`, `ca-certificates`, `file`

## SSH Port Forwarding (OpenClaw Gateway UI)

If you run [OpenClaw](https://openclaw.ai) on the VM, its gateway dashboard will be at `127.0.0.1:18789`. To reach it from your host machine, forward the port when you SSH in:

```sh
vagrant ssh -- -L 18789:127.0.0.1:18789
```

Then open **http://127.0.0.1:18789** in your host browser.

Or add it to your `~/.ssh/config` for convenience:

```
Host ubuntu-vagrant
  HostName 192.168.56.10
  User vagrant
  LocalForward 18789 127.0.0.1:18789
```

## Managing the VM

```sh
vagrant halt      # stop the VM
vagrant up        # start it again
vagrant destroy   # delete the VM (data in synced folders is safe)
vagrant provision # re-run provision.sh
vagrant ssh       # open an SSH session
```

## Customizing

Edit `provision.sh` to add or remove packages before running `vagrant up` (or re-provision with `vagrant provision` after editing).
