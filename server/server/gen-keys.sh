#!/bin/bash
set -e
UUID=$(cat /proc/sys/kernel/random/uuid)
IP=$(curl -s ifconfig.me)
DOMAIN="www.mtnonline.com"

cat > /usr/local/etc/xray/config.json <<EOF
{
  "inbounds": [{
    "port": 443,
    "protocol": "vless",
    "settings": {
      "clients": [{"id": "$UUID"}],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "tcp",
      "security": "tls",
      "tlsSettings": {
        "serverName": "$DOMAIN",
        "certificates": [{"certificateFile":"/etc/xray/cert.pem","keyFile":"/etc/xray/key.pem"}]
      }
    }
  }],
  "outbounds": [{"protocol":"freedom"}]
}
EOF

# Self-signed cert with SNI domain
mkdir -p /etc/xray
openssl req -x509 -newkey rsa:2048 -nodes -keyout /etc/xray/key.pem \
  -out /etc/xray/cert.pem -days 3650 -subj "/CN=$DOMAIN"

systemctl restart xray
systemctl enable xray

echo ""
echo "===== IMPORT INTO v2rayNG ====="
echo "vless://$UUID@$IP:443?encryption=none&security=tls&sni=$DOMAIN&type=tcp&headerType=none#Godzilla"
echo "==============================="
