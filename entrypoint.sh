#!/usr/bin/env bash
set -euo pipefail

PERSIST_DIRS=(.codex .config .railway .ssh)

sudo mkdir -p /data
sudo chown user:user /data

for dir in "${PERSIST_DIRS[@]}"; do
    mkdir -p "/data/$dir"
    rm -rf "$HOME/$dir"
    ln -s "/data/$dir" "$HOME/$dir"
done

chmod 700 "$HOME/.ssh"

if [ -d /opt/default-codex ]; then
    if [ ! -f /data/.codex/config.toml ] && [ -f /opt/default-codex/config.toml ]; then
        cp /opt/default-codex/config.toml /data/.codex/config.toml
    fi

    if [ ! -d /data/.codex/skills ] && [ -d /opt/default-codex/skills ]; then
        cp -a /opt/default-codex/skills /data/.codex/skills
    fi
fi

cd /data
exec sleep infinity
