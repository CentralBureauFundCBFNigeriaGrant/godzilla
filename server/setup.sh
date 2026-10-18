#!/bin/bash
set -e
# Godzilla server setup — idempotent
apt update -y
apt install -y curl wget unzip ufw iptables-persistent

# Xray
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

# IP forwarding
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-godzilla.conf
sysctl --system

# NAT
iptables -t nat -C POSTROUTING -s 10.66.66.0/24 -o eth0 -j MASQUERADE 2>/dev/null || \
iptables -t nat -A POSTROUTING -s 10.66.66.0/24 -o eth0 -j MASQUERADE
netfilter-persistent save

echo "[OK] Setup done. Run gen-keys.sh next."
